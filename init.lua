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

-- basic settings
local vo = vim.opt
vo.clipboard = 'unnamedplus'
vo.swapfile = false
vo.number = true
vo.showmatch = true
vo.linebreak = false
vo.termguicolors = true
vo.expandtab = true
vo.shiftwidth = 2
vo.tabstop = 2
vo.softtabstop = 2
vo.smartindent = true
vo.lazyredraw = true
vo.showmode = false
vo.updatetime = 750
vo.mouse = "a"
vo.completeopt = "menu,menuone,noselect"
vo.wrap = false
vo.cursorline = true
vo.guicursor = "i:blinkon500-blinkoff500"
vo.timeoutlen = 500


-- Plugins and Packer
vim.cmd [[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
  packadd packer.nvim
]]
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'kyazdani42/nvim-web-devicons'
  use 'Pocco81/TrueZen.nvim'
  use { 'rose-pine/neovim', config = function()
      require'rose-pine'.setup({ dark_variant='moon'})
      vim.cmd('colorscheme rose-pine')
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
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  use 'onsails/lspkind-nvim'
  use {
    'folke/trouble.nvim',config=function()require'trouble'.setup()end
  }
  use { 'nvim-telescope/telescope.nvim', requires = 'nvim-lua/plenary.nvim' }
  use 'sheerun/vim-polyglot'
  use 'mattn/emmet-vim'
  use { 'windwp/nvim-autopairs',
    config = function() require'nvim-autopairs'.setup {} end
  }
end)

-- statusline
local modes = {
  ["n"] = "NORMAL",
  ["no"] = "NORMAL",
  ["v"] = "VISUAL",
  ["V"] = "VISUAL LINE",
  [" "] = "VISUAL BLOCK",
  ["s"] = "SELECT",
  ["S"] = "SELECT LINE",
  [" "] = "SELECT BLOCK",
  ["i"] = "INSERT",
  ["ic"] = "INSERT",
  ["R"] = "REPLACE",
  ["Rv"] = "VISUAL REPLACE",
  ["c"] = "COMMAND",
  ["cv"] = "VIM EX",
  ["ce"] = "EX",
  ["r"] = "PROMPT",
  ["rm"] = "MOAR",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  ["t"] = "TERMINAL"
}

local function mode()
  local cm = vim.api.nvim_get_mode().mode
  return string.format(" %s ", modes[cm]):upper()
end

vim.cmd [[
  hi StatusLineAccent guifg=bg guibg=fg
  hi StatuslineInsertAccent guifg=bg guibg=red
  hi StatuslineVisualAccent guifg=bg guibg=green
  hi StatuslineReplaceAccent guifg=bg guibg=red
  hi StatuslineCmdLineAccent guifg=bg guibg=yellow
  hi StatuslineTerminalAccent guifg=bg guibg=yellow
  hi StatuslineExtra guifg=fgfaded
]]

local function updatemodecols()
  local cm = vim.api.nvim_get_mode().mode
  local mc = "%#StatusLineAccent#"
  if cm == "n" then
    mc = "%#StatuslineAccent#"
  elseif cm == "i" or cm == "ic" then
    mc = "%#StatuslineInsertAccent#"
  elseif cm == "v" or cm == "V" or cm == " " then
    mc = "%#StatuslineVisualAccent#"
  elseif cm == "R" then
    mc = "%#StatuslineReplaceAccent#"
  elseif cm == "c" then
    mc = "%#StatuslineCmdLineAccent#"
  elseif cm == "t" then
    mc = "%#StatuslineTerminalAccent#"
  end
  return mc
end

local function filepath()
  local fp = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
  if fp == "" or fp == "." then
    return " "
  end
  return string.format(" %%<%s/", fp)
end

local function filename()
  local fname = vim.fn.expand "%:t"
  if fname == "" then return "" end
  return fname .. " "
end

local function filetype()
  return string.format(" %s", vim.bo.filetype):upper()
end

local function lineinfo()
  if vim.bo.filetype == "alpha" then
    return ""
  end
  return " %P %l:%c"
end

local function lsp()
  local count = {}
  local levels = {
    errors = "Error",
    warnings = "Warn",
    info = "Info",
    hints = "Hint"
  }
  for k, level in pairs(levels) do
    count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
  end

  local errors = ""
  local warnings = ""
  local hints = ""
  local info = ""

  if count["errors"] ~= 0 then
    errors = " %#LspDiagnosticsSignError#  " .. count["errors"]
  end
  if count["warnings"] ~= 0 then
    warnings = " %#LspDiagnosticsSignWarning#  " .. count["warnings"]
  end
  if count["hints"] ~= 0 then
    hints = " %#LspDiagnosticsSignHint#  " .. count["hints"]
  end
  if count["info"] ~= 0 then
    info = " %#LspDiagnosticsSignInformation#  " .. count["info"]
  end
  return errors .. warnings .. hints .. info .. "%#Normal#"
end

Statusline = {}
Statusline.active = function()
  return table.concat {
    "%#Statusline#",
    updatemodecols(),
    mode(),
    "%#Normal# ",
    filepath(),
    filename(),
    "%#Normal#",
    lsp(),
    "%=%#StatusLineExtra#",
    filetype(),
    lineinfo(),
  }
end
function Statusline.inactive()
  return " %F"
end

vim.cmd [[
  augroup Statusline
    autocmd!
    autocmd WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
    autocmd WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
  augroup end
]]


-- LSP and completion engine
local caps = vim.lsp.protocol.make_client_capabilities()
caps = require'cmp_nvim_lsp'.update_capabilities(caps)
local lspc = require'lspconfig'
local servers = { 'clojure_lsp', 'hls', 'tsserver' }
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
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  formatting = {
    format = lspkind.cmp_format({
        mode = 'symbol',
        maxwidth = 50,
        menu = ({
          buffer = "[Buffer]",
          nvim_lsp = "[LSP]",
          conjure = "[Conjure]",
          path = "[Path]",
          nvim_lua = "[LUA]",
          luasnip = "[Snippets]"
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
    { name = 'path' },
    { name = 'luasnip' }
  }
}


-- key bindings
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
