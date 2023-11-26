#!/bin/bash

# Check if Intermission is running
if ! pgrep -f "Intermission" > /dev/null
then
    # Start Intermission if not running
    open -a Intermission
fi
