#!/bin/bash

# Desktop VNC Server Script
# Starts a full desktop environment accessible via VNC

LOG_FILE="/tmp/desktop-vnc.log"

log() {
    echo "$(date): $1" | tee -a "$LOG_FILE"
}

log "Starting Desktop VNC server"

# Kill any existing VNC servers
pkill -f "Xvnc" 2>/dev/null
pkill -f "x11vnc" 2>/dev/null
sleep 1

# Check if VNC password is set
if [ ! -f "$HOME/.vnc/passwd" ]; then
    log "Setting up VNC password..."
    echo "Creating default VNC password file"
    mkdir -p ~/.vnc
    # Create a simple password file (you should set a real password)
    echo "vnc123" | vncpasswd -f > ~/.vnc/passwd
    chmod 600 ~/.vnc/passwd
fi

# Find available display and start VNC server with full desktop
for display in {1..10}; do
    port=$((5900 + display))
    log "Trying VNC desktop on display :$display (port $port)"
    
    if vncserver :$display \
        -geometry 1920x1080 \
        -depth 24 \
        -localhost no \
        -SecurityTypes VncAuth \
        -AlwaysShared \
        -xstartup /home/pt/claudia/xfce-startup.sh \
        > /tmp/vnc-desktop.log 2>&1; then
        
        log "VNC desktop server started successfully on display :$display (port $port)"
        log "Connect using: vncviewer 192.168.18.144:$port"
        log "Desktop: Full XFCE environment"
        
        # Verify it's listening
        sleep 3
        if ss -tulpn | grep -q ":$port"; then
            log "VNC server confirmed listening on port $port"
            exit 0
        else
            log "Warning: VNC server may not be accessible on port $port"
        fi
        exit 0
    else
        log "Failed to start on display :$display"
        cat /tmp/vnc-desktop.log >> "$LOG_FILE"
    fi
done

log "ERROR: Could not start VNC desktop server on any display"
exit 1