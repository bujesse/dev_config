#!/bin/sh

vim="vim $1 $2 $3"
osascript -e "
tell application \"iTerm\"
    set myterm to (create window with default profile)
    tell myterm
        activate current session
        launch session \"Default Session\"
        tell the current session
            write text \"$vim\"
       end tell
   end tell
end tell
"
