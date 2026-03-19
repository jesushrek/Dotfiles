#!/bin/bash

USAGE_DIR="${HOME}/personal/usage"
INTERVAL=5
TEMP_MD="/tmp/usage_combined.md"
TEMP_PDF="/tmp/usage_report.pdf"

SELECTED=$(ls -1 "$USAGE_DIR"/*.md 2>/dev/null | xargs -n 1 basename | sort -r | dmenu -i -p "Generate Report For:" -l 10)
[ -z "$SELECTED" ] && exit 0
LOG_FILE="$USAGE_DIR/$SELECTED"

{
    echo "% App Usage Report"
    echo "% Date: $SELECTED"
    echo ""

    echo "# 1. Summary of Time Spent"
    echo "| Application | Duration (HH:MM:SS) |"
    echo "| :--- | :--- |"

    awk -v intv="$INTERVAL" -F '|' 'NR > 3 {
        app = $3; gsub(/\*/, "", app); gsub(/^[ \t]+|[ \t]+$/, "", app);
        if (app != "") { sum[app] += intv; total += intv }
        } END {
            for (a in sum) {
                h = int(sum[a] / 3600); m = int((sum[a] % 3600) / 60); s = sum[a] % 60;
                printf "| %-20s | %02d:%02d:%02d |\n", a, h, m, s
}
th = int(total / 3600); tm = int((total % 3600) / 60); ts = total % 60;
printf "| **GRAND TOTAL** | **%02d:%02d:%02d** |\n", th, tm, ts
}' "$LOG_FILE" | sort -t '|' -k3 -nr

echo -e '\n\n`\\newpage`{=latex}\n\n'

echo "# 2. Activity"
echo "| Start Time | Application | Activity / Window Title |"
echo "| :--- | :--- | :--- |"

awk -F '|' 'NR > 3 {
    time = $2; app = $3; title = $4;
    gsub(/^[ \t]+|[ \t]+$/, "", time);
    gsub(/\*/, "", app); gsub(/^[ \t]+|[ \t]+$/, "", app);
    gsub(/^[ \t]+|[ \t]+$/, "", title);

    # Only print if the App OR the Title has changed from the last line
    if (app != last_app || title != last_title) {
        if (time != "") {
            printf "| %s | %s | %s |\n", time, app, title
            last_app = app
            last_title = title
}
}
}' "$LOG_FILE"

} > "$TEMP_MD"

sed -i 's/\xe2\x80\x8e//g' "$TEMP_MD"

pandoc "$TEMP_MD" \
    --pdf-engine=xelatex \
    -V mainfont="FreeSerif" \
    --variable geometry:margin=1in \
    -s -o "$TEMP_PDF"

if [ -f "$TEMP_PDF" ]; then
    zathura "$TEMP_PDF" &
fi
