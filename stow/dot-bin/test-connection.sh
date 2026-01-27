#!/bin/bash
# test-connection.sh
# Test connection to Raspberry Pi Zero hardware key
#
# This script performs various tests to verify that the hardware key
# is properly connected and agents are accessible.

echo "====================================="
echo "Hardware Key Connection Test"
echo "====================================="
echo

SOCKET_DIR="/tmp/hardware-key"
all_passed=true

# Test 1: Check if connection is active
echo "[Test 1/5] Connection Status"
if [ ! -d "$SOCKET_DIR" ]; then
    echo "  ✗ FAILED: No connection found"
    echo "  Run: ./connect.sh"
    exit 1
fi
echo "  ✓ PASSED: Connection directory exists"
echo

# Test 2: Check if forwarders are running
echo "[Test 2/5] Forwarder Processes"
forwarders_running=0

if [ -d "$SOCKET_DIR/pids" ]; then
    for pidfile in "$SOCKET_DIR/pids"/*.pid; do
        if [ -f "$pidfile" ]; then
            pid=$(cat "$pidfile")
            name=$(basename "$pidfile" .pid)

            if kill -0 "$pid" 2>/dev/null; then
                echo "  ✓ $name running (PID: $pid)"
                forwarders_running=$((forwarders_running + 1))
            else
                echo "  ✗ $name not running (stale PID: $pid)"
                all_passed=false
            fi
        fi
    done
fi

if [ $forwarders_running -eq 0 ]; then
    echo "  ✗ FAILED: No forwarders running"
    all_passed=false
else
    echo "  Summary: $forwarders_running forwarder(s) active"
fi
echo

# Test 3: Check environment variables
echo "[Test 3/5] Environment Variables"
if [ -n "$SSH_AUTH_SOCK" ]; then
    echo "  ✓ SSH_AUTH_SOCK is set"
    echo "    Value: $SSH_AUTH_SOCK"
else
    echo "  ✗ SSH_AUTH_SOCK not set"
    echo "    Run: source $SOCKET_DIR/env.sh"
    all_passed=false
fi

if [ -n "$HARDWARE_KEY_DEVICE" ]; then
    echo "  ✓ HARDWARE_KEY_DEVICE is set"
    echo "    Value: $HARDWARE_KEY_DEVICE"
else
    echo "  ⚠ HARDWARE_KEY_DEVICE not set (optional)"
fi
echo

# Test 4: Check socket files
echo "[Test 4/5] Socket Files"
SSH_SOCK="$SOCKET_DIR/ssh-agent.sock"

if [ -S "$SSH_SOCK" ]; then
    echo "  ✓ SSH socket exists: $SSH_SOCK"
else
    echo "  ✗ SSH socket not found: $SSH_SOCK"
    all_passed=false
fi
echo

# Test 5: Test SSH agent
echo "[Test 5/5] SSH Agent Functionality"
if [ -n "$SSH_AUTH_SOCK" ] && [ -S "$SSH_AUTH_SOCK" ]; then
    echo "  Testing SSH agent..."

    if ssh-add -l &>/dev/null; then
        echo "  ✓ SSH agent responding"
        echo
        echo "  Loaded keys:"
        ssh-add -l | sed 's/^/    /'
    elif [ $? -eq 1 ]; then
        echo "  ⚠ SSH agent responding but no keys loaded"
        echo "    This may be normal if you haven't added keys yet"
    else
        echo "  ✗ SSH agent not responding"
        all_passed=false
    fi
else
    echo "  ✗ Cannot test - SSH_AUTH_SOCK not properly set"
    all_passed=false
fi
echo

# Optional: Test GitHub SSH
echo "[Optional] GitHub SSH Test"
echo "  Testing SSH connection to GitHub..."
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo "  ✓ GitHub authentication successful"
elif ssh -T git@github.com 2>&1 | grep -q "You've successfully authenticated"; then
    echo "  ✓ GitHub authentication successful"
else
    echo "  ⚠ GitHub authentication may have failed (or no key configured)"
    echo "    This is normal if you haven't added your key to GitHub yet"
fi
echo

# Summary
echo "====================================="
if [ "$all_passed" = true ]; then
    echo "All Tests PASSED ✓"
    echo "====================================="
    echo
    echo "Your hardware key is ready to use!"
    echo
    echo "Try it out:"
    echo "  ssh -T git@github.com"
    echo "  git commit -S -m 'Signed with hardware key'"
else
    echo "Some Tests FAILED ✗"
    echo "====================================="
    echo
    echo "Troubleshooting:"
    echo "  1. Check connection: ./connect.sh"
    echo "  2. Check Pi Zero is connected via USB"
    echo "  3. Verify agents are running on Pi Zero"
    echo "  4. Check logs in: $SOCKET_DIR/"
    echo "  5. See docs/TROUBLESHOOTING.md"
fi
echo
echo "====================================="
