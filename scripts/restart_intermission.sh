#!/bin/bash

# Check if Intermission is running
if ! pgrep -f "LookAway" > /dev/null
then
    # Start Intermission if not running
    open -a LookAway
fi
