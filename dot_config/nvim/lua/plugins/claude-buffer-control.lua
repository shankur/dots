-- Claude Buffer Operations - Focused on core buffer tasks
return {
  {
    "AstroNvim/astrocore",
    opts = {
      commands = {
        -- Open file in new buffer
        ClaudeOpen = {
          function(opts)
            local file = opts.args
            if file and file ~= "" then
              vim.cmd("edit " .. file)
              print("✅ Opened: " .. file)
            else
              local input_file = vim.fn.input("File to open: ")
              if input_file ~= "" then
                vim.cmd("edit " .. input_file)
                print("✅ Opened: " .. input_file)
              end
            end
          end,
          nargs = "?",
          desc = "Open file in new buffer",
        },

        -- Close current buffer
        ClaudeClose = {
          function(opts)
            local buf_name = vim.api.nvim_buf_get_name(0)
            local basename = buf_name:match("([^/]+)$") or "[No Name]"
            vim.cmd("bdelete")
            print("✅ Closed buffer: " .. basename)
          end,
          desc = "Close current buffer",
        },

        -- Close specific buffer by name/number
        ClaudeCloseBuf = {
          function(opts)
            local target = opts.args
            if target and target ~= "" then
              vim.cmd("bdelete " .. target)
              print("✅ Closed buffer: " .. target)
            else
              print("❌ Please specify buffer name or number")
            end
          end,
          nargs = 1,
          desc = "Close specific buffer",
        },

        -- Read file content and show it
        ClaudeRead = {
          function(opts)
            local current_buf = vim.api.nvim_get_current_buf()
            local buf_name = vim.api.nvim_buf_get_name(current_buf)
            local basename = buf_name:match("([^/]+)$") or "[No Name]"

            if buf_name == "" then
              print("❌ No file in current buffer")
              return
            end

            local lines = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)
            local line_count = #lines
            local content_preview = table.concat(vim.list_slice(lines, 1, math.min(5, line_count)), "\n")

            print("📄 File: " .. basename)
            print("📊 Lines: " .. line_count)
            print("🔍 Preview:")
            print(content_preview)
            if line_count > 5 then
              print("... (+" .. (line_count - 5) .. " more lines)")
            end
          end,
          desc = "Read and show current buffer content info",
        },

        -- Show file content of specific file
        ClaudeShow = {
          function(opts)
            local file = opts.args
            if file and file ~= "" then
              -- Open in preview without switching
              vim.cmd("pedit " .. file)
              print("📄 Preview opened for: " .. file)
            else
              print("❌ Please specify a file")
            end
          end,
          nargs = 1,
          desc = "Show file content in preview",
        },

        -- List all buffers with details
        ClaudeList = {
          function()
            local buffers = {}
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_loaded(buf) then
                local name = vim.api.nvim_buf_get_name(buf)
                local basename = name:match("([^/]+)$") or "[No Name]"
                local lines = vim.api.nvim_buf_line_count(buf)
                local modified = vim.api.nvim_buf_get_option(buf, 'modified')
                table.insert(buffers, {
                  number = buf,
                  name = basename,
                  lines = lines,
                  modified = modified,
                  current = buf == vim.api.nvim_get_current_buf()
                })
              end
            end

            print("📋 Open Buffers:")
            for _, b in ipairs(buffers) do
              local current_mark = b.current and "👉 " or "   "
              local modified_mark = b.modified and "*" or " "
              print(string.format("%s%d: %s (%d lines)%s",
                current_mark, b.number, b.name, b.lines, modified_mark))
            end
          end,
          desc = "List all buffers with details",
        },

        -- Switch to buffer by name/number
        ClaudeSwitch = {
          function(opts)
            local target = opts.args
            if target and target ~= "" then
              vim.cmd("buffer " .. target)
              local buf_name = vim.api.nvim_buf_get_name(0)
              local basename = buf_name:match("([^/]+)$") or "[No Name]"
              print("✅ Switched to: " .. basename)
            else
              print("❌ Please specify buffer name or number")
            end
          end,
          nargs = 1,
          desc = "Switch to buffer",
        },

        -- Create new empty buffer
        ClaudeNew = {
          function()
            vim.cmd("enew")
            print("✅ Created new empty buffer")
          end,
          desc = "Create new empty buffer",
        },

        -- Save current buffer
        ClaudeSave = {
          function(opts)
            local filename = opts.args
            if filename and filename ~= "" then
              vim.cmd("write " .. filename)
              print("✅ Saved as: " .. filename)
            else
              vim.cmd("write")
              local buf_name = vim.api.nvim_buf_get_name(0)
              local basename = buf_name:match("([^/]+)$") or "[No Name]"
              print("✅ Saved: " .. basename)
            end
          end,
          nargs = "?",
          desc = "Save current buffer",
        },
      },

      mappings = {
        n = {
          ["<leader>co"] = { "<cmd>ClaudeOpen<cr>", desc = "📂 Claude: Open File" },
          ["<leader>cc"] = { "<cmd>ClaudeClose<cr>", desc = "❌ Claude: Close Buffer" },
          ["<leader>cr"] = { "<cmd>ClaudeRead<cr>", desc = "📄 Claude: Read Buffer" },
          ["<leader>cl"] = { "<cmd>ClaudeList<cr>", desc = "📋 Claude: List Buffers" },
          ["<leader>cn"] = { "<cmd>ClaudeNew<cr>", desc = "➕ Claude: New Buffer" },
          ["<leader>cs"] = { "<cmd>ClaudeSave<cr>", desc = "💾 Claude: Save Buffer" },
        },
      },
    },
  },
}