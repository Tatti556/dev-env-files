# Git Bash launched from WezTerm may not inherit USER.
if [[ -z ${USER-} ]]; then
  USER=$(id -un)
  export USER
fi


# ==========================================
# PATH
# ==========================================

# Scoop の Node.js と npm で導入したコマンド
export PATH="$HOME/scoop/apps/nodejs/current/bin:$HOME/scoop/apps/nodejs/current:$PATH"

# Scoop shims
# fd / bat / rg / nvim / opencode など
export PATH="$PATH:$HOME/scoop/shims"


# ==========================================
# ble.sh
# ==========================================

# Bash の入力補完・構文ハイライト・autosuggestion を担当する。
#
# attach は .bashrc の最後で行う。
# [[ $- == *i* ]] && source -- "$HOME/.local/share/blesh/ble.sh" --attach=none


# ==========================================
# History
# ==========================================

# 履歴ファイル
HISTFILE="$HOME/.bash_history"

# メモリ上に保持する履歴数
HISTSIZE=10000

# ファイルに保存する履歴数
HISTFILESIZE=10000

# Bash終了時に履歴ファイルを上書きせず追記
shopt -s histappend

# 直前と同じコマンドを重複保存しない
HISTCONTROL=ignoredups

# !xxx などの履歴展開を即実行せず、
# 展開後のコマンドを編集できるようにする
# Zsh の setopt hist_verify 相当
shopt -s histverify


# ------------------------------------------
# 複数ターミナル間で履歴を同期
# ------------------------------------------

# Zsh の share_history に近い動作。
#
# - history -a
#   現在のセッションで追加した履歴を書き込む
#
# - history -n
#   他のセッションが追加した履歴を読み込む
__history_sync() {
  builtin history -a
  builtin history -n
}


# ==========================================
# Editor
# ==========================================

export EDITOR="nvim"
export VISUAL="nvim"


# ==========================================
# Starship
# ==========================================

# Git Bash では Powerlevel10k の代わりに Starship を使用
export STARSHIP_CONFIG="$HOME/.config/starship.toml"

eval "$(starship init bash)"


# ==========================================
# eza
# ==========================================

alias ls='eza --icons --group-directories-first'

# 現在の Bash 設定にあった --header は維持
alias ll='eza -la --icons --group-directories-first --git --header'

alias lt='eza --tree --level=2 --icons'


# ==========================================
# Command Alias
# ==========================================

# Neovim
alias nvim="$HOME/scoop/shims/nvim.exe"
alias vim='nvim'

# OpenCode
alias opencode="$HOME/scoop/shims/opencode.exe"

# Antigravity CLI
alias agy="$HOME/.antigravity-cli/antigravity.exe"


# ==========================================
# Zoxide
# ==========================================

# ディレクトリ移動履歴
#
# z xxx
# zi
eval "$(zoxide init bash)"


# Git Bash / MSYS 向け修正
#
# zoxide に Windows 形式のパスを渡す。
__zoxide_pwd() {
  command cygpath -w "$(builtin pwd -L)"
}


# ==========================================
# fzf
# ==========================================

# ------------------------------------------
# fd を fzf の検索元として使用
# ------------------------------------------

# 通常の fzf / Ctrl + T
#
# --hidden
#   .gitignore / .config などの隠しファイルも検索
#
# --strip-cwd-prefix
#   ./foo/bar → foo/bar
#
# 以下は検索対象から除外
#   .git
#   node_modules
#   .venv
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix \
  --exclude .git \
  --exclude node_modules \
  --exclude .venv"


# Ctrl + T
# ファイル + ディレクトリ検索
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

# 選択中のディレクトリを eza でツリー表示
export FZF_ALT_C_OPTS="
  --preview 'eza --tree --level=2 --color=always --icons=always {} | head -100'
  --preview-window=right:55%
"


# ------------------------------------------
# fzf Tab Completion
# ------------------------------------------

# ファイル・パス補完でも fd を使用
#
# 例:
#
# nvim **<Tab>
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

# 以下を有効化
#
# Ctrl + T
# Ctrl + R
# Alt + C
# **<Tab>
#
# FZF_*_COMMAND や _fzf_compgen_* は
# 必ずこの行より前に定義する。
eval "$(fzf --bash)"


# ==========================================
# History Search
# ==========================================

# 上下矢印キーで
# 「現在入力している文字列から始まる履歴」を検索
#
# 例:
#
# git
# ↑
#
# → 過去の git ... コマンドだけを検索
if [[ ${BLE_VERSION-} ]]; then

  # ble.sh 使用時
  ble-bind -m emacs -f up history-search-backward
  ble-bind -m emacs -f down history-search-forward

else

  # ble.sh を使わない場合の Readline fallback
  bind '"\e[A": history-search-backward'
  bind '"\e[B": history-search-forward'

fi


# ==========================================
# History synchronization hook
# ==========================================

# Starship / zoxide が設定した PROMPT_COMMAND を
# 上書きせずに履歴同期処理を追加する。
if declare -p PROMPT_COMMAND 2>/dev/null | grep -q '^declare -a'; then

  PROMPT_COMMAND+=(__history_sync)

else

  PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }__history_sync"

fi


# ==========================================
# Utility Alias
# ==========================================

# Bash設定をNeovimで編集
alias edit-bash='nvim ~/.bashrc'

# source ~/.bashrc ではなく Bash 自体を再起動
# ble.sh や各種初期化処理の二重実行を避ける
alias reload-bash='exec bash'


# ==========================================
# ble.sh attach
# ==========================================

# 必ずほかの対話シェル設定より後ろで attach
# [[ ! ${BLE_VERSION-} ]] || ble-attach
