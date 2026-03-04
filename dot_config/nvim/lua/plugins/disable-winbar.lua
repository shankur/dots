-- Disable winbar globally to prevent duplicate filename display
return {
  {
    "AstroNvim/astrocore",
    opts = {
      options = {
        opt = {
          winbar = "", -- Disable winbar globally to prevent filename duplication
        },
      },
    },
  },
}