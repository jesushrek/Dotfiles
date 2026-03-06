#!/bin/sh
xclip -selection clipboard -t image/png -o > /tmp/clp.png && sxiv /tmp/clp.png
