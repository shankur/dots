return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "mfussenegger/nvim-dap-python",
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason-org/mason.nvim",
        opts = {
          -- dap adapter names, not mason package names (python -> debugpy)
          ensure_installed = { "python", "codelldb" },
          automatic_installation = true,
          -- adapters/configurations are set up by hand in configs.dap
          handlers = {},
        },
      },
    },

    keys = {
      -- Basic debugging controls
      { "<F5>", function() require("dap").continue() end, desc = "Continue/Start Debug" },
      { "<F10>", function() require("dap").step_over() end, desc = "Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Step Out" },

      -- Breakpoint management
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      {
        "<leader>dB",
        function() require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ") end,
        desc = "Conditional Breakpoint",
      },
      { "<leader>dc", function() require("dap").clear_breakpoints() end, desc = "Clear All Breakpoints" },

      -- Debug UI
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle Debug UI" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "Open Debug REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last Debug Config" },

      -- Debug sessions
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate Debug Session" },
      { "<leader>dR", function() require("dap").restart() end, desc = "Restart Debug Session" },

      -- Variable inspection
      { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Debug Hover", mode = { "n", "v" } },
      {
        "<leader>dp",
        function() require("dap.ui.widgets").preview() end,
        desc = "Debug Preview",
        mode = { "n", "v" },
      },
      {
        "<leader>df",
        function()
          local widgets = require "dap.ui.widgets"
          widgets.centered_float(widgets.frames)
        end,
        desc = "Debug Frames",
      },
      {
        "<leader>ds",
        function()
          local widgets = require "dap.ui.widgets"
          widgets.centered_float(widgets.scopes)
        end,
        desc = "Debug Scopes",
      },
    },

    config = function()
      require "configs.dap"
    end,
  },
}
