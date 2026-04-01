#!/bin/bash
# UserPromptSubmit hook: inject auto-context into prompts
# Adds current date, git branch, and working directory

input=$(cat)
prompt=$(echo "$input" | jq -r '.prompt // empty')
[ -z "$prompt" ] && echo '{"decision":"APPROVE"}' && exit 0

context=""
context="${context}# currentDate\nToday's date is $(date +%Y-%m-%d).\n"

if git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  repo=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
  [ -n "$branch" ] && context="${context}\n# gitContext\nRepo: ${repo}, Branch: ${branch}\n"
fi

if [ -n "$context" ]; then
  printf '{"decision":"APPROVE","suppressOutput":true,"message":"<system-reminder>\\nAs you answer the user'\''s questions, you can use the following context:\\n%s\\n      IMPORTANT: this context may or may not be relevant to your tasks. You should not respond to this context unless it is highly relevant to your task.\\n</system-reminder>"}' "$context"
else
  echo '{"decision":"APPROVE"}'
fi
