-- Mason setup for LSPs, formatters, linters, and debug adapters
-- Note: mason-tool-installer has compatibility issues with AstroNvim
-- LSP servers are auto-installed via mason-lspconfig
-- Other tools (formatters, linters) can be installed manually via :Mason

---@type LazySpec
return {
  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      -- Disable Mason notifications
      max_concurrent_installers = 4,
    },
    config = function(_, opts)
      require("mason").setup(opts)

      -- Completely silence mason notifications
      local mason_notify = require("mason-core.notify")
      mason_notify.info = function() end
      mason_notify.warn = function() end
      mason_notify.error = function() end
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      -- Detect ARM architecture
      local uname = vim.loop.os_uname()
      local is_arm = uname.machine == "aarch64" or uname.machine == "arm64"

      -- Auto-install these LSP servers
      opts.ensure_installed = {
        "lua_ls",
        "ts_ls",
        "pyright",
        "gopls",
        "rust_analyzer",
        "jsonls",
        "yamlls",
        "tailwindcss",
      }

      -- Only add clangd on non-ARM (ARM uses system clangd from Nix)
      if not is_arm then
        table.insert(opts.ensure_installed, "clangd")
      end

      return opts
    end,
  },
  -- Disable mason-tool-installer due to compatibility issues
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    enabled = false,
  },
}

-- To install formatters/linters/debug adapters manually:
-- Open neovim and run :Mason, then press 'i' to install:
--   Formatters: prettier, stylua, black, isort, gofumpt, rustfmt (non-ARM only)
--   Linters: eslint_d, pylint, golangci-lint
--   Debug: debugpy, delve, codelldb


