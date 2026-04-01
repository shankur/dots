#!/bin/bash
# Sync Claude memory files to ai-history repo on session end

# Redirect all output so Claude Code doesn't try to parse it
exec >> "$HOME/.claude/hooks/sync-conversation.log" 2>&1

REPO="$HOME/ai-history"
BRANCH="main"

INPUT=$(cat)
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // empty')
[ -z "$TRANSCRIPT" ] || [ ! -f "$TRANSCRIPT" ] && exit 0

# Extract project name, session ID, and find memory directory
project_dir=$(basename "$(dirname "$TRANSCRIPT")" | sed 's/^-home-repo-//')
session_id=$(basename "$TRANSCRIPT" .jsonl)
memory_dir="$(dirname "$TRANSCRIPT")/memory"

# Exit if no memory directory exists
[ ! -d "$memory_dir" ] && exit 0

date_path=$(date +%Y/%m/%d)

cd "$REPO" || exit 0

original_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

stashed=false
if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
    git stash -q 2>/dev/null && stashed=true
fi

if git show-ref --verify --quiet "refs/heads/$BRANCH" 2>/dev/null; then
    git checkout -q "$BRANCH" 2>/dev/null
elif git show-ref --verify --quiet "refs/remotes/origin/$BRANCH" 2>/dev/null; then
    git checkout -q -b "$BRANCH" "origin/$BRANCH" 2>/dev/null
else
    git checkout -q -b "$BRANCH" 2>/dev/null
fi

target_dir="memory/$project_dir/$date_path/$session_id"
mkdir -p "$target_dir"

# Copy all memory markdown files, overwriting existing ones
files_copied=0
for memory_file in "$memory_dir"/*.md; do
    [ -f "$memory_file" ] || continue
    filename=$(basename "$memory_file")
    cp "$memory_file" "$target_dir/${filename}"
    git add "$target_dir/${filename}"
    files_copied=$((files_copied + 1))
done

# Only commit if we copied files
if [ $files_copied -gt 0 ] && ! git diff --cached --quiet 2>/dev/null; then
    # Generate session summary from MEMORY.md
    summary=""
    if [ -f "$target_dir/MEMORY.md" ]; then
        # Extract first few meaningful lines (skip headers and empty lines)
        summary=$(grep -v '^#' "$target_dir/MEMORY.md" | grep -v '^$' | head -5 | sed 's/^/  /')
    fi

    # Build commit message
    commit_msg="sync memory: $project_dir/$date_path ($files_copied files) $(date +%Y-%m-%d-%H%M%S)"
    if [ -n "$summary" ]; then
        commit_msg="$commit_msg

Session summary:
$summary"
    fi

    git commit -q -m "$commit_msg"
    nohup git push -q origin "$BRANCH" &>/dev/null &
fi

if [ -n "$original_branch" ] && [ "$original_branch" != "$BRANCH" ]; then
    git checkout -q "$original_branch" 2>/dev/null
fi

if [ "$stashed" = true ]; then
    git stash pop -q 2>/dev/null
fi

exit 0
