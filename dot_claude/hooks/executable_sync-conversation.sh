#!/bin/bash
# Sync Claude conversation transcript to ai-history repo on session end

REPO="$HOME/ai-history"
BRANCH="transcripts"

INPUT=$(cat)
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // empty')
[ -z "$TRANSCRIPT" ] || [ ! -f "$TRANSCRIPT" ] && exit 0

project_dir=$(basename "$(dirname "$TRANSCRIPT")" | sed 's/^-home-repo-//')
conv_file=$(basename "$TRANSCRIPT")
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

mkdir -p "conversations/$project_dir/$date_path"
cp "$TRANSCRIPT" "conversations/$project_dir/$date_path/$conv_file"
git add "conversations/$project_dir/$date_path/$conv_file"

if ! git diff --cached --quiet 2>/dev/null; then
    git commit -q -m "sync $project_dir/$date_path/$conv_file $(date +%Y-%m-%d-%H%M)"
    git push -q origin "$BRANCH" 2>/dev/null
fi

if [ -n "$original_branch" ] && [ "$original_branch" != "$BRANCH" ]; then
    git checkout -q "$original_branch" 2>/dev/null
fi

if [ "$stashed" = true ]; then
    git stash pop -q 2>/dev/null
fi
