return {
  "https://github.com/swaits/zellij-nav.nvim",
  lazy = true,
  event = "VeryLazy",
  keys = {
    { "<A-h>", "<cmd>ZellijNavigateLeft<cr>",  desc = "Navigate left (Neovim/Zellij)" },
    { "<A-j>", "<cmd>ZellijNavigateDown<cr>",  desc = "Navigate down (Neovim/Zellij)" },
    { "<A-k>", "<cmd>ZellijNavigateUp<cr>",    desc = "Navigate up (Neovim/Zellij)" },
    { "<A-l>", "<cmd>ZellijNavigateRight<cr>", desc = "Navigate right (Neovim/Zellij)" },
  },
  opts = {},
}
