-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Open Claude Code in a Zellij floating pane
vim.keymap.set('n', '<F1>', function()
  vim.fn.system('zellij action new-pane --floating -- claude')
end, { desc = 'Open Claude Code' })

-- Disable the intro/welcome screen
vim.opt.shortmess:append("I")

-- Suppress all popup notifications
vim.notify = function() end
