-- Fix redundant buffer display elements
return {
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      -- Keep the informative winbar, disable redundant tabline
      opts.tabline = nil  -- This removes the redundant "Untitled" display
      return opts
    end,
  },
  {
    "AstroNvim/astrocore",
    opts = {
      options = {
        opt = {
          -- Ensure we have a clean setup
          showtabline = 0,  -- Disable tabline completely to avoid redundancy
        },
      },
    },
  },
}