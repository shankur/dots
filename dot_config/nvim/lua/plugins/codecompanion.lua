-- CodeCompanion.nvim - DISABLED (using CLI integration instead)
-- This plugin is commented out because we're using Claude CLI integration
-- which works with your existing authentication

-- To enable this in the future, you would need to:
-- 1. Uncomment the plugin spec below
-- 2. Set up ANTHROPIC_API_KEY environment variable
-- 3. Run :Lazy sync in Neovim

--[[
return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    strategies = {
      chat = { adapter = "anthropic" },
      inline = { adapter = "anthropic" },
      agent = { adapter = "anthropic" },
    },
    adapters = {
      anthropic = function()
        return require("codecompanion.adapters").extend("anthropic", {
          env = { api_key = "ANTHROPIC_API_KEY" },
        })
      end,
    },
  },
  keys = {
    { "<leader>cc", "<cmd>CodeCompanionChat<cr>", desc = "Open Claude Chat" },
    { "<leader>cq", "<cmd>CodeCompanionQuickChat<cr>", desc = "Quick Claude Chat" },
    { "<leader>ca", "<cmd>CodeCompanionActions<cr>", desc = "Claude Actions" },
    { "<leader>ct", "<cmd>CodeCompanionToggle<cr>", desc = "Toggle Claude Chat" },
  },
}
--]]

-- Return empty table to satisfy Lua requirements
return {}