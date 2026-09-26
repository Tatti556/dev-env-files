# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Created by newuser for 5.9.2


# ==========================================
# PATH
# ==========================================

# Scoop の Node.js と、npm で導入したコマンド
export PATH="$HOME/scoop/apps/nodejs/current/bin:$HOME/scoop/apps/nodejs/current:$PATH"

# Scoop shims
export PATH="$PATH:$HOME/scoop/shims"


# ==========================================
# Completion
# ==========================================

# Tab 補完
autoload -Uz compinit
compinit

# Tab補完候補をメニュー形式で選択
zstyle ':completion:*' menu select


# ==========================================
# zsh-autosuggestions
# ==========================================

# 履歴に基づく入力候補
source ~/.config/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh


# ==========================================
# eza
# ==========================================

alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first --git'
alias lt='eza --tree --level=2 --icons'


# ==========================================
# Command Alias
# ==========================================

alias nvim="$HOME/scoop/shims/nvim.exe"
alias vim='nvim'

alias opencode="$HOME/scoop/shims/opencode.exe"

alias agy="$HOME/.antigravity-cli/antigravity.exe"


# ==========================================
# Powerlevel10k
# ==========================================

source ~/.config/.zsh/powerlevel10k/powerlevel10k.zsh-theme

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh


# ==========================================
# Zoxide
# ==========================================

# ディレクトリ移動履歴：z と zi
eval "$(zoxide init zsh)"

# zoxide 0.10.0 の MSYS2 向け修正
function __zoxide_pwd() {
  command cygpath -w "$(builtin pwd -L)"
}


# ==========================================
# fzf
# ==========================================

# ------------------------------------------
# fd を fzf の検索元として使用
# ------------------------------------------

# 通常の fzf
#
# --hidden
#   .zshrc や .config などの隠しファイルも検索する
#
# --strip-cwd-prefix
#   ./foo/bar の先頭 ./ を取り除く
#
# --exclude
#   検索不要な巨大ディレクトリを除外する
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix \
  --exclude .git \
  --exclude node_modules \
  --exclude .venv"

# Ctrl + T
# ファイルとディレクトリを検索
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Alt + C
# ディレクトリだけを検索
export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix \
  --exclude .git \
  --exclude node_modules \
  --exclude .venv"


# ------------------------------------------
# Ctrl + T Preview
# ------------------------------------------

# ファイル
#   → bat で内容を表示
#
# ディレクトリ
#   → eza でツリー表示
export FZF_CTRL_T_OPTS="
  --preview '
    if [ -d {} ]; then
      eza --tree --level=2 --color=always --icons=always {} | head -100
    else
      bat --style=numbers --color=always --line-range :300 {}
    fi
  '
  --preview-window=right:55%:wrap
"


# ------------------------------------------
# Alt + C Preview
# ------------------------------------------

# 選択中のディレクトリ構造を eza で表示
export FZF_ALT_C_OPTS="
  --preview 'eza --tree --level=2 --color=always --icons=always {} | head -100'
  --preview-window=right:55%
"


# ------------------------------------------
# fzf Tab Completion
# ------------------------------------------

# パス補完でも fd を使用
#
# 例:
#
# nvim **<Tab>
#
# などで fzf によるパス検索を使用できる
_fzf_compgen_path() {
  fd --hidden \
    --exclude .git \
    --exclude node_modules \
    --exclude .venv \
    . "$1"
}

# ディレクトリ補完でも fd を使用
#
# 例:
#
# cd **<Tab>
#
# などでディレクトリのみ検索する
_fzf_compgen_dir() {
  fd --type d --hidden \
    --exclude .git \
    --exclude node_modules \
    --exclude .venv \
    . "$1"
}


# ------------------------------------------
# fzf Shell Integration
# ------------------------------------------

# Ctrl + T
# Ctrl + R
# Alt + C
# **<Tab>
# などを有効化
#
# FZF_CTRL_T_COMMAND / FZF_ALT_C_COMMAND は
# この行より前に設定する
eval "$(fzf --zsh)"


# ==========================================
# History
# ==========================================

HISTFILE="$HOME/.zsh_history"

# メモリ上に保持する履歴数
HISTSIZE=10000

# ファイルに保存する履歴数
SAVEHIST=10000

# 複数ターミナル間で履歴を共有
setopt share_history

# 履歴がいっぱいになった場合は古い重複履歴から削除
setopt hist_expire_dups_first

# 直前と同じコマンドを履歴に重複保存しない
setopt hist_ignore_dups

# 履歴展開したコマンドを即実行せず確認できるようにする
setopt hist_verify


# ==========================================
# History Search
# ==========================================

# 上下矢印キーで
# 現在入力している文字列から始まる履歴を検索
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

# zsh設定ファイルをNeovimで編集
alias edit-zsh="nvim ~/.zshrc"

# zshを再起動して設定を読み込み直す
alias reload-zsh="exec zsh"


# ==========================================
# zsh-syntax-highlighting
# ==========================================

# コマンド入力中の色分け
#
# 他のプラグイン・設定より後ろで読み込む
source ~/.config/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
