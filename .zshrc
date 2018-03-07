# Allow [ or ] whereever you want
unsetopt nomatch
# Initialize zplug.
source ~/.zplug/init.zsh
# Themes
# zplug "sindresorhus/pure", as:theme, use:"*.zsh"
zplug "denysdovhan/spaceship-zsh-theme", use:spaceship.zsh, from:github, as:theme
zplug "lib/completion", from:oh-my-zsh, lazy:true
zplug "lib/history", from:oh-my-zsh, lazy:true
# zplug "zsh-users/zsh-history-substring-search"
zplug "lib/key-bindings", from:oh-my-zsh
# zplug "lib/theme-and-appearance", from:oh-my-zsh
zplug "lib/spectrum", from:oh-my-zsh, lazy:true
zplug "plugins/git", from:oh-my-zsh, ignore:oh-my-zsh.sh, lazy:true
zplug "lib/clipboard", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"

# zplug "plugins/colorize", from:oh-my-zsh, ignore:ph-my-zsh.sh
# zplug "plugins/chruby", from:oh-my-zsh, ignore:ph-my-zsh.sh, lazy:true, defer:1
zplug "plugins/rails", from:oh-my-zsh, ignore:ph-my-zsh.sh, lazy:true, defer:3
zplug "plugins/osx", from:oh-my-zsh, ignore:ph-my-zsh.sh, lazy:true, defer:1
zplug "plugins/bundler", from:oh-my-zsh, ignore:ph-my-zsh.sh, lazy:true, defer:2
zplug "plugins/mix", from:oh-my-zsh, ignore:ph-my-zsh.sh, lazy:true, defer:2
zplug "plugins/command-not-found", from:oh-my-zsh, ignore:oh-my-zsh.sh, defer:3, lazy:true
zplug "plugins/common-aliases", from:oh-my-zsh, ignore:oh-my-zsh.sh, defer:3
zplug "djui/alias-tips"
zplug "zsh-users/zsh-syntax-highlighting", defer:3
zplug "Valiev/almostontop"
# Check for uninstalled plugins.
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Source plugins.
zplug load # --verbose
almostontop on
# Theme setting
SPACESHIP_TIME_SHOW=false
# source $ZSH/oh-my-zsh.sh

# FileSearch
function f() { find . -iname "*$1*" ${@:2} }
function r() { ag "$1" ${@:2} -R . }
function mkcd() { mkdir -p "$@" && cd "$_"; } # mkdir and cd

# Aliases
alias c="clear"
alias e="/Applications/Emacs.app/Contents/MacOS/Emacs" # run Emacs client in GUI
alias em="emacsclient -nw" # run Emacs client in Terminal
alias vim="em"
# Use Emacs for editing config files
alias zshconf="emacsclient -nw ~/.zshrc"
alias envconf="emacsclient -nw ~/env.sh"
alias be="bundle exec"
alias bespec="bundle exec rspec"

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export PATH=/Users/dmitry/bin:/opt/X11/bin:/usr/local/MacGPG2/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:./node_modules/.bin:/usr/local/opt/go/libexec/bin:/usr/local/opt/go/libexec/bin:/usr/local//usr/local/mysql/bin/private/var/mysql/private/var/mysql/bin
export MANPATH=/usr/local/man:$MANPATH
export HOMEBREW_GITHUB_API_TOKEN="4fd3e26aa04ff5bf9453a8a4600d6f4342243485"
export GOPATH=$HOME/Code/wetransfer/go_workspace


# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='em'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

source /usr/local/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh
chruby ruby-2.3.5

# kiex, Elixir versions manager
source $HOME/.kiex/elixirs/elixir-1.4.5.env
[[ -s "$HOME/.kiex/scripts/kiex" ]] && source "$HOME/.kiex/scripts/kiex"
# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
function iterm2_print_user_vars() {
    iterm2_set_user_var currentTime $(date +%H:%M:%S)
}

# added by travis gem
# [ -f /Users/dmitry/.travis/travis.sh ] && source /Users/dmitry/.travis/travis.sh

export PATH="$HOME/.yarn/bin:$PATH"
