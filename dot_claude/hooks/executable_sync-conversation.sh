#!/bin/bash
# Sync Claude memory files to ai-history repo on session end

REPO="$HOME/ai-history"
BRANCH="memory"

INPUT=$(cat)
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // empty')
[ -z "$TRANSCRIPT" ] || [ ! -f "$TRANSCRIPT" ] && exit 0

# Extract project name and find memory directory
project_dir=$(basename "$(dirname "$TRANSCRIPT")" | sed 's/^-home-repo-//')
memory_dir="$HOME/.claude/projects/$(dirname "$TRANSCRIPT" | sed 's|.*/\.claude/||')/memory"

# Exit if no memory directory exists
[ ! -d "$memory_dir" ] && exit 0

timestamp=$(date +%H%M%S)
date_path=$(date +%d/%m/%Y)

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

target_dir="memory/$project_dir/$date_path"
mkdir -p "$target_dir"

# Copy all memory markdown files with timestamp suffix
files_copied=0
for memory_file in "$memory_dir"/*.md; do
    [ -f "$memory_file" ] || continue
    filename=$(basename "$memory_file" .md)
    cp "$memory_file" "$target_dir/${filename}-${timestamp}.md"
    git add "$target_dir/${filename}-${timestamp}.md"
    files_copied=$((files_copied + 1))
done

# Only commit if we copied files
if [ $files_copied -gt 0 ] && ! git diff --cached --quiet 2>/dev/null; then
    git commit -q -m "sync memory: $project_dir/$date_path ($files_copied files) $(date +%Y-%m-%d-%H%M%S)"
    git push -q origin "$BRANCH" 2>/dev/null
fi

if [ -n "$original_branch" ] && [ "$original_branch" != "$BRANCH" ]; then
    git checkout -q "$original_branch" 2>/dev/null
fi

if [ "$stashed" = true ]; then
    git stash pop -q 2>/dev/null
fi
