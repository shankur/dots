-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Open Claude Code in a right split with terminal below
vim.keymap.set('n', '<F1>', function()
  local cmd = table.concat({
    'zellij action new-pane --direction right --close-on-exit --name "Claude" -- claude',
    'zellij action new-pane --direction down --name "Terminal"',
    'zellij action focus-previous-pane',
  }, ' && ')
  vim.fn.system(cmd)
end, { desc = 'Open Claude Code + Terminal layout' })

-- Disable the intro/welcome screen
vim.opt.shortmess:append("I")

-- Suppress all popup notifications
vim.notify = function() end
