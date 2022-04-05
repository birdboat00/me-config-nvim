local cmd = vim.cmd
local exec = vim.api.nvim_exec
local g = vim.g
local opt = vim.opt

opt.clipboard = 'unnamedplus'
opt.swapfile = false

opt.number = true
opt.showmatch = true
opt.linebreak = false
opt.termguicolors = true

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

opt.lazyredraw = true

opt.colorcolumn = "80"
opt.showmode = false

opt.updatetime = 750

opt.mouse = "a"

opt.completeopt = "menu,menuone,noselect"

cmd [[
  let g:everforest_background = 'soft'
  colorscheme everforest
]]
