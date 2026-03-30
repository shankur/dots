-- Disable all popup notifications completely
return {
  {
    "AstroNvim/astrocore",
    opts = {
      features = {
        notifications = false,
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    enabled = false,
  },
}
