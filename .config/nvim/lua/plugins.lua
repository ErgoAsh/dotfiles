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

        use { -- Tender color scheme
            'bluz71/vim-nightfly-guicolors'
        }

        use { -- Bottom status bar
            'nvim-lualine/lualine.nvim',
            config = function()
                require("plugins.lualine-config")
            end,
            requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        }

        use { -- Hex color codes colorizer
            'ap/vim-css-color',
        }

        use { -- Note taking/diary/wiki system
            'vimwiki/vimwiki',
            config = function() 
                require("plugins.vimwiki-config")
            end
        }

        use({ -- Telescope fuzzy finder
            {
                'nvim-telescope/telescope.nvim',
                event = 'CursorHold',
                -- config = function()
                --    require('plugins.telescope')
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
            'SirVer/ultisnips'
        }

        use {
            'lervag/vimtex'
        }
    end,
    config = {
        display = {
            open_fn = function()
                return require('packer.util').float({ border = 'single' })
            end,
        },
    },
})


