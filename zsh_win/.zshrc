# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Created by newuser for 5.9.2

# Scoop の Node.js と、npm で導入したコマンド
export PATH="$HOME/scoop/apps/nodejs/current/bin:$HOME/scoop/apps/nodejs/current:$PATH"
export PATH="$PATH:$HOME/scoop/shims"

# Tab 補完
autoload -Uz compinit
compinit

# 履歴に基づく入力候補
source ~/.config/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# eza
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first --git'
alias lt='eza --tree --level=2 --icons'

alias nvim="$HOME/scoop/shims/nvim.exe"
alias vim='nvim'
alias opencode="$HOME/scoop/shims/opencode.exe"
alias agy="$HOME/.antigravity-cli/antigravity.exe"

# Powerlevel10k
source ~/.config/.zsh/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ディレクトリ移動履歴：z と zi
eval "$(zoxide init zsh)"

# fzf連携
eval "$(fzf --zsh)"

zstyle ':completion:*' menu select

# zoxide 0.10.0 の MSYS2 向け修正
function __zoxide_pwd() {
  command cygpath -w "$(builtin pwd -L)"
}

# ==========================================
# History
# ==========================================

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# ==========================================
# History Search
# ==========================================

# 上下矢印キーで入力文字列に一致する履歴を検索
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ==========================================
# Editor
# ==========================================

export EDITOR="nvim"
export VISUAL="nvim"

# ==========================================
# Alias
# ==========================================

# zsh設定ファイルを編集
alias edit-zsh="nvim ~/.zshrc"

# zshを再起動して設定を読み込み直す
alias reload-zsh="exec zsh"

# コマンド入力中の色分け（最後に読み込む）
source ~/.config/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
