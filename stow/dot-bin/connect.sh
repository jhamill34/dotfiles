#!/bin/bash
# connect.sh
# Connect to Raspberry Pi Zero hardware key and forward SSH/GPG agents
#
# This script detects the Pi Zero serial device, creates socket forwarders
# using socat, and exports environment variables for SSH and GPG to use.

set -e  # Exit on error

echo "====================================="
echo "Hardware Key Connection"
echo "====================================="
echo

# Configuration
SOCKET_DIR="/tmp/hardware-key"
PID_DIR="$SOCKET_DIR/pids"
SSH_SOCK="$SOCKET_DIR/ssh-agent.sock"
GPG_SOCK="$SOCKET_DIR/S.gpg-agent"
LOCAL_BIN="$HOME/.local/bin"
SOCAT_VERSION="1.8.0.1"

# Detect platform
OS_TYPE="$(uname -s)"

# Add local bin to PATH if it exists
if [ -d "$LOCAL_BIN" ]; then
    export PATH="$LOCAL_BIN:$PATH"
fi

# Function to build socat from source
build_socat() {
    echo "  Building socat from source..."

    local build_dir="$SOCKET_DIR/build"
    mkdir -p "$build_dir"
    mkdir -p "$LOCAL_BIN"

    cd "$build_dir"

    # Download
    echo "  Downloading socat-$SOCAT_VERSION..."
    if ! curl -fsSL -O "http://www.dest-unreach.org/socat/download/socat-$SOCAT_VERSION.tar.gz"; then
        echo "  ✗ Failed to download socat"
        exit 1
    fi

    # Extract
    echo "  Extracting..."
    tar xzf "socat-$SOCAT_VERSION.tar.gz"
    cd "socat-$SOCAT_VERSION"

    # Build
    echo "  Configuring..."
    if ! ./configure --prefix="$HOME/.local" > "$build_dir/configure.log" 2>&1; then
        echo "  ✗ Configure failed. Check $build_dir/configure.log"
        exit 1
    fi

    echo "  Compiling..."
    if ! make > "$build_dir/make.log" 2>&1; then
        echo "  ✗ Build failed. Check $build_dir/make.log"
        exit 1
    fi

    # Install
    echo "  Installing to $LOCAL_BIN..."
    if ! make install > "$build_dir/install.log" 2>&1; then
        echo "  ✗ Install failed. Check $build_dir/install.log"
        exit 1
    fi

    # Return to original directory
    cd - > /dev/null

    # Add to PATH for this session
    export PATH="$LOCAL_BIN:$PATH"

    echo "  ✓ socat built and installed to $LOCAL_BIN"
    echo
    echo "  Add this to your shell config to make it permanent:"
    echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo
}

# Function to detect serial device
detect_device() {
    local device=""

    case "$OS_TYPE" in
        Darwin)
            # macOS: Look for cu.usbmodem* devices
            device=$(ls /dev/cu.usbmodem* 2>/dev/null | head -n1)
            ;;
        Linux)
            # Linux: Look for ttyACM* devices
            device=$(ls /dev/ttyACM* 2>/dev/null | head -n1)
            ;;
        *)
            echo "  ✗ Unsupported platform: $OS_TYPE"
            exit 1
            ;;
    esac

    echo "$device"
}

# Function to check if socat is installed, build from source if not
check_socat() {
    if command -v socat &> /dev/null; then
        return 0
    fi

    echo "  socat not found, will build from source..."
    echo

    # Check for build dependencies
    if ! command -v curl &> /dev/null; then
        echo "  ✗ curl is required to download socat"
        exit 1
    fi

    if ! command -v make &> /dev/null; then
        echo "  ✗ make is required to build socat"
        case "$OS_TYPE" in
            Darwin)
                echo "  Install Xcode command line tools: xcode-select --install"
                ;;
        esac
        exit 1
    fi

    build_socat
}

# Function to cleanup old connections
cleanup_old() {
    if [ -d "$PID_DIR" ]; then
        for pidfile in "$PID_DIR"/*.pid; do
            if [ -f "$pidfile" ]; then
                pid=$(cat "$pidfile")
                if kill -0 "$pid" 2>/dev/null; then
                    echo "  Stopping old socat process (PID: $pid)..."
                    kill "$pid" 2>/dev/null || true
                fi
                rm -f "$pidfile"
            fi
        done
    fi

    # Remove old socket files
    rm -f "$SSH_SOCK" "$GPG_SOCK"
}

# Main execution
echo "[1/6] Checking prerequisites..."
check_socat
echo "  ✓ socat installed"
echo

echo "[2/6] Detecting Pi Zero device..."
DEVICE="${HARDWARE_KEY_DEVICE:-$(detect_device)}"

if [ -z "$DEVICE" ]; then
    echo "  ✗ Pi Zero not found"
    echo
    echo "Expected devices:"
    case "$OS_TYPE" in
        Darwin)
            echo "  - /dev/cu.usbmodem* (macOS)"
            ;;
        Linux)
            echo "  - /dev/ttyACM0 (Linux)"
            ;;
    esac
    echo
    echo "Troubleshooting:"
    echo "  1. Ensure Pi Zero is connected via USB data port (not power)"
    echo "  2. Check if USB gadget is configured (see pi-zero/README.md)"
    echo "  3. Try: ls -la /dev/*usb* /dev/ttyACM*"
    echo "  4. Override device: export HARDWARE_KEY_DEVICE=/dev/your-device"
    exit 1
fi

echo "  ✓ Found device: $DEVICE"
echo

echo "[3/6] Cleaning up old connections..."
cleanup_old
echo "  ✓ Cleanup complete"
echo

echo "[4/6] Creating socket directories..."
mkdir -p "$SOCKET_DIR" "$PID_DIR"
echo "  ✓ Directories created"
echo

echo "[5/6] Starting socket forwarders..."

# SSH Agent forwarding
# The Pi-side serial-agent-bridge.service connects /dev/ttyGS0 to the GPG agent.
# We create a local socket that forwards to the serial device.
echo "  Starting SSH agent forwarder..."
socat "UNIX-LISTEN:$SSH_SOCK,fork,unlink-early" \
      "$DEVICE,raw,echo=0" \
      > "$SOCKET_DIR/ssh-socat.log" 2>&1 &
SSH_SOCAT_PID=$!
echo "$SSH_SOCAT_PID" > "$PID_DIR/ssh-socat.pid"
sleep 1

if ! kill -0 "$SSH_SOCAT_PID" 2>/dev/null; then
    echo "  ✗ Failed to start SSH forwarder"
    echo "  Check log: $SOCKET_DIR/ssh-socat.log"
    exit 1
fi
echo "  ✓ SSH forwarder started (PID: $SSH_SOCAT_PID)"
echo "  ✓ All forwarders started"
echo

echo "[6/6] Configuring environment..."

# Export environment variables
export SSH_AUTH_SOCK="$SSH_SOCK"

# Create environment file for easy sourcing (bash/zsh)
cat > "$SOCKET_DIR/env.sh" << EOF
# Hardware Key Environment Variables
# Source this file to configure your shell

export SSH_AUTH_SOCK="$SSH_SOCK"
export HARDWARE_KEY_DEVICE="$DEVICE"
export HARDWARE_KEY_SOCKET_DIR="$SOCKET_DIR"

# Convenience aliases
alias hw-disconnect="$PWD/disconnect.sh"
alias hw-test="$PWD/test-connection.sh"
EOF

# Create environment file for Nushell
cat > "$SOCKET_DIR/env.nu" << EOF
# Hardware Key Environment Variables
# Source this file to configure your shell: source /tmp/hardware-key/env.nu

\$env.SSH_AUTH_SOCK = "$SSH_SOCK"
\$env.HARDWARE_KEY_DEVICE = "$DEVICE"
\$env.HARDWARE_KEY_SOCKET_DIR = "$SOCKET_DIR"

# Convenience aliases
alias hw-disconnect = bash $PWD/disconnect.sh
alias hw-test = bash $PWD/test-connection.sh
EOF

echo "  ✓ Environment configured"
echo

echo "====================================="
echo "Connection Successful!"
echo "====================================="
echo
echo "Environment variables set:"
echo "  SSH_AUTH_SOCK=$SSH_SOCK"
echo
echo "To use in your current shell, run:"
echo "  source $SOCKET_DIR/env.sh     # bash/zsh"
echo "  source $SOCKET_DIR/env.nu     # nushell"
echo
echo "Test the connection:"
echo "  ./test-connection.sh"
echo
echo "When done, disconnect:"
echo "  ./disconnect.sh"
echo
echo "====================================="

