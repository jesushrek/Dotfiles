#!/bin/env bash 

i3() {
    if pgrep -x i3 >/dev/null; then
        i3-msg reload
        echo "i3: i3 colorscheme set"
    fi
}
i3

#!/bin/env bash 

polybar() {
    if command -v polybar >/dev/null && pgrep polybar >/dev/null; then
        pkill -USR1 polybar
        echo "Polybar: polybar colorscheme set"
    fi
}


polybar
