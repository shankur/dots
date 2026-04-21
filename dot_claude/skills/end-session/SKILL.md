---
name: end-session
description: >
  Writes a session summary to ~/ai-history. Use when the user says
  "end session", "save session", "log session", or "wrap up". Summarizes
  what was accomplished, key findings, approach taken, and follow-ups.
---

# End Session — Write Session Summary to ai-history

Write a concise session summary to the `~/ai-history` repository.

## Steps

1. **Determine the project name** from the current working directory:
   - If inside `~/Snowflake/` or a Snowflake-related path → `snowflake`
   - If inside `~/.local/share/chezmoi` or dotfiles → `dotfiles`
   - Otherwise, use the repo name or directory name as the project slug

2. **Generate a short session UUID** (first 8 hex chars) and a **topic slug**
   (2-5 lowercase hyphenated words summarizing the main topic).

3. **Determine today's date** and construct the output path:
   ```
   ~/ai-history/sessions/<project>/<year>/<month>/<day>/<uuid>-<topic-slug>.md
   ```
   Create intermediate directories as needed.

4. **Write the session file** using this template:

   ```markdown
   # Session: <Title> (<date>)

   ## What Was Done
   - Bullet points summarizing accomplishments (3-8 bullets)
   - Focus on outcomes and decisions, not implementation minutiae

   ## Approach & Reasoning
   - Why this approach was chosen over alternatives
   - Key design decisions and trade-offs considered
   - Mental model or framework used to solve the problem
   - Any hypotheses tested (confirmed or rejected)

   ## Key Findings
   - Important discoveries, root causes identified, or insights gained
   - Things that were surprising or non-obvious
   - Relevant system behaviors or gotchas uncovered

   ## Tickets / Issues
   - Link any Jira tickets, GitHub issues, or PRs referenced
   - Only include if applicable

   ## Follow-ups
   - What remains to be done
   - Open questions or risks
   - Potential next steps
   ```

5. **Stage and commit** the file to the ai-history repo:
   ```
   cd ~/ai-history && git add <file> && git commit -m "Add session <uuid>: <topic-slug>"
   ```

## Writing Guidelines

- **DO** focus on approach, reasoning, findings, and decisions
- **DO** include enough context that future-you can understand what happened
- **DO** mention alternative approaches that were considered and why they were rejected
- **DON'T** include raw code snippets, diffs, or file contents
- **DON'T** list every file changed — mention files only when the *location* is a key finding
- **DON'T** include boilerplate or filler; every bullet should carry information
- Keep the entire file under 150 lines
- Use the conversation history to extract the summary — do not ask the user questions
