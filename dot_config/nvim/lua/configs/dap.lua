local dap = require "dap"
local dapui = require "dapui"

dapui.setup {
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
      elements = { "repl", "console" },
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
    mappings = { close = { "q", "<Esc>" } },
  },
}

require("nvim-dap-virtual-text").setup {
  enabled = true,
  enabled_commands = true,
  highlight_changed_variables = true,
  highlight_new_as_changed = false,
  show_stop_reason = true,
  commented = false,
  only_first_definition = true,
  all_references = false,
  filter_references_pattern = "<module",
  virt_text_pos = "eol",
  all_frames = false,
  virt_lines = false,
  virt_text_win_col = nil,
}

-- Auto open/close the UI around debug sessions
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticWarn", linehl = "debugPC", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◐", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "✕", texthl = "DiagnosticError", linehl = "", numhl = "" })

-- Python: debugpy, installed + managed by Mason (mason-nvim-dap)
require("dap-python").setup(vim.fn.stdpath "data" .. "/mason/packages/debugpy/venv/bin/python3")

table.insert(dap.configurations.python, {
  type = "python",
  request = "launch",
  name = "Launch file with arguments",
  program = "${file}",
  console = "integratedTerminal",
  args = function()
    local input = vim.fn.input "Command line arguments (space-separated): "
    return vim.split(input, " ", { trimempty = true })
  end,
})

-- Rust / C / C++: codelldb, installed + managed by Mason
dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = vim.fn.stdpath "data" .. "/mason/packages/codelldb/extension/adapter/codelldb",
    args = { "--port", "${port}" },
  },
}

-- Build the binary yourself first (cargo build / your compiler of choice);
-- this just prompts for the path to an already-compiled executable.
local function codelldb_launch_config()
  return {
    name = "Launch executable",
    type = "codelldb",
    request = "launch",
    program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = function()
      local input = vim.fn.input "Command line arguments (space-separated): "
      return vim.split(input, " ", { trimempty = true })
    end,
  }
end

dap.configurations.rust = { codelldb_launch_config() }
dap.configurations.cpp = { codelldb_launch_config() }
dap.configurations.c = dap.configurations.cpp
