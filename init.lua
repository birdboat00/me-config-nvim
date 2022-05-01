-- Neovim init file for neovim 0.6.0
-- Maintainer: birdboat00
-- Website: https://birdboat00.github.io/
-- GitHub: https://github.com/birdboat00
-- Last changed: 16 APR 2022

-- Auto install Packer
local pip = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(pip)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim '..pip)
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

-- Plugins and Packer
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "init.lua",
  callback = function(args)
    vim.cmd"PackerCompile"
  end
})
vim.cmd"packadd packer.nvim"
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
  use 'gpanders/nvim-parinfer'
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
  use { 'nvim-telescope/telescope.nvim', requires = 'nvim-lua/plenary.nvim' }
  use 'mattn/emmet-vim'
  use 'adelarsq/neofsharp.vim'
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
  hi StatusLineAccent         guifg=bg guibg=#ea9a97
  hi StatuslineInsertAccent   guifg=bg guibg=#f6c177
  hi StatuslineVisualAccent   guifg=bg guibg=#eb6f92
  hi StatuslineReplaceAccent  guifg=bg guibg=#eb6f92
  hi StatuslineCmdLineAccent  guifg=bg guibg=#3e8fb0
  hi StatuslineTerminalAccent guifg=bg guibg=#3e8fb0
  hi StatuslineExtra          guifg=#908caa
]]

local function modecol()
  local modecols = {
    ["n"] = "%#StatuslineAccent#",
    ["i"] = "%#StatuslineInsertAccent#",
    ["ic"] = "%#StatuslineInsertAccent#",
    ["v"] = "%#StatuslineVisualAccent#",
    ["V"] = "%#StatuslineVisualAccent#",
    [" "] = "%#StatuslineVisualAccent#",
    ["R"] = "%#StatuslineReplaceAccent#",
    ["c"] = "%#StatuslineCmdLineAccent#",
    ["t"] = "%#StatuslineTerminalAccent#"
  }
  return modecols[vim.api.nvim_get_mode().mode]
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
  return fname == "" and "" or fname .. " "
end

local function filetype()
  return string.format(" %s", vim.bo.filetype):upper()
end

local function lineinfo()
  return vim.bo.filetype == "alpha" and "" or " %P %l:%c"
end

local function lsp()
  local count = {}
  local levels = {
    errors = "Error", warnings = "Warn", info = "Info", hints = "Hint"
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
    modecol(),
    mode(),
    "%#Normal#",
    filepath(),
    filename(),
    "%#Normal#",
    lsp(),
    "%=%#StatusLineExtra#",
    filetype(),
    lineinfo(),
  }
end
Statusline.inactive = function() return " %F" end

vim.api.nvim_create_autocmd("WinEnter,BufEnter", {
  pattern = "*",
  callback = function(args)
    vim.cmd"setlocal statusline=%!v:lua.Statusline.active()"
  end
})
vim.api.nvim_create_autocmd("WinLeave,BufLeave", {
  pattern = "*",
  callback = function(args)
    vim.cmd"setlocal statusline=%!v:lua.Statusline.inactive()"
  end
})

-- LSP and completion engine
local caps = vim.lsp.protocol.make_client_capabilities()
caps = require'cmp_nvim_lsp'.update_capabilities(caps)
local lspc = require'lspconfig'
local servers = { 'clojure_lsp', 'hls', 'tsserver', 'fsautocomplete' }
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
        mode = 'symbol_text',
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
function remap(mode, combo, cmd)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_set_keymap(mode, combo, cmd, opts)
end
function map_leader(combo, cmd)
  remap('n', '<leader>'..combo, cmd)
end
-- NVIM
map_leader('bbd', '<cmd>:bd<cr>')
-- LSP
map_leader('fmt', '<cmd>:lua vim.lsp.buf.formatting()<cr>')
map_leader('lrn', '<cmd>:lua vim.lsp.buf.rename()<cr>')
-- Telescope
map_leader('xx', '<cmd>Telescope diagnostics<cr>')
map_leader('ff', '<cmd>Telescope find_files<cr>')
map_leader('fb', '<cmd>Telescope buffers<cr>')
map_leader('fc', '<cmd>Telescope commands<cr>')
map_leader('fg', '<cmd>Telescope git_status<cr>')
map_leader('tch', '<cmd>Telescope command_history<cr>')
map_leader('ft', '<cmd>Telescope filetypes<cr>')
map_leader('tza', '<cmd>TZAtaraxis<cr>')
-- autobrace
remap('i', '{', '{}<Esc>ha')
remap('i', '(', '()<Esc>ha')
remap('i', '[', '[]<Esc>ha')
remap('i', '"', '""<Esc>ha')
remap('i', "'", "''<Esc>ha")

-- Settings for different filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown", 
  callback = function(args)
    vim.cmd"set wrap"
  end
})
vim.api.nvim_create_autocmd("BufNewfile,BufRead", {
  pattern = "*.fs,*.fsx,*.fsi",
  callback = function(args)
    vim.cmd"set filetype=fsharp"
  end
})

-- Autocreate folder on save
function mkdsave()
  local dir = vim.fn.expand("<afile>:p:h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, 'p')
  end
end
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    mkdsave()
  end
})
