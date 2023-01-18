local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    use('wbthomason/packer.nvim') -- packer package
    use('nvim-lua/plenary.nvim') -- lua package with async utils

    use { -- nightfly color scheme
        'folke/tokyonight.nvim',
    }

    use { -- bottom status bar
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    }

    use { -- text highlighting based on language
        'nvim-treesitter/nvim-treesitter',
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    }

    use { -- hex color codes colorizer
        'ap/vim-css-color',
    }

    use(
    { -- telescope fuzzy finder
        {
            'nvim-telescope/telescope.nvim',
            event = 'cursorhold',
            -- config = function()
            --    require('configs.telescope')
            -- end,
        },
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            after = 'telescope.nvim',
            run = 'make',
            config = function()
                require('telescope').load_extension('fzf')
            end,
        },
        {
            'nvim-telescope/telescope-symbols.nvim',
            after = 'telescope.nvim',
        },
    })

    use {
        'vonheikemen/lsp-zero.nvim',
        requires = {
            -- lsp support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},

            -- snippets
            {'l3mon4d3/luasnip'},
            {'rafamadriz/friendly-snippets'},
        }
    }

    use { -- blank line highlighting
        'lukas-reineke/indent-blankline.nvim',
    }

    use { -- git changes on sidebar
        'lewis6991/gitsigns.nvim',
    }

    use { -- improved file movement
        'phaazon/hop.nvim',
    }

    use {
        "max397574/better-escape.nvim",
        config = function()
            require("better_escape").setup()
        end,
    }

    use {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup()
        end
    }

    use {
        'numtostr/comment.nvim',
        --config = function()
        --    require('comment').setup()
        --end
    }

    use {
        "windwp/nvim-autopairs",
        config = function() 
            require("nvim-autopairs").setup()
        end
    }

    use { -- git diff
        'timuntersberger/neogit', 
        requires = 'nvim-lua/plenary.nvim',
        config = function()
            require('neogit').setup()
        end
    }

    use (
    {
        {
            'sirver/ultisnips'
        },
        {
            'honza/vim-snippets'
        }
    })

    use {
        'theprimeagen/vim-be-good'
    }

    use {
        'lervag/vimtex',
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)


