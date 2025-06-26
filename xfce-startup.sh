#!/bin/bash

# XFCE Desktop Startup Script for VNC
# Provides a full desktop environment

# Clean environment
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

# Set up environment
export XDG_CURRENT_DESKTOP=XFCE
export XDG_SESSION_DESKTOP=xfce
export DESKTOP_SESSION=xfce

# Start D-Bus session
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    if command -v dbus-launch >/dev/null 2>&1; then
        eval $(dbus-launch --sh-syntax --exit-with-session)
        export DBUS_SESSION_BUS_ADDRESS
    else
        log "Warning: dbus-launch not found, desktop features may be limited"
    fi
fi

# Set background
xsetroot -solid "#336699" &

# Start XFCE components in order
log() {
    echo "$(date): XFCE: $1" >> /tmp/xfce-startup.log
}

log "Starting XFCE desktop environment"

# Start essential XFCE components
log "Starting xfce4-session"
exec startxfce4