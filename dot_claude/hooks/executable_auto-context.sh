#!/bin/bash
# UserPromptSubmit hook: inject auto-context into prompts
# Adds current date, git branch, and working directory

input=$(cat)
prompt=$(echo "$input" | jq -r '.prompt // empty')
[ -z "$prompt" ] && echo '{"decision":"APPROVE"}' && exit 0

context="# currentDate
Today's date is $(date +%Y-%m-%d)."

if git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  repo=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
  if [ -n "$branch" ]; then
    context="$context

# gitContext
Repo: ${repo}, Branch: ${branch}"
  fi
fi

message="<system-reminder>
As you answer the user's questions, you can use the following context:
${context}

      IMPORTANT: this context may or may not be relevant to your tasks. You should not respond to this context unless it is highly relevant to your task.
</system-reminder>"

jq -n --arg msg "$message" '{"decision":"APPROVE","suppressOutput":true,"message":$msg}'
