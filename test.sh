#!/bin/bash

# Ensure remote control is enabled
mkdir -p ~/.config/tmate
echo "set -g tmate-allow-remote-control on" > ~/.tmate.conf

# Start tmate session in background
tmate -S /tmp/tmate.sock new-session -d

# Wait for the session to be ready
echo "[*] Waiting for tmate session to be ready..."
tmate -S /tmp/tmate.sock wait tmate-ready

# Show access links
echo "[+] Web (browser) access:"
tmate -S /tmp/tmate.sock display -p '#{tmate_web}'

echo "[+] SSH access:"
tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}'

# Keep script running
echo "[*] Session is live. Press Ctrl+C to quit."
tail -f /dev/null
