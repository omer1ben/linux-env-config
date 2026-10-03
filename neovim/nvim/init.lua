-- Plugins first: everything below may depend on them.
require('plugins')

-- Options and keybindings shared with vim.
local base = vim.fn.expand('~/.vim/base.vim')
if vim.fn.filereadable(base) == 1 then
  vim.cmd.source(base)
end

vim.o.background = 'dark'
vim.cmd.colorscheme('gruvbox')

require('completion')
require('lsp')
