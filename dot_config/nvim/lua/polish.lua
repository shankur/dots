-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Open Claude Code in a new Zellij tab
vim.keymap.set('n', '<F1>', function()
  vim.fn.system('zellij action new-tab --name "Claude" && sleep 0.1 && zellij run --close-on-exit --in-place -- claude')
end, { desc = 'Open Claude Code' })

-- Disable the intro/welcome screen
vim.opt.shortmess:append("I")

-- Suppress all popup notifications
vim.notify = function() end
