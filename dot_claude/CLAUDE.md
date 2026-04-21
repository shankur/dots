You have a personal knowledge base at ~/claude-kb/. When answering questions about internal tools, systems, or workflows, read the relevant knowledge base files from that directory.

- Snowhouse (Snowflake internal data warehouse): ~/claude-kb/knowledge-base/SNOWHOUSE_KB.md

When creating new commands or skills:
- General/portable skills: ~/.local/share/chezmoi/dot_claude/skills/<name>/SKILL.md (managed by chezmoi, deployed everywhere)
- Project-specific skills: ~/claude-kb/skills/<name>/ (auto-symlinked into ~/.claude/skills/ when claude-kb exists)
- Commands: ~/claude-kb/commands/<name>.md
