vim.cmd [[ packadd packer.nvim ]]

require('packer').startup(function (use)

  -- plugin manager (self)
  use 'wbthomason/packer.nvim'

  -- colorscheme
  use 'morhetz/gruvbox'
  use 'sainnhe/everforest'

  --  file explorer
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons'
    },
    config = function()
      require'nvim-tree'.setup {
        git = {
          enable = false
        }
      }
      vim.cmd [[ nnoremap <C-t> :NvimTreeToggle<CR> ]]
    end
  }

  -- editorconfig plugin
  use 'editorconfig/editorconfig-vim'

  -- writer mode
  use 'junegunn/goyo.vim'
  
  -- statusline
  use {
    'famiu/feline.nvim',
    config = function()
      require('feline').setup({})
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
  use 'ap/vim-css-color'

  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup{}
    end
  }

end)
