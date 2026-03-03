-- Claude Terminal Integration for Neovim
return {
  {
    "AstroNvim/astrocore",
    opts = {
      commands = {
        -- Open Claude chat in terminal
        Claude = {
          function()
            vim.cmd("terminal claude chat")
          end,
          desc = "Open Claude Chat Terminal",
        },

        -- Quick Claude question in split
        ClaudeQuick = {
          function()
            local question = vim.fn.input("Ask Claude: ")
            if question and question ~= "" then
              vim.cmd("split")
              vim.cmd("terminal claude chat '" .. question:gsub("'", "\\'") .. "'")
            end
          end,
          desc = "Quick Claude Question",
        },

        -- Claude in vertical split
        ClaudeSplit = {
          function()
            vim.cmd("vsplit")
            vim.cmd("terminal claude chat")
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
          end,
          desc = "Claude in Floating Window",
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
            end
          end,
          range = true,
          desc = "Ask Claude to explain selected code",
        },
      },

      mappings = {
        n = {
          -- Claude terminal keybindings
          ["<leader>cc"] = { "<cmd>Claude<cr>", desc = "Claude Chat Terminal" },
          ["<leader>cq"] = { "<cmd>ClaudeQuick<cr>", desc = "Quick Claude Question" },
          ["<leader>cs"] = { "<cmd>ClaudeSplit<cr>", desc = "Claude Vertical Split" },
          ["<leader>cf"] = { "<cmd>ClaudeFloat<cr>", desc = "Claude Floating Window" },
        },
        v = {
          ["<leader>ce"] = { ":'<,'>ClaudeExplain<cr>", desc = "Explain Selected Code" },
        },
      },
    },
  },
}