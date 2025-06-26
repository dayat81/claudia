#!/bin/bash

# Simple VNC Server Script - Working Version
# This script starts VNC server on port 5901 (or next available)

LOG_FILE="/tmp/vnc-startup.log"

log() {
    echo "$(date): $1" | tee -a "$LOG_FILE"
}

log "Starting VNC server"

# Kill all existing VNC servers
pkill -f "Xvnc" 2>/dev/null
sleep 1

# Start VNC on display :1, if it fails try :2, :3, etc.
for display in {1..10}; do
    log "Trying display :$display"
    
    if vncserver :$display -geometry 1920x1080 -depth 24 -localhost no > /tmp/vnc-try.log 2>&1; then
        port=$((5900 + display))
        log "VNC server started successfully on display :$display (port $port)"
        log "Connect using: vncviewer 192.168.18.144:$port"
        log "To stop: vncserver -kill :$display"
        
        # Verify it's listening on all interfaces
        sleep 2
        if ss -tulpn | grep ":$port" | grep -q "0.0.0.0"; then
            log "VNC server is accessible from external connections"
        else
            log "Warning: VNC server may only be accessible locally"
        fi
        
        exit 0
    else
        log "Failed to start on display :$display"
        cat /tmp/vnc-try.log >> "$LOG_FILE"
    fi
done

log "ERROR: Could not start VNC server on any display"
exit 1