vim.cmd [[ packadd packer.nvim ]]

require('packer').startup(function (use)

  -- plugin manager (self)
  use 'wbthomason/packer.nvim'

  -- colorscheme
  use 'sainnhe/everforest'

  -- icons
  use 'kyazdani42/nvim-web-devicons'

  -- editorconfig plugin
  use 'editorconfig/editorconfig-vim'

  -- writer mode
  use 'Pocco81/TrueZen.nvim'

  -- statusline
  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      require'lualine'.setup({
        options = {
          theme = 'everforest',

        }
      })
    end
  }
  
  -- Clojure REPL support
  use 'Olical/conjure'

  -- lsp and completion
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lua'
  use 'PaterJason/cmp-conjure'
  use 'onsails/lspkind-nvim'

  -- dispatch and jack-in
  use 'tpope/vim-dispatch'
  use 'clojure-vim/vim-jack-in'
  use 'radenling/vim-dispatch-neovim'

  -- list for showing diagnostics
  use {
    'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require'trouble'.setup({})
    end
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = 'nvim-lua/plenary.nvim'
  }

  use 'sheerun/vim-polyglot'
  use 'mattn/emmet-vim'

  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup()
    end
  }
end)

