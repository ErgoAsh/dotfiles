if status is-interactive
    bass source ~/.profile
    bass source .env

    set -xg TMPDIR '/tmp'
    set -xg SHELL 'fish'
    set -xg EDITOR 'nvim'
    set -xg VISUAL 'nvim'
    set -xg BROWSER 'qutebrowser'
    set -xg DEFAULT_USER 'ergoash'

    set -xg PAGER "bat --wrap=never --style=numbers,changes"
    set -xg MANPAGER "sh -c 'col -bx | bat --language=man --style=numbers,rule'" 
    set -xg MANROFFOPT "-c"
    set -xg MANWIDTH (math $COLUMNS - 6)

    set -xg NNN_FIFO '/tmp/nnn.fifo'
    set -xg NNN_BMS 'd:$HOME/Downloads;c:$HOME/.config'
    set -xg NNN_PLUG_COPY 'c:!convert "$nnn" png:- | xclip -sel clipboard -t image/png*'
    set -xg NNN_PLUG 'f:finder;o:fzopen;p:mocq;d:diffs;t:nmount;v:preview-tui;c:$NNN_PLUG_COPY'

    alias dotfiles '/usr/bin/git --git-dir=/home/ergoash/.dotfiles --work-tree=/home/ergoash'
    alias dot '/usr/bin/git --git-dir=/home/ergoash/.dotfiles --work-tree=/home/ergoash'
    alias ll 'exa -aFhl --no-user --time-style=long-iso --group-directories-first'
    alias path 'echo $PATH | tr -s ":" "\n"'
    alias fonts "fc-list : family | sort"
    alias ncspot "env TERM=xterm-256color sh -c 'ncspot'"
    alias software "yay -Qett --color=always | bat"
    alias ssh "kitty +kitten ssh"

    abbr cat "bat"
    abbr grep "rg"
    abbr find "fd"
    abbr df "duf"
    abbr mixer "ncpamixer"
    abbr calc 'qalc'
    abbr c 'qalc'
    abbr pacman 'yay -S'
    abbr vi 'nvim'

    fish_vi_key_bindings
    fish_vi_cursor

    set fish_cursor_default     block      blink
    set fish_cursor_insert      line       blink
    set fish_cursor_replace_one underscore blink
    set fish_cursor_visual      block

    fzf_configure_bindings --git_status=\cs --git_log=\cg --history=\ch --variables=\cv --processes=\cp --directory=\cf 
    
end

if status is-login
    exec startx
end

function fish_greeting
    fortune | cowsay | lolcat
end
