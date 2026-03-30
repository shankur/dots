-- Disable popup notifications completely
return {
  {
    "AstroNvim/astrocore",
    opts = {
      features = {
        notifications = false, -- disable notifications at start
      },
    },
  },
  -- Override vim.notify to suppress all notifications
  {
    "rcarriga/nvim-notify",
    enabled = false, -- Disable nvim-notify plugin entirely
  },
  -- Additional notification suppression
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      -- Completely override vim.notify to do nothing
      vim.notify = function() end
      return opts
    end,
  },
}
