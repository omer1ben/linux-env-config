-- Servers to use; Mason installs any that are missing on startup.
local servers = { 'jedi_language_server', 'clangd', 'lua_ls', 'ruff' }

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = servers,
  -- Servers are enabled below, together with their capabilities.
  automatic_enable = false,
})

-- Server configs come from nvim-lspconfig; nvim's native API enables them.
vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})
-- Ruff provides Python formatting (jedi doesn't support it) plus linting;
-- jedi stays the completion/goto server.
vim.lsp.enable(servers)

-- Keymaps for any buffer with an attached server.
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    -- Format the whole buffer: ruff (python), clangd (c/c++), lua_ls (lua)
    vim.keymap.set('n', '<C-f>', function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end,
})
