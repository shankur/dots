-- Enhanced Git diff viewing with diffview.nvim (with comment system)
return {
  {
    dir = vim.fn.expand("~/Desktop/diffview-comments"),  -- Use our local fork
    name = "diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewFileHistory"
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
      { "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "File History" },
      { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "Current File History" },
      -- Comment system keybindings (only work in diffview)
      -- These will be available as <leader>nc, <leader>ns, <leader>nC in diffview
    },
    opts = {
      enhanced_diff_hl = true,  -- Better syntax highlighting
      view = {
        default = {
          layout = "diff2_horizontal",  -- or "diff2_vertical"
        },
        merge_tool = {
          layout = "diff3_horizontal",
          disable_diagnostics = true,
        },
      },
      file_panel = {
        listing_style = "tree",  -- or "list"
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
      },
      -- Catppuccin theme integration
      hooks = {
        diff_buf_read = function(bufnr)
          vim.opt_local.wrap = false
          vim.opt_local.list = false
          vim.opt_local.colorcolumn = "80"
        end,
      },
    },
  },
}