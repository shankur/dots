-- Mason setup for LSPs, formatters, linters, and debug adapters

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        -- Language Servers
        "lua-language-server",
        "typescript-language-server",
        "pyright",
        "gopls",
        "rust-analyzer",
        "clangd",
        "json-lsp",
        "yaml-language-server",
        "tailwindcss-language-server",

        -- Formatters
        "prettier",
        "stylua",
        "black",
        "isort",
        "gofumpt",
        "rustfmt",

        -- Linters
        "eslint_d",
        "pylint",
        "golangci-lint",

        -- Debug Adapters
        "debugpy",           -- Python debugger
        "delve",             -- Go debugger
        "js-debug-adapter",  -- Node.js/JavaScript debugger
        "codelldb",          -- Rust/C/C++ debugger

        -- Other tools
        "tree-sitter-cli",
      },
      auto_update = false,
      run_on_start = true,
    },
  },
}
