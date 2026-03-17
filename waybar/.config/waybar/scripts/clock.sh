#!/bin/bash
TIME=$(date "+%H:%M")
BLUE="#33ccff"

CALENDAR=$(python3 -c "
import subprocess, datetime, re, html

cal = subprocess.check_output(['cal', '-m']).decode().rstrip()
today = datetime.date.today().day
current_month = datetime.date.today().strftime('%B')
blue = '$BLUE'

lines = cal.split('\n')
result = []
for i, line in enumerate(lines):
    safe = html.escape(line)
    if i == 0:
        colored = safe.replace(current_month,
            '<span color=\"' + blue + '\">' + current_month + '</span>')
        result.append(colored)
    else:
        day_str = str(today).rjust(2)
        colored = re.sub(r'(?<!\d)' + re.escape(day_str) + r'(?!\d)',
                         '<span color=\"' + blue + '\">' + day_str + '</span>', safe)
        result.append(colored)

content = '\n'.join(result)
print('<span font_family=\"monospace\" weight=\"bold\">' + content + '</span>')
")

jq -cn --arg text " $TIME " --arg tooltip "$CALENDAR" '{text: $text, tooltip: $tooltip}'
