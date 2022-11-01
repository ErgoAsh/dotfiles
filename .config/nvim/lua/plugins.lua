-- Automatically run :PackerCompile whenever plugins.lua is updated with an autocommand:
vim.api.nvim_create_autocmd('BufWritePost', {
    group = vim.api.nvim_create_augroup('PACKER', { clear = true }),
    pattern = 'plugins.lua',
    command = 'source <afile> | PackerCompile',
})

return require('packer').startup({
    function(use)

        use('wbthomason/packer.nvim') -- Packer package
        use('nvim-lua/plenary.nvim') -- Lua package with async utils

        use { -- Nightfly color scheme
            'folke/tokyonight.nvim',
            config = function()
                require("configs.theme-config")
            end
        }

        use { -- Bottom status bar
            'nvim-lualine/lualine.nvim',
            config = function()
                require("configs.lualine-config")
            end,
            requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        }

        use { -- Text highlighting based on language
            'nvim-treesitter/nvim-treesitter',
            run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
            config = function()
                require("configs.treesitter-config")
            end
        }

        use { -- Hex color codes colorizer
            'ap/vim-css-color',
        }

        use { -- Note taking/diary/wiki system
            'vimwiki/vimwiki',
            config = function() 
                require("configs.vimwiki-config")
            end
        }

        use(
        { -- Telescope fuzzy finder
            {
                'nvim-telescope/telescope.nvim',
                event = 'CursorHold',
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

        use(
        { -- LSP server
            {
                'neovim/nvim-lspconfig'
            },
            {
                'glepnir/lspsaga.nvim',
                branch = "main",
                config = function()
                    require('configs.lspsaga-config')
                end
            }
        })

        use { -- Blank line highlighting
            'lukas-reineke/indent-blankline.nvim',
            config = function() 
                require('configs.blankline-config')
            end
        }

        use { -- Git changes on sidebar
            'lewis6991/gitsigns.nvim',
            config = function()
                require('configs.gitsigns-config')
            end
        }

        use { -- Improved file movement
            'phaazon/hop.nvim',
            config = function()
                require('configs.hop-config')
            end
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
                require("which-key").setup (
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
                )
            end
        }

        use {
            'numToStr/Comment.nvim',
            config = function()
                require('Comment').setup()
            end
        }

        use {
            "windwp/nvim-autopairs",
            config = function() require("nvim-autopairs").setup {} end
        }

        use {
            'goolord/alpha-nvim',
            config = function ()
                require('alpha').setup(require('alpha.themes.dashboard').config)
            end
        }

        use { -- Git diff
            'TimUntersberger/neogit', 
            requires = 'nvim-lua/plenary.nvim',
            config = function()
                require('neogit').setup()
            end
        }

        use (
        {
            {
                'SirVer/ultisnips'
            },
            {
                'honza/vim-snippets'
            }
        })

        use {
            'ThePrimeagen/vim-be-good'
        }

        use {
            'lervag/vimtex',
            config = function()
                require('configs.vimtex-config')
            end
        }
    end,
    -- Plugin configuration end --
    config = {
        display = {
            open_fn = function()
                return require('packer.util').float({ border = 'single' })
            end,
        },
    },
})


