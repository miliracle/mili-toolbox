-- save by pressing Escape
vim.keymap.set('n', '<Esc>', ':w<CR>', { desc = 'Save' })
-- select all
vim.keymap.set('n', '<C-a>', 'ggVG', { desc = 'Select All' })
-- pasting over a selection no longer clobbers your clipboard
vim.cmd([[ xnoremap <expr> p 'pgv"'.v:register.'y' ]])
-- find and replace
vim.keymap.set('v', '<leader>s', ':s/', { desc = 'Find & Replace (selection)' })
vim.keymap.set('n', '<leader>s', ':%s/', { desc = 'Find & Replace (file)' })
vim.keymap.set('n', '<leader>sw', ':%s/\\<<C-r><C-w>\\>/', { desc = 'Replace word under cursor' })
