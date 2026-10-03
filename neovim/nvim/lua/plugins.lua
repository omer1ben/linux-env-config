-- Plugins are installed into stdpath('data')/plugged; run :PlugInstall after
-- adding one.
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('ellisonleao/gruvbox.nvim')

-- LSP servers (Mason installs them) and their configs.
Plug('williamboman/mason.nvim')
Plug('williamboman/mason-lspconfig.nvim')
Plug('neovim/nvim-lspconfig')

-- Completion.
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-cmdline')

-- Snippets.
Plug('dcampos/nvim-snippy')
Plug('dcampos/cmp-snippy')

Plug('tpope/vim-eunuch')
Plug('tpope/vim-fugitive')
Plug('junegunn/fzf')
Plug('aradzu10/fzf.vim')

vim.call('plug#end')
