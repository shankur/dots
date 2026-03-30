-- Disable popup notifications
return {
  {
    "AstroNvim/astrocore",
    opts = {
      features = {
        notifications = false, -- disable notifications at start
      },
    },
  },
}
