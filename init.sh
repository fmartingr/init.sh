#!/bin/bash

TMP_DIR="/tmp/initsh"
SCRIPTS_DIR="$HOME/.init"
INIT_FILES="$SCRIPTS_DIR/*.sh"

function debug_echo {
    if [ "DEBUG" == "1" ]; then
        echo $@
    fi
}

# Create temp folder to store pid files
if [ ! -d "$TMP_DIR" ]; then
   mkdir $TMP_DIR
fi

# Check if init script folder exists
if [ ! -d "$SCRIPTS_DIR" ]; then exit; fi

# Get all init scripts
shopt -s nullglob # Avoid expanding path to wildcard if empty
for init_script in $INIT_FILES
do
    # Get the filename
    filename=$(basename $init_script)
    debug_echo "==> Filename: $filename"

    # Check if we executed this one before.
    if [ -f "$TMP_DIR/$filename.pid" ]; then
        # File with a pid exists, check it.
        script_pid=$(cat $TMP_DIR/$filename.pid)
        if [ ! -f "/proc/$script_pid/status" ]; then
            # Process doesn't seem to be running now.
            # Delete the .pid file and execute it again.
            rm $TMP_DIR/$filename.*
            debug_echo "Removed $TMP_DIR/$filename.pid cause script wasn't running."
        else
            # Process seem to be running. Leave it alone.
            debug_echo "Continue..."
            continue
        fi
    fi

    # Execute script on background and get its PID
    debug_echo "Executing..."
    bash $init_script &> $TMP_DIR/$filename.stdout.log 2> $TMP_DIR/$filename.stderr.log &disown

    script_pid=$!
    debug_echo "Pid: $script_pid"

    # Store the pid on the file pidfile on the temp folder
    echo $script_pid > $TMP_DIR/$filename.pid
    debug_echo "Create $TMP_DIR/$filename.pid file"
done
