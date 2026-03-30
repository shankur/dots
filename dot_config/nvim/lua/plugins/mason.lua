-- Mason setup for LSPs, formatters, linters, and debug adapters

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = function()
      -- Detect if we're on an unsupported architecture
      local uname = vim.loop.os_uname()
      local is_arm = uname.machine == "aarch64" or uname.machine == "arm64"

      local ensure_installed = {
        -- Language Servers
        "lua-language-server",
        "typescript-language-server",
        "pyright",
        "gopls",
        "rust-analyzer",
        "json-lsp",
        "yaml-language-server",
        "tailwindcss-language-server",

        -- Formatters
        "prettier",
        "stylua",
        "black",
        "isort",
        "gofumpt",

        -- Linters
        "eslint_d",
        "pylint",
        "golangci-lint",

        -- Debug Adapters
        "debugpy",           -- Python debugger
        "delve",             -- Go debugger
        "codelldb",          -- Rust/C/C++ debugger

        -- Other tools
        "tree-sitter-cli",
      }

      -- Add clangd and rustfmt only if not on ARM (Mason doesn't support them on ARM)
      if not is_arm then
        table.insert(ensure_installed, "clangd")
        table.insert(ensure_installed, "rustfmt")
      end

      return {
        ensure_installed = ensure_installed,
        auto_update = false,
        run_on_start = true,
      }
    end,
  },
}
