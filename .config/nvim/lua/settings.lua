-- Documentation reference: https://neovim.io/doc/user/options.html
local g = vim.g
local o = vim.o

-- Enables 24-bit RGB color 
o.termguicolors = true

-- Decrease update time
o.timeoutlen = 500
o.updatetime = 200

-- Number of screen lines to keep above and below the cursor
o.scrolloff = 8

-- Better editor UI
o.number = true -- Add line numbering on current line
o.relativenumber = true -- Add relative line numbering elsewhere
o.signcolumn = 'yes:1' -- number?
o.cursorline = true

-- o.smarttab = true
-- o.cindent = true
o.textwidth = 250

-- Better editing experience
o.expandtab = true -- Insert spaces after presisng Tab
o.tabstop = 4 -- Number of spaces that Tab equals to
o.shiftwidth = 4 -- Number of spaces for each autoindent
o.softtabstop = -1 -- If negative, shiftwidth value is used
o.autoindent = true
o.smartindent = true

o.wrap = true
o.list = false
-- o.listchars = 'trail:·,nbsp:◇,tab:→ ,extends:▸,precedes:◂'
-- o.listchars = 'eol:¬,space:·,lead: ,trail:·,nbsp:◇,tab:→-,extends:▸,precedes:◂,multispace:···⬝,leadmultispace:│   ,'
-- o.formatoptions = 'qrn1'

-- Makes neovim and host OS clipboard work together; requires xclip
o.clipboard = 'unnamedplus'

-- Case insensitive searching UNLESS /C or capital in search
o.ignorecase = true
o.smartcase = true

-- Undo and backup options
o.backup = false
o.writebackup = false
o.undofile = true
o.swapfile = false
-- o.backupdir = '/tmp/'
-- o.directory = '/tmp/'
-- o.undodir = '/tmp/'

-- Remember 50 items in commandline history
o.history = 50

-- Better buffer splitting
o.splitright = true
o.splitbelow = true

-- Preserve view while jumping
-- o.jumpoptions = 'view'

-- Folding
o.foldmethod = "indent"
-- vim.o.nofoldenable = true
o.foldlevel = 99

-- Map <leader> to space
g.mapleader = ' '
g.maplocalleader = ' '
