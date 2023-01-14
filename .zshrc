# Path to your oh-my-zsh installation.A
export ZSH="/home/evan/.oh-my-zsh"
ZSH_THEME="bureau"

# Enable colors and change prompt:
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "


# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history



# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then

        dir="$(cat "$tmp")"
        rm -f "$tmp"

        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

bindkey -s '^o' 'lfcd\n'

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line


# Load aliases and shortcuts if existent.
[ -f "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

export EDITOR="/usr/local/bin/nvim"
export VISUAL="/usr/local/bin/nvim"

# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

if command -v pyenv 1>/dev/null 2>&1; then
 eval "$(pyenv init -)"
fi

# (The below instructions are intended for common
# shell setups. See the README for more guidance
# if they don't apply and/or don't work for you.)

# Add pyenv executable to PATH and
# enable shims by adding the following
# to ~/.profile and ~/.zprofile:

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# Load pyenv into the shell by adding
# the following to ~/.zshrc:

eval "$(pyenv init -)"

# Make sure to restart your entire logon session
# for changes to profile files to take effect.

alias cf='clang-format -style="{IndentWidth: 4, AlignConsecutiveAssignments: true,

                               AlignConsecutiveDeclarations: true, BasedOnStyle: Google}"'

alias cfi='clang-format -i -style="{IndentWidth: 4, AlignConsecutiveAssignments: true,
                                   AlignConsecutiveDeclarations: true, BasedOnStyle: Google}"'
alias cfia='clang-format -i -style="{IndentWidth: 4, AlignConsecutiveAssignments: true,
                                    AlignConsecutiveDeclarations: true, BasedOnStyle: Google,
                                    BreakBeforeBraces: Allman}"'
alias cse='ssh z5368211@cse.unsw.edu.au'



csenvim() {
    nvim scp://z5368211@cse.unsw.edu.au//import/adams/5/z5368211/"$1" 
}

gcs() {
    git clone git@github.com:/evan-a-w/"$1"
}

val() {
    valgrind -q --leak-check=full "$@"
}

back() {
    (cd .. && "$@")
}


nvimp() {
    nvim -p $(find . | rg "$1")
}


alias gas='git add *; git add -u; git commit -m "😊"; git push'


gitblames() {
    if [ "$1" = "\n" ] || [ "$1" = "" ]; then
        echo "git ls-files | while read f; do git blame -w -M -C -C --line-porcelain $f | grep '^author '; done | sort -f | uniq -ic | sort -rn"
        git ls-files | while read f; do git blame -w -M -C -C --line-porcelain $f | grep '^author '; done | sort -f | uniq -ic | sort -rn;

    else
        echo "git ls-files | rg "$1" | while read f; do git blame -w -M -C -C --line-porcelain $f | grep '^author '; done | sort -f | uniq -ic | sort -rn"

        git ls-files | rg "$1" | while read f; do git blame -w -M -C -C --line-porcelain $f | grep '^author '; done | sort -f | uniq -ic | sort -rn
    fi
}

eval "$(pyenv init -)"

export PATH="$PATH:/home/evan/.local/bin"

alias rlib='cd ~/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/'

export NVM_DIR="$HOME/.nvm"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


export PATH=/usr/class/bin:$PATH


alias sys161kern="sys161 -p 16161 kernel"

alias sys161kernw="sys161 -p 16161 -w kernel"

alias ctg="ctags --recurse=yes --exclude=.git --exclude=BUILD --exclude=.svn"


function osb() {
    p=`pwd`;
    cd "$HOME/cs3231/asst$1-src/kern/compile/ASST$1";
    bmake depend;
    bmake;
    bmake install;

    cd $p;
}

function osc() {
    p=`pwd`;
    cd "$HOME/cs3231/asst$1-src/kern/compile/ASST$1";

    bmake && bmake install;

    cd $p;
}

# opam configuration
test -r /home/evan/.opam/opam-init/init.zsh && . /home/evan/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

[ -f "/home/evan/.ghcup/env" ] && source "/home/evan/.ghcup/env" # ghcup-env

gco() {
    filename="${1%.*}"
    g++ -o "${filename}" "$filename.c" "${@:2}" -Werror -Wall -g -Wshadow -lm -fsanitize=address
}

gpr() {
    filename="${1%.*}"
    g++ -o "${filename}" "$filename.cpp" "${@:2}" -Werror -Wall -g -Wshadow -lm -fsanitize=address -std=gnu++2a && ./"${filename}"

}

gpru() {
    filename="${1%.*}"
    g++ -o "${filename}" "$filename.cpp" "${@:2}" -Werror -Wall -g -Wshadow -lm -std=gnu++2a && ./"${filename}"

}

gpr14() {
    filename="${1%.*}"
    g++ -o "${filename}" "$filename.cpp" "${@:2}" -Werror -Wall -g -Wshadow -lm -fsanitize=address -std=gnu++14 && ./"${filename}"

}

gpo() {
    filename="${1%.*}"
    g++ -o "${filename}" "$filename.cpp" "${@:2}" -Werror -Wall -g -Wshadow -lm -fsanitize=address -std=gnu++2a

}


gpi() {
    filename="${1%.*}"
    g++ -o "${filename}" "$filename.cpp" "${@:2}" -Werror -Wall -g -Wshadow -lm -fsanitize=address &&
    ./"${filename}" < "${filename}.in"
}

clip_file() {
    if [ -f "$1" ]; then
        cat "$1" | clip.exe
    else
        echo "File $1 does not exist"
    fi
}


alias cf='clip_file'

export COLORTERM=truecolor
