-- Neovim init file for neovim 0.6.0
-- Maintainer: birdboat00
-- Website: https://birdboat00.github.io/
-- GitHub: https://github.com/birdboat00
-- Last changed: 07 APR 2022

-- Auto install Packer
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

local cmd = vim.cmd
local opt = vim.opt

vim.cmd [[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
  packadd packer.nvim
]]
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'sainnhe/everforest'
  use 'kyazdani42/nvim-web-devicons'
  use 'Pocco81/TrueZen.nvim'
  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      require'lualine'.setup { options = { theme = 'everforest' }}
    end
  }
  use 'Olical/conjure'
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lua'
  use 'PaterJason/cmp-conjure'
  use 'onsails/lspkind-nvim'
  use {
    'folke/trouble.nvim',
    config = function() require'trouble'.setup {} end
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = 'nvim-lua/plenary.nvim'
  }
  use 'sheerun/vim-polyglot'
  use 'mattn/emmet-vim'
  use {
    'windwp/nvim-autopairs',
    config = function() require'nvim-autopairs'.setup {} end
  }
end)

opt.clipboard = 'unnamedplus'
opt.swapfile = false
opt.number = true
opt.showmatch = true
opt.linebreak = false
opt.termguicolors = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.lazyredraw = true
opt.colorcolumn = "75"
opt.showmode = false
opt.updatetime = 750
opt.mouse = "a"
opt.completeopt = "menu,menuone,noselect"
opt.wrap = false

cmd [[
  let g:everforest_background = 'soft'
  colorscheme everforest
  set cursorline
  hi CursorLine term=bold cterm=bold guibg=Grey40
]]

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
          path = "[Path]",
          nvim_lua = "[LUA]"
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
    { name = 'nvim_lua' },
    { name = 'conjure' },
    { name = 'buffer' },
    { name = 'path' }
  }
}

vim.g.mapleader = ","
vim.g.maplocalleader = ","
function map_leader(combo, cmd)
  local opts = { noremap = true, silent = true } 
  vim.api.nvim_set_keymap('n', '<leader>'..combo, cmd, opts)
end
-- LSP
map_leader('fmt', '<cmd>:lua vim.lsp.buf.formatting()<cr>')
map_leader('lrn', '<cmd>:lua vim.lsp.buf.rename()<cr>')
-- Trouble
map_leader('xx', '<cmd>TroubleToggle<cr>')
-- Telescope
map_leader('ff', '<cmd>Telescope find_files<cr>')
map_leader('fb', '<cmd>Telescope buffers<cr>')
map_leader('fc', '<cmd>Telescope commands<cr>')
map_leader('fg', '<cmd>Telescope git_status<cr>')
map_leader('tch', '<cmd>Telescope command_history<cr>')
map_leader('tft', '<cmd>Telescope filetypes<cr>')
map_leader('tza', '<cmd>TZAtaraxis<cr>')
