#!/usr/bin/env bash
set -euo pipefail

# PreToolUse hook for Bash tool calls.
# Tiered permissions:
#   BLOCK  — destructive commands (denied outright)
#   ASK    — git commit, git push (require human approval)
#   ALLOW  — everything else (auto-approved)
#
# Requires: jq

INPUT="$(cat)"
TOOL_NAME="$(echo "$INPUT" | jq -r '.tool_name // empty')"

# Only process Bash tool calls
if [[ "$TOOL_NAME" != "Bash" ]]; then
  exit 0
fi

COMMAND="$(echo "$INPUT" | jq -r '.tool_input.command // empty')"

# --- BLOCK: destructive commands ---
# rm -rf / (root wipe)
if echo "$COMMAND" | grep -qE 'rm\s+-[a-zA-Z]*r[a-zA-Z]*f[a-zA-Z]*\s+/\s*$|rm\s+-[a-zA-Z]*f[a-zA-Z]*r[a-zA-Z]*\s+/\s*$'; then
  echo '{"decision":"block","reason":"Blocked: rm -rf / is not allowed"}'
  exit 0
fi

# git push --force to main/master
if echo "$COMMAND" | grep -qE 'git\s+push\s+.*--force.*\s+(main|master)\b|git\s+push\s+.*-f\s+.*\s+(main|master)\b'; then
  echo '{"decision":"block","reason":"Blocked: force-push to main/master is not allowed"}'
  exit 0
fi

# git reset --hard
if echo "$COMMAND" | grep -qE 'git\s+reset\s+--hard'; then
  echo '{"decision":"block","reason":"Blocked: git reset --hard is not allowed"}'
  exit 0
fi

# git clean -f
if echo "$COMMAND" | grep -qE 'git\s+clean\s+-[a-zA-Z]*f'; then
  echo '{"decision":"block","reason":"Blocked: git clean -f is not allowed"}'
  exit 0
fi

# --- ASK: require human approval ---
# git commit
if echo "$COMMAND" | grep -qE 'git\s+commit'; then
  exit 0
fi

# git push
if echo "$COMMAND" | grep -qE 'git\s+push'; then
  exit 0
fi

# --- ALLOW: everything else ---
echo '{"decision":"approve","reason":"Auto-approved by hook"}'
exit 0
