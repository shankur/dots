require("nvchad.configs.lspconfig").defaults()

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})

-- Most servers are installed via Mason (see lua/plugins/init.lua) and enabled
-- automatically by mason-lspconfig once installed. clangd is the exception:
-- on Apple Silicon we use the system binary from Xcode Command Line Tools
-- (/usr/bin/clangd) instead of Mason's, so it needs enabling here.
vim.lsp.enable "clangd"
