local caps = vim.lsp.protocol.make_client_capabilities()
caps = require'cmp_nvim_lsp'.update_capabilities(caps)

local lspc = require'lspconfig'
local servers = { 'clojure_lsp', 'tsserver' }
for _, lsp in pairs(servers) do
  lspc[lsp].setup({
    flags = {
      debounce_text_changes = 150
    },
    capabilities = caps
  })
end

local cmp = require'cmp'
local lspkind = require'lspkind'
cmp.setup {
  formatting = {
    format = lspkind.cmp_format({
        mode = 'symbol',
        maxwidth = 50,
        menu = ({
          buffer = "[Buffer]",
          nvim_lsp = "[LSP]",
          conjure = "[Conjure]",
          path = "[Path]"
        })
      })
  },
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true
    },
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'conjure' },
    { name = 'buffer' },
    { name = 'path' }
  }
}
