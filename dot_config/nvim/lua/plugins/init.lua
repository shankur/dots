return {
  {
    "stevearc/conform.nvim",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    event = "User FilePost",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    opts = function()
      local is_arm = vim.uv.os_uname().machine:match "^arm" ~= nil
      local ensure_installed = {
        "lua_ls",
        "pyright",
        "gopls",
        "rust_analyzer",
        "jsonls",
        "yamlls",
        "sqlls",
        "bashls",
        "marksman",
      }
      -- Apple Silicon: clangd comes from Xcode CLT (/usr/bin/clangd), not Mason
      if not is_arm then table.insert(ensure_installed, "clangd") end
      return { ensure_installed = ensure_installed }
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    -- NvChad v2.5's core config (TSInstallAll, TSBufEnable, opts.ensure_installed)
    -- targets the old API; nvim-treesitter's default branch is now "main", an
    -- incompatible rewrite. Pin to the still-supported legacy branch.
    branch = "master",
    -- lazy.nvim's default main-module inference calls require("nvim-treesitter").setup(),
    -- which on this branch takes no opts at all. The real config entrypoint is
    -- nvim-treesitter.configs, so opts below would otherwise be silently discarded.
    main = "nvim-treesitter.configs",
    opts = {
      highlight = { enable = true },
      ensure_installed = {
        "lua",
        "luadoc",
        "printf",
        "vim",
        "vimdoc",
        "python",
        "go",
        "rust",
        "c",
        "cpp",
        "json",
        "yaml",
        "bash",
        "markdown",
        "markdown_inline",
        "sql",
      },
    },
  },
}
