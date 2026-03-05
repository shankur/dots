-- Fix lua_ls workspace issue - force single file mode
return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Ensure the servers table exists
      opts.servers = opts.servers or {}
      
      -- Configure lua_ls
      opts.servers.lua_ls = {
        on_new_config = function(config, root_dir)
          -- Force root_dir to be the file's directory, not home directory
          if root_dir == vim.fn.expand("~") then
            config.root_dir = vim.fn.getcwd()
          end
        end,
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = false,
              library = {},
            },
            telemetry = { enable = false },
          },
        },
      }
      
      return opts
    end,
  },
}
