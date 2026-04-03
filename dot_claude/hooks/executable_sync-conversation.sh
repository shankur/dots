#!/bin/bash
# Sync Claude session transcript to ai-history repo on session end.
# Only stages the file — does not commit. Run `git commit` in ~/ai-history
# manually (outside a Claude session) to trigger summarization via pre-commit hook.

# Redirect all output so Claude Code doesn't try to parse it
exec >> "$HOME/.claude/hooks/sync-conversation.log" 2>&1

REPO="$HOME/ai-history"

INPUT=$(cat)
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // empty')
[ -z "$TRANSCRIPT" ] || [ ! -f "$TRANSCRIPT" ] && exit 0

project_dir=$(basename "$(dirname "$TRANSCRIPT")" | sed 's/^-home-repo-//')
session_id=$(basename "$TRANSCRIPT" .jsonl)
date_path=$(date +%Y/%m/%d)

cd "$REPO" || exit 0

target_dir="transcripts/$project_dir/$date_path"
target_file="$target_dir/${session_id}.jsonl"

mkdir -p "$target_dir"
cp "$TRANSCRIPT" "$target_file"
git add "$target_file"

exit 0
