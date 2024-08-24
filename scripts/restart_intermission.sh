#!/bin/bash

# Function to open an app only if it's not running
start_app_if_not_running() {
    app_name="$1"
    app_process="$2"
    
    # Check if the app is running
    if ! pgrep -f "$app_process" > /dev/null
    then
        # Start the app in the background without bringing it to the front
        open -g -a "$app_name"
    fi
}

# INFO: Function to check if font smoothing is enabled and disable it as it causes eye strain
check_and_disable_font_smoothing() {
    # Read the current value of AppleFontSmoothing
    font_smoothing=$(defaults -currentHost read -g AppleFontSmoothing 2>/dev/null)

    # If font smoothing is enabled (value is 1 or more), disable it
    if [ "$font_smoothing" -ge 1 ]; then
        echo "Font smoothing is enabled. Disabling it..."
        defaults -currentHost write -g AppleFontSmoothing -int 0
        echo "Font smoothing has been disabled."
    else
        echo "Font smoothing is already disabled."
    fi
}

# Start LookAway and Stillcolor if they are not running
start_app_if_not_running "LookAway" "LookAway"
start_app_if_not_running "Stillcolor" "Stillcolor"

# Check and disable font smoothing if it's enabled
check_and_disable_font_smoothing
