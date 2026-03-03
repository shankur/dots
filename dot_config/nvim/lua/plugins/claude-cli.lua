-- Claude CLI Integration for Neovim
return {
  -- Add Claude CLI commands and keybindings
  {
    "AstroNvim/astrocore",
    opts = {
      commands = {
        -- Ask Claude command
        Claude = {
          function(opts)
            local input = opts.args
            if input == "" then
              input = vim.fn.input("Ask Claude: ")
            end
            if input ~= "" then
              vim.cmd("terminal claude chat '" .. input:gsub("'", "\\'") .. "'")
            end
          end,
          nargs = "*",
          desc = "Ask Claude via CLI",
        },

        -- Ask Claude about selected code
        ClaudeCode = {
          function()
            local lines = vim.api.nvim_buf_get_lines(0,
              vim.fn.line("'<") - 1, vim.fn.line("'>"), false)
            local text = table.concat(lines, "\n")
            if text ~= "" then
              vim.cmd("terminal claude chat 'Explain this code:\\n" ..
                text:gsub("'", "\\'"):gsub("\n", "\\n") .. "'")
            end
          end,
          range = true,
          desc = "Ask Claude about selected code",
        },
      },

      mappings = {
        n = {
          ["<leader>ai"] = { "<cmd>Claude<cr>", desc = "Ask Claude" },
          ["<leader>ac"] = {
            function()
              vim.cmd("terminal claude chat")
            end,
            desc = "Open Claude Chat"
          },
        },
        v = {
          ["<leader>ae"] = { ":'<,'>ClaudeCode<cr>", desc = "Explain selected code" },
        },
      },
    },
  },
}