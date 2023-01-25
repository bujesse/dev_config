#!/usr/bin/env bash

# Copy over ssh (linux to windows)
# 1. Install inotifywait on the guest with: sudo yum install inotify-tools
# 2. Create file: ~/.clipboard
# 3. Run this from powershell:
# while (1) {
#         ssh vagrant 'inotifywait -qq -e close_write ~/.clipboard; cat ~/.clipboard' | Set-Clipboard
# }

cat - > ~/.clipboard
