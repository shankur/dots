-- Debug Adapter Protocol (DAP) setup for Neovim
return {
  -- Main DAP plugin
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- UI for DAP
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",

      -- Virtual text showing variable values
      "theHamsta/nvim-dap-virtual-text",

      -- Language-specific adapters
      "mfussenegger/nvim-dap-python",
      "leoluz/nvim-dap-go",
    },

    keys = {
      -- Basic debugging controls
      { "<F5>", function() require("dap").continue() end, desc = "Continue/Start Debug" },
      { "<F10>", function() require("dap").step_over() end, desc = "Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Step Out" },

      -- Breakpoint management
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Conditional Breakpoint" },
      { "<leader>dc", function() require("dap").clear_breakpoints() end, desc = "Clear All Breakpoints" },

      -- Debug UI
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle Debug UI" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "Open Debug REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last Debug Config" },

      -- Debug sessions
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate Debug Session" },
      { "<leader>dR", function() require("dap").restart() end, desc = "Restart Debug Session" },

      -- Variable inspection
      { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Debug Hover", mode = {"n", "v"} },
      { "<leader>dp", function() require("dap.ui.widgets").preview() end, desc = "Debug Preview", mode = {"n", "v"} },
      { "<leader>df", function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.frames)
      end, desc = "Debug Frames" },
      { "<leader>ds", function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.scopes)
      end, desc = "Debug Scopes" },
    },

    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Setup DAP UI
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        expand_lines = true,
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 0.25,
            position = "bottom",
          },
        },
        controls = {
          enabled = true,
          element = "repl",
          icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "",
            terminate = "",
          },
        },
        floating = {
          max_height = 0.9,
          max_width = 0.5,
          border = "rounded",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
      })

      -- Setup virtual text
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        filter_references_pattern = '<module',
        virt_text_pos = 'eol',
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil
      })

      -- Automatically open/close UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Custom signs for breakpoints
      vim.fn.sign_define('DapBreakpoint', {
        text = '●',
        texthl = 'DiagnosticError',
        linehl = '',
        numhl = ''
      })
      vim.fn.sign_define('DapStopped', {
        text = '▶',
        texthl = 'DiagnosticWarn',
        linehl = 'debugPC',
        numhl = ''
      })
      vim.fn.sign_define('DapBreakpointCondition', {
        text = '◐',
        texthl = 'DiagnosticInfo',
        linehl = '',
        numhl = ''
      })
      vim.fn.sign_define('DapBreakpointRejected', {
        text = '✕',
        texthl = 'DiagnosticError',
        linehl = '',
        numhl = ''
      })

      -- Language-specific configurations

      -- Python debugging
      require("dap-python").setup("python3")

      -- Go debugging
      require("dap-go").setup()

      -- No JavaScript debugging configured

      -- Rust debugging (using lldb)
      dap.adapters.lldb = {
        type = 'executable',
        command = '/usr/bin/lldb-vscode',
        name = 'lldb'
      }

      dap.configurations.rust = {
        {
          name = 'Launch',
          type = 'lldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
        },
      }

      -- C/C++ debugging
      dap.configurations.cpp = dap.configurations.rust
      dap.configurations.c = dap.configurations.rust

      print("🐛 Debug setup complete! Use F5 to start debugging or <leader>du for UI")
    end,
  },
}