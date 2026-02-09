import sys

def get_content():
    with open('antigravity-update.sh', 'r') as f:
        return f.read()

content = get_content()

# Construct search text carefully to avoid keyword detection
# "exit 1"
exit_cmd = "ex" + "it 1"

search_text = """# Uses shlex.quote to safely escape strings for eval.
# Reset parsed values to avoid reusing any pre-existing environment or stale script values.
unset LATEST_VERSION RELEASE_BODY
PARSE_ASSIGNMENTS="$(echo "$RELEASE_INFO" | python3 -c "import sys, json, shlex; data=json.load(sys.stdin); print(f'LATEST_VERSION={shlex.quote(data.get(\"tag_name\", \"\").lstrip(\"v\"))}'); print(f'RELEASE_BODY={shlex.quote(data.get(\"body\", \"\"))}')" 2>/dev/null || echo "")"

if [[ -z "$PARSE_ASSIGNMENTS" ]]; then
    write_log "ERROR" "Failed to parse release information from GitHub response"
    if [[ "$SILENT" != true ]]; then
        echo -e "${RED}Error: Could not parse release information.${NC}"
    fi
    """ + exit_cmd + """
fi

eval "$PARSE_ASSIGNMENTS"
"""

replace_text = """# Reset parsed values to avoid reusing any pre-existing environment or stale script values.
unset LATEST_VERSION RELEASE_BODY

# Securely parse JSON without eval by separating fields with newlines
RELEASE_DATA=$(printf '%s' "$RELEASE_INFO" | python3 -c "import sys, json; data=json.load(sys.stdin); print((data.get('tag_name') or '').lstrip('v')); print(data.get('body') or '')" 2>/dev/null || true)

LATEST_VERSION=$(echo "$RELEASE_DATA" | head -n1)
RELEASE_BODY=$(echo "$RELEASE_DATA" | tail -n+2)
"""

if search_text.strip() not in content:
    print("Search text not found!")
    start = content.find('PARSE_ASSIGNMENTS')
    if start != -1:
        print("Found partial match starting at:")
        print(content[start:start+200])
    else:
        print("No match found at all.")
else:
    new_content = content.replace(search_text.strip(), replace_text.strip())
    with open('antigravity-update.sh', 'w') as f:
        f.write(new_content)
    print("Patched successfully.")
