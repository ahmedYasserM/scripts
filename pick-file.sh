#!/bin/bash

# Define a temporary file to store the chosen path
CHOOSER_FILE="/tmp/spf-selected"

# Launch superfile in picker mode
spf --chooser-file="$CHOOSER_FILE"

# Check if a file was actually picked
if [ -f "$CHOOSER_FILE" ] && [ -s "$CHOOSER_FILE" ]; then
    SELECTED_PATH=$(cat "$CHOOSER_FILE")
    echo "You picked: $SELECTED_PATH"
    
    # Do something with the file here, e.g., open it in your editor:
    # nvim "$SELECTED_PATH"

    # Clean up the temporary file
    rm "$CHOOSER_FILE"
else
    echo "No file selected or operation cancelled."
fi

