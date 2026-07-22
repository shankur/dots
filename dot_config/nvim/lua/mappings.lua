require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- Open Claude Code in a right split with terminal below
map("n", "<F1>", function()
  local cmd = table.concat({
    'zellij action new-pane --direction right --close-on-exit --name "Claude" -- claude',
    'zellij action new-pane --direction down --name "Terminal"',
    'zellij action focus-previous-pane',
  }, ' && ')
  vim.fn.system(cmd)
end, { desc = "Open Claude Code + Terminal layout" })
