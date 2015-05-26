#!/bin/bash

status=$(/root/bin/dropbox.py status)
#running=$(/root/bin/dropbox.py running)

echo "Status: $status"
if $(/root/bin/dropbox.py running) && [$? -eq 0]; then
        echo "Warning: dropbox not running"
else
        echo "Dropbox running"
fi