-- Claude Terminal Integration for Neovim
return {
  {
    "AstroNvim/astrocore",
    opts = {
      commands = {
        -- Open Claude chat in terminal (right 35%) or toggle focus
        Claude = {
          function()
            -- Use global variable to track Claude buffer
            if not vim.g.claude_bufnr then
              vim.g.claude_bufnr = -1
            end

            -- Check if tracked Claude buffer still exists and is valid
            local claude_exists = false
            local claude_winid = nil

            if vim.g.claude_bufnr > 0 and vim.api.nvim_buf_is_valid(vim.g.claude_bufnr) then
              -- Find window containing Claude buffer
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                if vim.api.nvim_win_get_buf(win) == vim.g.claude_bufnr then
                  claude_exists = true
                  claude_winid = win
                  break
                end
              end
            end

            if claude_exists then
              -- Claude window exists, toggle focus
              local current_buf = vim.api.nvim_get_current_buf()
              if current_buf == vim.g.claude_bufnr then
                -- We're in Claude, switch to previous window
                vim.cmd("wincmd p")
              else
                -- Focus Claude window
                vim.api.nvim_set_current_win(claude_winid)
              end
            else
              -- Create new Claude window
              local width = math.floor(vim.o.columns * 0.35)
              vim.cmd("rightbelow vsplit")
              vim.cmd("vertical resize " .. width)
              vim.cmd("terminal claude chat")

              -- Store the buffer number
              vim.g.claude_bufnr = vim.api.nvim_get_current_buf()

              -- Hide buffer from buffer list and disable winbar (deferred)
              vim.schedule(function()
                vim.bo.buflisted = false
                vim.wo.winbar = ""  -- Disable winbar to prevent duplicate filename
                -- Set a distinctive name for the Claude buffer
                pcall(vim.api.nvim_buf_set_name, vim.g.claude_bufnr, "Claude Chat")
              end)
            end
          end,
          desc = "Toggle Claude Chat Terminal",
        },

        -- Quick Claude question in split
        ClaudeQuick = {
          function()
            local question = vim.fn.input("Ask Claude: ")
            if question and question ~= "" then
              vim.cmd("split")
              vim.cmd("terminal claude chat '" .. question:gsub("'", "\\'") .. "'")
              -- Hide buffer from buffer list and disable winbar (deferred)
              vim.schedule(function()
                vim.bo.buflisted = false
                vim.wo.winbar = ""  -- Disable winbar to prevent duplicate filename
                -- Set a distinctive name for the Claude buffer
                vim.api.nvim_buf_set_name(0, "Claude Chat")
              end)
            end
          end,
          desc = "Quick Claude Question",
        },

        -- Claude in vertical split
        ClaudeSplit = {
          function()
            vim.cmd("vsplit")
            vim.cmd("terminal claude chat")
            -- Hide buffer from buffer list and tabs (deferred)
            vim.schedule(function()
              vim.bo.buflisted = false
            end)
          end,
          desc = "Claude in Vertical Split",
        },

        -- Claude in floating window
        ClaudeFloat = {
          function()
            -- Create floating window
            local width = math.floor(vim.o.columns * 0.8)
            local height = math.floor(vim.o.lines * 0.8)
            local row = math.floor((vim.o.lines - height) / 2)
            local col = math.floor((vim.o.columns - width) / 2)

            vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
              relative = 'editor',
              width = width,
              height = height,
              row = row,
              col = col,
              border = 'rounded',
              title = ' Claude Chat ',
              title_pos = 'center',
            })
            vim.cmd("terminal claude chat")
            -- Hide buffer from buffer list and tabs (deferred)
            vim.schedule(function()
              vim.bo.buflisted = false
            end)
          end,
          desc = "Claude in Floating Window",
        },

        -- Claude in bottom 40% (explicit command)
        ClaudeBottom = {
          function()
            local height = math.floor(vim.o.lines * 0.4)
            vim.cmd("botright split")
            vim.cmd("resize " .. height)
            vim.cmd("terminal claude chat")
            -- Hide buffer from buffer list and tabs (deferred)
            vim.schedule(function()
              vim.bo.buflisted = false
            end)
          end,
          desc = "Claude in Bottom 40%",
        },

        -- Ask Claude about selected code
        ClaudeExplain = {
          function()
            local lines = vim.api.nvim_buf_get_lines(0,
              vim.fn.line("'<") - 1, vim.fn.line("'>"), false)
            local code = table.concat(lines, "\n")
            if code and code ~= "" then
              vim.cmd("vsplit")
              vim.cmd("terminal claude chat 'Explain this code:\\n" ..
                code:gsub("'", "\\'"):gsub("\\", "\\\\") .. "'")
              -- Hide buffer from buffer list and disable winbar (deferred)
              vim.schedule(function()
                vim.bo.buflisted = false
                vim.wo.winbar = ""  -- Disable winbar to prevent duplicate filename
                -- Set a distinctive name for the Claude buffer
                vim.api.nvim_buf_set_name(0, "Claude Chat")
              end)
            end
          end,
          range = true,
          desc = "Ask Claude to explain selected code",
        },
      },

      mappings = {
        n = {
          -- Claude terminal keybindings
          ["<leader>cc"] = { "<cmd>Claude<cr>", desc = "Toggle Claude Chat" },
          ["<leader>cq"] = { "<cmd>ClaudeQuick<cr>", desc = "Quick Claude Question" },
          ["<leader>cs"] = { "<cmd>ClaudeSplit<cr>", desc = "Claude Vertical Split" },
          ["<leader>cf"] = { "<cmd>ClaudeFloat<cr>", desc = "Claude Floating Window" },
          ["<leader>cb"] = { "<cmd>ClaudeBottom<cr>", desc = "Claude Bottom 40%" },
        },
        v = {
          ["<leader>ce"] = { ":'<,'>ClaudeExplain<cr>", desc = "Explain Selected Code" },
        },
      },
    },
  },
}