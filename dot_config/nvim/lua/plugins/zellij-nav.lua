return {
  "https://github.com/swaits/zellij-nav.nvim",
  lazy = true,
  event = "VeryLazy",
  keys = {
    { "<A-h>", "<cmd>ZellijNavigateLeftWrapped<cr>",  desc = "Navigate left (Neovim/Zellij)" },
    { "<A-j>", "<cmd>ZellijNavigateDownWrapped<cr>",  desc = "Navigate down (Neovim/Zellij)" },
    { "<A-k>", "<cmd>ZellijNavigateUpWrapped<cr>",    desc = "Navigate up (Neovim/Zellij)" },
    { "<A-l>", "<cmd>ZellijNavigateRightWrapped<cr>", desc = "Navigate right (Neovim/Zellij)" },
  },
  opts = {},
}
