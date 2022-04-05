vim.g.mapleader = ","
vim.g.maplocalleader = ","

function map_leader(combo, cmd)
  vim.api.nvim_set_keymap('n', '<leader>'..combo, cmd, { noremap = true, silent = true })
end

-- LSP
map_leader('fmt', '<cmd>:lua vim.lsp.buf.formatting()<cr>')

-- Trouble
-- vim.api.nvim_set_keymap('n', '<leader>xx', '<cmd>TroubleToggle<cr>', { noremap = true, silent = true })
map_leader('xx', '<cmd>TroubleToggle<cr>')
-- Telescope
-- vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true, silent = true })
map_leader('tf', '<cmd>Telescope find_files<cr>')
map_leader('tb', '<cmd>Telescope buffers<cr>')
map_leader('tc', '<cmd>Telescope commands<cr>')
map_leader('tch', '<cmd>Telescope command_history<cr>')
map_leader('tft', '<cmd>Telescope filetypes<cr>')

-- vim.api.nvim_set_keymap('n', '<leader>ta', '<cmd>TZAtaraxis<cr>', { noremap = true, silent = true })
map_leader('tza', '<cmd>TZAtaraxis<cr>')
