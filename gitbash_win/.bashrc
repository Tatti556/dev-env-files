
# Git Bash launched from WezTerm may not inherit USER.
if [[ -z ${USER-} ]]; then
    USER=$(id -un)
    export USER
fi

# Load ble.sh before other interactive-shell settings and attach it after them.
[[ $- == *i* ]] && source -- "$HOME/.local/share/blesh/ble.sh" --attach=none

# export XDG_CONFIG_HOME="$APPDATA"

export STARSHIP_CONFIG="$HOME/.config/starship.toml"
eval "$(starship init bash)"
eval "$(fzf --bash)"
eval "$(zoxide init bash)"
__zoxide_pwd() {
    command cygpath -w "$(builtin pwd -L)"
}
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first --git --header' 
alias lt='eza --tree --level=2 --icons'

alias vim="nvim"
alias agy="antigravity"

[[ ! ${BLE_VERSION-} ]] || ble-attach
