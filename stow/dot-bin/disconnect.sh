#!/bin/bash
# disconnect.sh
# Disconnect from Raspberry Pi Zero hardware key
#
# This script stops all socat processes, removes socket files,
# and cleans up the environment.

set -e  # Exit on error

echo "====================================="
echo "Hardware Key Disconnection"
echo "====================================="
echo

# Configuration
SOCKET_DIR="/tmp/hardware-key"
PID_DIR="$SOCKET_DIR/pids"

# Check if connection exists
if [ ! -d "$SOCKET_DIR" ]; then
    echo "  ℹ No active connection found"
    exit 0
fi

# Stop socat processes
echo "[1/3] Stopping forwarders..."
stopped=0

if [ -d "$PID_DIR" ]; then
    for pidfile in "$PID_DIR"/*.pid; do
        if [ -f "$pidfile" ]; then
            pid=$(cat "$pidfile")
            name=$(basename "$pidfile" .pid)

            if kill -0 "$pid" 2>/dev/null; then
                echo "  Stopping $name (PID: $pid)..."
                kill "$pid" 2>/dev/null || true
                stopped=$((stopped + 1))
            fi

            rm -f "$pidfile"
        fi
    done
fi

if [ $stopped -eq 0 ]; then
    echo "  - No running forwarders found"
else
    echo "  ✓ Stopped $stopped forwarder(s)"
fi
echo

# Remove socket files
echo "[2/3] Cleaning up socket files..."
removed=0

if [ -f "$SOCKET_DIR/ssh-agent.sock" ]; then
    rm -f "$SOCKET_DIR/ssh-agent.sock"
    removed=$((removed + 1))
fi

if [ -f "$SOCKET_DIR/S.gpg-agent" ]; then
    rm -f "$SOCKET_DIR/S.gpg-agent"
    removed=$((removed + 1))
fi

if [ $removed -eq 0 ]; then
    echo "  - No socket files to remove"
else
    echo "  ✓ Removed $removed socket file(s)"
fi
echo

# Clean up directory
echo "[3/3] Cleaning up directories..."
rm -f "$SOCKET_DIR/env.sh"
rm -f "$SOCKET_DIR"/*.log
rmdir "$PID_DIR" 2>/dev/null || true

if [ -d "$SOCKET_DIR" ] && [ -z "$(ls -A "$SOCKET_DIR")" ]; then
    rmdir "$SOCKET_DIR"
    echo "  ✓ Removed $SOCKET_DIR"
else
    echo "  - $SOCKET_DIR not empty, keeping"
fi
echo

echo "====================================="
echo "Disconnected Successfully!"
echo "====================================="
echo
echo "Environment variables still set in current shell:"
echo "  SSH_AUTH_SOCK=${SSH_AUTH_SOCK:-<not set>}"
echo
echo "To clear them, run:"
echo "  unset SSH_AUTH_SOCK"
echo "  unset HARDWARE_KEY_DEVICE"
echo "  unset HARDWARE_KEY_SOCKET_DIR"
echo
echo "Or simply start a new shell."
echo "====================================="
