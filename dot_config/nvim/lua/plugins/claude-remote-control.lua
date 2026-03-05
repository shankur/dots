-- Claude Remote Control System for Neovim
-- Fixed: Added proper server cleanup on exit to prevent slow quit

return {
  {
    "AstroNvim/astrocore",
    opts = {
      autocmds = {
        claude_remote_setup = {
          {
            event = "VimEnter",
            callback = function()
              -- Create control directory
              local control_dir = vim.fn.expand("~/.config/nvim/claude-control")
              vim.fn.mkdir(control_dir, "p")

              -- Clean up old socket
              local server_address = control_dir .. "/nvim.sock"
              if vim.fn.filereadable(server_address) == 1 then
                vim.fn.delete(server_address)
              end

              -- Start server
              local server_channel = vim.fn.serverstart(server_address)
              vim.g.claude_server_channel = server_channel

              -- Create remote module with helper functions
              local claude_remote = {}

              function claude_remote.list_buffers()
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
                local buf_name = vim.api.nvim_buf_get_name(current_buf)
                local basename = buf_name:match("([^/]+)$") or "[No Name]"
                local lines = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)
                local content = table.concat(lines, "\n")
                return string.format("📄 Buffer: %s\n📊 Lines: %d\n🔍 Content:\n%s",
                  basename, #lines, content)
              end

              -- Make module globally available
              _G.claude_remote_module = claude_remote
              package.loaded["claude-remote"] = claude_remote

              print("📡 Claude Remote Control ready")
            end,
          },
          -- CRITICAL FIX: Force cleanup on exit
          {
            event = "VimLeavePre",
            callback = function()
              -- Immediately stop server to prevent slow quit
              if vim.g.claude_server_channel then
                pcall(vim.fn.serverstop, vim.g.claude_server_channel)
              end
              -- Clean up socket file
              local server_address = vim.fn.expand("~/.config/nvim/claude-control/nvim.sock")
              pcall(vim.fn.delete, server_address)
            end,
          },
        },
      },
    },
  },
}
