#!/bin/sh

game=$( find -name start.sh | dmenu )
"$game"
