-- Claude Remote Control System for Neovim
return {
  {
    "AstroNvim/astrocore",
    opts = {
      autocmds = {
        claude_remote_setup = {
          {
            event = "VimEnter",
            callback = function()
              -- Create control directory for Claude
              local control_dir = vim.fn.expand("~/.config/nvim/claude-control")
              vim.fn.mkdir(control_dir, "p")

              -- Start RPC server for Claude to connect to
              local server_address = control_dir .. "/nvim.sock"
              if vim.fn.filereadable(server_address) == 1 then
                vim.fn.delete(server_address)
              end

              -- Create helper scripts for Claude
              local script_content = [[#!/bin/bash
# Claude Neovim Control Script

CONTROL_DIR="$HOME/.config/nvim/claude-control"
SOCK_FILE="$CONTROL_DIR/nvim.sock"

case "$1" in
  "list-buffers")
    nvim --server "$SOCK_FILE" --remote-expr "luaeval('require(\"claude-remote\").list_buffers()')" 2>/dev/null || echo "Neovim not accessible"
    ;;
  "open-file")
    if [ -z "$2" ]; then
      echo "Usage: claude-nvim open-file <filename>"
      exit 1
    fi
    nvim --server "$SOCK_FILE" --remote "$2" 2>/dev/null && echo "Opened: $2" || echo "Failed to open: $2"
    ;;
  "close-buffer")
    nvim --server "$SOCK_FILE" --remote-send ":bdelete<CR>" 2>/dev/null && echo "Buffer closed" || echo "Failed to close buffer"
    ;;
  "read-current")
    nvim --server "$SOCK_FILE" --remote-expr "luaeval('require(\"claude-remote\").read_current_buffer()')" 2>/dev/null || echo "Cannot read buffer"
    ;;
  "read-buffer")
    if [ -z "$2" ]; then
      echo "Usage: claude-nvim read-buffer <number|name>"
      exit 1
    fi
    nvim --server "$SOCK_FILE" --remote-expr "luaeval('require(\"claude-remote\").read_buffer(\"$2\")')" 2>/dev/null || echo "Cannot read buffer: $2"
    ;;
  "switch-buffer")
    if [ -z "$2" ]; then
      echo "Usage: claude-nvim switch-buffer <number>"
      exit 1
    fi
    nvim --server "$SOCK_FILE" --remote-send ":buffer $2<CR>" 2>/dev/null && echo "Switched to buffer: $2" || echo "Failed to switch"
    ;;
  "save-buffer")
    nvim --server "$SOCK_FILE" --remote-send ":write<CR>" 2>/dev/null && echo "Buffer saved" || echo "Failed to save"
    ;;
  "highlight-lines")
    if [ -z "$2" ] || [ -z "$3" ]; then
      echo "Usage: claude-nvim highlight-lines <buffer> <start_line> [end_line] [style]"
      echo "Styles: default, error, warning, info, success, todo, focus, note"
      exit 1
    fi
    buffer="$2"
    start_line="$3"
    end_line="${4:-$3}"
    style="${5:-default}"
    nvim --server "$SOCK_FILE" --remote-expr "luaeval('require(\"claude-remote\").highlight_lines(\"$buffer\", \"$start_line\", \"$end_line\", \"$style\")')" 2>/dev/null || echo "Cannot highlight lines"
    ;;
  "clear-highlights")
    buffer="${2:-current}"
    nvim --server "$SOCK_FILE" --remote-expr "luaeval('require(\"claude-remote\").clear_highlights(\"$buffer\")')" 2>/dev/null || echo "Cannot clear highlights"
    ;;
  *)
    echo "Claude Neovim Control Commands:"
    echo "  list-buffers         - List all open buffers"
    echo "  open-file <file>     - Open file in new buffer"
    echo "  close-buffer         - Close current buffer"
    echo "  read-current         - Read current buffer content"
    echo "  read-buffer <n>      - Read specific buffer (by number or name)"
    echo "  switch-buffer <n>    - Switch to buffer number"
    echo "  save-buffer          - Save current buffer"
    echo "  highlight-lines <buf> <start> [end] [style] - Highlight lines"
    echo "  clear-highlights [buf] - Clear highlights (buf or 'all')"
    echo ""
    echo "Highlight Styles: default, error, warning, info, success, todo, focus, note"
    ;;
esac
]]

              local script_path = control_dir .. "/claude-nvim"
              local file = io.open(script_path, "w")
              if file then
                file:write(script_content)
                file:close()
                vim.fn.system("chmod +x " .. script_path)
              end

              -- Start server
              vim.fn.serverstart(server_address)
              print("📡 Claude Remote Control Server started at: " .. server_address)
              print("🔧 Claude control script created at: " .. script_path)
            end,
          },
        },
      },
    },
  },

  -- Create remote control module
  {
    "AstroNvim/astrocore",
    opts = {
      autocmds = {
        claude_remote_module = {
          {
            event = "VimEnter",
            callback = function()
              -- Create the remote control module
              local claude_remote = {}

              function claude_remote.list_buffers()
                local buffers = {}
                local result = "📋 Open Buffers:\n"

                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                  if vim.api.nvim_buf_is_loaded(buf) then
                    local name = vim.api.nvim_buf_get_name(buf)
                    local basename = name:match("([^/]+)$") or "[No Name]"
                    local lines = vim.api.nvim_buf_line_count(buf)
                    local modified = vim.api.nvim_buf_get_option(buf, 'modified')
                    local current = buf == vim.api.nvim_get_current_buf()

                    local current_mark = current and "👉 " or "   "
                    local modified_mark = modified and "*" or " "
                    result = result .. string.format("%s%d: %s (%d lines)%s\n",
                      current_mark, buf, basename, lines, modified_mark)
                  end
                end
                return result
              end

              function claude_remote.read_current_buffer()
                local current_buf = vim.api.nvim_get_current_buf()
                return claude_remote.read_buffer(current_buf)
              end

              function claude_remote.read_buffer(buf_identifier)
                local target_buf

                if type(buf_identifier) == "number" then
                  target_buf = buf_identifier
                elseif type(buf_identifier) == "string" then
                  -- Try to find buffer by name or convert string to number
                  local buf_num = tonumber(buf_identifier)
                  if buf_num then
                    target_buf = buf_num
                  else
                    -- Search by filename
                    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                      if vim.api.nvim_buf_is_loaded(buf) then
                        local buf_name = vim.api.nvim_buf_get_name(buf)
                        local basename = buf_name:match("([^/]+)$") or ""
                        if basename:lower():find(buf_identifier:lower()) or
                           buf_name:lower():find(buf_identifier:lower()) then
                          target_buf = buf
                          break
                        end
                      end
                    end
                  end
                else
                  target_buf = vim.api.nvim_get_current_buf()
                end

                if not target_buf or not vim.api.nvim_buf_is_valid(target_buf) then
                  return "❌ Buffer not found: " .. tostring(buf_identifier)
                end

                if not vim.api.nvim_buf_is_loaded(target_buf) then
                  return "❌ Buffer not loaded: " .. tostring(buf_identifier)
                end

                local buf_name = vim.api.nvim_buf_get_name(target_buf)
                local basename = buf_name:match("([^/]+)$") or "[No Name]"

                if buf_name == "" then
                  return "❌ No file in buffer " .. tostring(buf_identifier)
                end

                local lines = vim.api.nvim_buf_get_lines(target_buf, 0, -1, false)
                local line_count = #lines
                local content = table.concat(lines, "\n")

                local result = string.format("📄 Buffer %d: %s\n📊 Lines: %d\n🔍 Content:\n%s",
                  target_buf, basename, line_count, content)

                return result
              end

              function claude_remote.get_file_content(filepath)
                local expanded_path = vim.fn.expand(filepath)
                if vim.fn.filereadable(expanded_path) == 0 then
                  return "❌ File not readable: " .. filepath
                end

                local lines = vim.fn.readfile(expanded_path)
                local content = table.concat(lines, "\n")
                return string.format("📄 File: %s\n📊 Lines: %d\n🔍 Content:\n%s",
                  filepath, #lines, content)
              end

              -- Namespace for Claude highlights
              local claude_ns = vim.api.nvim_create_namespace("claude_highlights")

              -- Create custom highlight groups with explicit background colors
              local function setup_claude_highlights()
                -- Define custom highlight groups with distinct background colors
                vim.api.nvim_set_hl(0, "ClaudeHighlightDefault", {
                  bg = "#3d59a1",  -- Blue background
                  fg = "#ffffff",  -- White text
                  bold = true
                })

                vim.api.nvim_set_hl(0, "ClaudeHighlightError", {
                  bg = "#8b2635",  -- Dark red background
                  fg = "#ffffff",  -- White text
                  bold = true
                })

                vim.api.nvim_set_hl(0, "ClaudeHighlightWarning", {
                  bg = "#c17817",  -- Orange background
                  fg = "#000000",  -- Black text
                  bold = true
                })

                vim.api.nvim_set_hl(0, "ClaudeHighlightInfo", {
                  bg = "#2563eb",  -- Bright blue background
                  fg = "#ffffff",  -- White text
                  bold = true
                })

                vim.api.nvim_set_hl(0, "ClaudeHighlightSuccess", {
                  bg = "#16a34a",  -- Green background
                  fg = "#ffffff",  -- White text
                  bold = true
                })

                vim.api.nvim_set_hl(0, "ClaudeHighlightTodo", {
                  bg = "#7c3aed",  -- Purple background
                  fg = "#ffffff",  -- White text
                  bold = true
                })

                vim.api.nvim_set_hl(0, "ClaudeHighlightFocus", {
                  bg = "#dc2626",  -- Bright red background
                  fg = "#ffffff",  -- White text
                  bold = true,
                  italic = true
                })

                vim.api.nvim_set_hl(0, "ClaudeHighlightNote", {
                  bg = "#059669",  -- Teal background
                  fg = "#ffffff",  -- White text
                  bold = true
                })
              end

              -- Set up highlights on load
              setup_claude_highlights()

              function claude_remote.highlight_lines(buf_identifier, line_start, line_end, style)
                local target_buf

                -- Find target buffer (same logic as read_buffer)
                if type(buf_identifier) == "number" then
                  target_buf = buf_identifier
                elseif type(buf_identifier) == "string" then
                  local buf_num = tonumber(buf_identifier)
                  if buf_num then
                    target_buf = buf_num
                  else
                    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                      if vim.api.nvim_buf_is_loaded(buf) then
                        local buf_name = vim.api.nvim_buf_get_name(buf)
                        local basename = buf_name:match("([^/]+)$") or ""
                        if basename:lower():find(buf_identifier:lower()) or
                           buf_name:lower():find(buf_identifier:lower()) then
                          target_buf = buf
                          break
                        end
                      end
                    end
                  end
                else
                  target_buf = vim.api.nvim_get_current_buf()
                end

                if not target_buf or not vim.api.nvim_buf_is_valid(target_buf) then
                  return "❌ Buffer not found: " .. tostring(buf_identifier)
                end

                if not vim.api.nvim_buf_is_loaded(target_buf) then
                  return "❌ Buffer not loaded: " .. tostring(buf_identifier)
                end

                -- Parse line numbers
                local start_line = tonumber(line_start) or 1
                local end_line = tonumber(line_end) or start_line

                -- Validate line numbers
                local total_lines = vim.api.nvim_buf_line_count(target_buf)
                if start_line < 1 or start_line > total_lines then
                  return "❌ Invalid start line: " .. start_line .. " (buffer has " .. total_lines .. " lines)"
                end
                if end_line < start_line or end_line > total_lines then
                  end_line = total_lines
                end

                -- Set highlight style using our custom groups
                local hl_group = "ClaudeHighlightDefault" -- default
                if style == "error" then
                  hl_group = "ClaudeHighlightError"
                elseif style == "warning" then
                  hl_group = "ClaudeHighlightWarning"
                elseif style == "info" then
                  hl_group = "ClaudeHighlightInfo"
                elseif style == "success" then
                  hl_group = "ClaudeHighlightSuccess"
                elseif style == "todo" then
                  hl_group = "ClaudeHighlightTodo"
                elseif style == "focus" then
                  hl_group = "ClaudeHighlightFocus"
                elseif style == "note" then
                  hl_group = "ClaudeHighlightNote"
                end

                -- Apply highlights
                for line = start_line, end_line do
                  vim.api.nvim_buf_add_highlight(
                    target_buf,
                    claude_ns,
                    hl_group,
                    line - 1, -- API is 0-indexed
                    0,
                    -1
                  )
                end

                local buf_name = vim.api.nvim_buf_get_name(target_buf)
                local basename = buf_name:match("([^/]+)$") or "[No Name]"

                return string.format("✨ Highlighted lines %d-%d in buffer %d (%s) with style '%s'",
                  start_line, end_line, target_buf, basename, style or "default")
              end

              function claude_remote.clear_highlights(buf_identifier)
                local target_buf

                if buf_identifier == "all" then
                  -- Clear highlights from all buffers
                  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                    if vim.api.nvim_buf_is_loaded(buf) then
                      vim.api.nvim_buf_clear_namespace(buf, claude_ns, 0, -1)
                    end
                  end
                  return "✨ Cleared highlights from all buffers"
                end

                -- Find specific buffer
                if type(buf_identifier) == "number" then
                  target_buf = buf_identifier
                elseif type(buf_identifier) == "string" then
                  local buf_num = tonumber(buf_identifier)
                  if buf_num then
                    target_buf = buf_num
                  else
                    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                      if vim.api.nvim_buf_is_loaded(buf) then
                        local buf_name = vim.api.nvim_buf_get_name(buf)
                        local basename = buf_name:match("([^/]+)$") or ""
                        if basename:lower():find(buf_identifier:lower()) or
                           buf_name:lower():find(buf_identifier:lower()) then
                          target_buf = buf
                          break
                        end
                      end
                    end
                  end
                else
                  target_buf = vim.api.nvim_get_current_buf()
                end

                if not target_buf or not vim.api.nvim_buf_is_valid(target_buf) then
                  return "❌ Buffer not found: " .. tostring(buf_identifier)
                end

                vim.api.nvim_buf_clear_namespace(target_buf, claude_ns, 0, -1)

                local buf_name = vim.api.nvim_buf_get_name(target_buf)
                local basename = buf_name:match("([^/]+)$") or "[No Name]"

                return string.format("✨ Cleared highlights from buffer %d (%s)", target_buf, basename)
              end

              -- Make module globally available
              _G.claude_remote_module = claude_remote
              package.loaded["claude-remote"] = claude_remote
            end,
          },
        },
      },
    },
  },
}