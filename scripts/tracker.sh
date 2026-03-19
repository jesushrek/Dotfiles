#!/bin/bash

USAGE_DIR="${HOME}/personal/usage"
INTERVAL=5

if [ ! -d "${USAGE_DIR}" ]; then
    mkdir -p "$USAGE_DIR"
fi

while true; do
    CURRENT_DATE=$(date +%Y-%m-%d)
    LOG_FILE="${USAGE_DIR}/${CURRENT_DATE}.md"

    if [ ! -f "$LOG_FILE" ]; then
        echo "# App usage for - ${CURRENT_DATE}" > "${LOG_FILE}"
        echo "| Timestamp | App | Window Title |" >> "${LOG_FILE}"
        echo "|--- |--- |--- |" >> "${LOG_FILE}"
    fi

    WINDOW_ID=$(xdotool getactivewindow 2>/dev/null)
    
    if [ -n "${WINDOW_ID}" ]; then
        APP_NAME=$(xprop -id "${WINDOW_ID}" WM_CLASS | awk -F '"' '{print $4}')
        WINDOW_TITLE=$(xdotool getwindowname "${WINDOW_ID}" | tr '|' '-')
        
        echo "| $(date '+%H:%M:%S') | **${APP_NAME}** | ${WINDOW_TITLE} |" >> "${LOG_FILE}"
    fi

    sleep "$INTERVAL"
done
