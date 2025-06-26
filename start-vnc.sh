#!/bin/bash

# VNC Server Startup Script for Debian with XFCE4
# Uses tigervnc-standalone-server as per Debian best practices

LOG_FILE="/tmp/vnc-startup.log"

log() {
    echo "$(date): $1" | tee -a "$LOG_FILE"
}

log "Starting VNC server setup for Debian with XFCE4"

# Check if VNC password is set
if [ ! -f "$HOME/.vnc/passwd" ]; then
    log "ERROR: VNC password not set. Run 'vncpasswd' first"
    exit 1
fi

# Kill any existing VNC servers
log "Cleaning up existing VNC servers"
vncserver -kill :1 2>/dev/null
pkill -f "Xvnc" 2>/dev/null
sleep 2

# Ensure ~/.vnc/xstartup exists and is properly configured for XFCE4
if [ ! -f "$HOME/.vnc/xstartup" ]; then
    log "Creating XFCE4 startup script at ~/.vnc/xstartup"
    mkdir -p "$HOME/.vnc"
    cat > "$HOME/.vnc/xstartup" << 'EOF'
#!/bin/sh
xrdb $HOME/.Xresources
startxfce4 &
EOF
    chmod +x "$HOME/.vnc/xstartup"
    log "Created XFCE4 startup script"
else
    log "Using existing ~/.vnc/xstartup"
fi

# Start VNC server on display :1 (port 5901)
log "Starting VNC server on display :1 (port 5901)"
if vncserver :1 -geometry 1920x1080 -depth 24 > /tmp/vnc-startup.log 2>&1; then
    log "VNC server started successfully on display :1"
    
    # Get server IP for external access
    server_ip=$(hostname -I | awk '{print $1}')
    log "Connect from Mac using:"
    log "  Finder → Go → Connect to Server → vnc://$server_ip:5901"
    log "Or using VNC client: $server_ip:5901"
    log "Locally: vnc://localhost:5901"
    log ""
    log "To stop VNC server: vncserver -kill :1"
    log "To view VNC processes: ps aux | grep vnc"
    
    # Verify it's listening on port 5901
    sleep 3
    if ss -tulpn | grep -q ":5901"; then
        log "✓ VNC server is listening on port 5901"
        
        # Check if firewall allows the port
        if command -v ufw >/dev/null 2>&1; then
            if ! ufw status | grep -q "5901"; then
                log "⚠ Firewall may be blocking port 5901. Run: sudo ufw allow 5901/tcp"
            fi
        fi
        
        log "VNC server setup completed successfully!"
        exit 0
    else
        log "⚠ VNC server started but not detected on port 5901"
        log "Check logs with: cat ~/.vnc/*.log"
        exit 1
    fi
else
    log "✗ Failed to start VNC server"
    log "Error details:"
    cat /tmp/vnc-startup.log >> "$LOG_FILE"
    log "Try running: vncserver manually to see detailed errors"
    exit 1
fi