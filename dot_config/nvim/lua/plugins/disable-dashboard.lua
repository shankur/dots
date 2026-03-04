-- Disable the Neovim welcome/startup screen
return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        enabled = false,
      },
    },
  },
}