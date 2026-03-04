-- Fix duplicate filename in tabline
return {
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      -- Override tabline to prevent duplication
      if opts.tabline then
        opts.tabline = nil  -- Disable custom tabline to use default
      end
      return opts
    end,
  },
}