vim.keymap.set('n', '<leader>nt', ':Neotree toggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>nf', ':Neotree focus<CR>', { noremap = true, silent = true })

-- Tab management
vim.keymap.set('n', '<C-x>', ':bdelete<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'P', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'N', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })

-- Fold management
vim.opt.foldcolumn = '0'
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldtext = ''

vim.opt.foldnestmax = 3
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

local function close_all_folds()
  vim.api.nvim_exec2('%foldc!', { output = false })
end
local function open_all_folds()
  vim.api.nvim_exec2('%foldo!', { output = false })
end

vim.keymap.set('n', '<leader>zs', close_all_folds, { desc = '[s]hut all folds' })
vim.keymap.set('n', '<leader>zo', open_all_folds, { desc = '[o]pen all folds' })
