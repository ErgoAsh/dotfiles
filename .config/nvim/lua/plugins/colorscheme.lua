return {
    {
        "AlphaTechnolog/pywal.nvim",
        config = function()
            local lualine = require("lualine")

            lualine.setup({
                options = {
                    theme = "pywal-nvim",
                },
            })
        end,
    },
    --    {
    --        "folke/tokyonight.nvim",
    --        opts = {
    --            transparent = true,
    --            styles = {
    --                sidebars = "transparent",
    --                floats = "transparent",
    --            },
    --        },
    --    },
    {
        "LazyVim/LazyVim",
        opts = {
            --            colorscheme = "tokyonight-night",
            colorscheme = "pywal",
        },
    },
}
