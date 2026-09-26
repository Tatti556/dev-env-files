# Windows 11：管理者権限なしで MSYS2 + Zsh を WezTerm に追加する

> [!summary] 完成形
> WezTerm の既存シェルを残し、起動メニューから **MSYS2 UCRT64 の Zsh** を選べるようにする。Powerlevel10k、補完、eza、fzf、zoxide を設定し、既存の Scoop 版ツールを必要に応じて利用する。  
> fzf の検索元には Scoop 版 `fd` を使用し、`.git`・`node_modules`・`.venv` を除外する。`Ctrl+T` では `bat` / `eza` によるプレビュー、`Alt+C` ではディレクトリのツリープレビューを表示する。WSL と tmux は使わない。

## 0. 前提

- Windows 11、WezTerm 導入済み。インストール先は自分が書き込める `%USERPROFILE%\msys64` とする。
- 会社のセキュリティ設定でインストーラーの起動、GitHub への接続、pacman / Scoop の通信が制限される場合は、その制限に従う。管理者権限なしでの実施は、**ユーザーフォルダへの書き込みが許されている場合**に限る。
- 以下のコマンドは、特記した箇所以外 **MSYS2 UCRT64 のタブ**で実行する。
- `$HOME` は各 PC のユーザー名に置き換わるため、例示された `tatti` などの名前を転記しない。
- Scoop は Windows 側に既に導入済みであることを前提とする。Scoop の導入自体は本手順の対象外とする。

---

## 1. MSYS2 を入れて更新する

1. [MSYS2 公式サイト](https://www.msys2.org/)からインストーラーを取得する。
2. インストール先を `C:\Users\＜会社PCのユーザー名＞\msys64` にする。
3. インストーラーが終了したら **MSYS2 UCRT64** を開く。
4. 更新する。更新途中でターミナルを閉じるよう指示された場合は閉じ、UCRT64 を開き直して同じコマンドを再実行する。

```bash
pacman -Syu
```

---

## 2. Windows のユーザーフォルダをホームにする

最初は `~` が MSYS2 配下の `/home/ユーザー名` になり得る。Windows と同じホームを使いたい場合は、この段階で `/etc/nsswitch.conf` を編集する。

```bash
notepad.exe "$(cygpath -w /etc/nsswitch.conf)"
```

既存の `db_home:` 行を探し、次の **1 行だけが有効**になるようにして保存する。

```text
db_home: windows
```

UCRT64 のウィンドウをすべて閉じて開き直し、確認する。

```bash
echo "$HOME"
cygpath -w "$HOME"
echo "$MSYSTEM"
```

期待値：

```text
/c/Users/＜ユーザー名＞
C:\Users\＜ユーザー名＞
UCRT64
```

> [!note]
> `cygpath` は MSYS2 / Git Bash 側のコマンドである。PowerShell では実行しない。

---

## 3. 必要なコマンドを導入する

### 3.1 MSYS2 側の基本ツール

**MSYS2 UCRT64** で実行する。

```bash
pacman -S --needed \
  git \
  zsh \
  mingw-w64-ucrt-x86_64-eza \
  mingw-w64-ucrt-x86_64-fzf \
  mingw-w64-ucrt-x86_64-zoxide
```

確認：

```bash
git --version
zsh --version
eza --version
fzf --version
zoxide --version
```

UCRT64 のプログラムは `mingw-w64-ucrt-x86_64-` で始まる。Git Bash や Scoop 側に同じツールがあっても、上記のものは MSYS2 版を使用する。

### 3.2 Windows / Scoop 側に `fd` を導入する

`fd` は fzf の検索候補を高速に生成するために使用する。

**PowerShell** で確認する。

```powershell
fd --version
```

既にバージョンが表示される場合は追加作業不要。

未導入の場合：

```powershell
scoop install fd
```

必要に応じて、プレビュー・検索用の `bat` / `ripgrep` も Scoop で導入できる。

```powershell
scoop install bat
scoop install ripgrep
```

今回の構成では以下の役割分担とする。

| コマンド | 主な用途 | 入手元 |
| --- | --- | --- |
| `fzf` | fuzzy finder 本体 | MSYS2 |
| `eza` | ディレクトリのツリー表示 | MSYS2 |
| `zoxide` | 移動履歴ベースのディレクトリ移動 | MSYS2 |
| `fd` | fzf に渡すファイル・ディレクトリ候補の生成 | Scoop |
| `bat` | fzf で選択中のファイル内容をプレビュー | Scoop |
| `rg` | ファイル内容の高速検索 | Scoop |

---

## 4. WezTerm に Zsh を追加する

`wezterm.lua` の **`return config` より前**に追加する。既存の `default_prog` は変更しない。

既に `config.launch_menu` がある場合も、この形なら末尾に追加できる。

```lua
config.launch_menu = config.launch_menu or {}

table.insert(config.launch_menu, {
  label = "MSYS2 Zsh",
  args = {
    "cmd.exe", "/c",
    os.getenv("USERPROFILE") .. "\\msys64\\msys2_shell.cmd",
    "-defterm", "-here", "-no-start", "-ucrt64", "-shell", "zsh",
  },
})
```

WezTerm の起動メニューから **MSYS2 Zsh** を開き、

```zsh
echo "$MSYSTEM"
```

が

```text
UCRT64
```

になることを確認する。

Zsh の初回設定画面が出ても、まず `0` で抜けて構わない。

Windows ホームに `.zshrc` がなければ作成する。

```zsh
touch ~/.zshrc
```

---

## 5. テーマとプラグインを入れる

**MSYS2 Zsh タブ**で実行する。

保存先は Windows ホーム内の `~/.config/.zsh` とする。

```zsh
mkdir -p ~/.config/.zsh

git clone --depth=1 \
  https://github.com/romkatv/powerlevel10k.git \
  ~/.config/.zsh/powerlevel10k

git clone --depth=1 \
  https://github.com/zsh-users/zsh-autosuggestions.git \
  ~/.config/.zsh/zsh-autosuggestions

git clone --depth=1 \
  https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ~/.config/.zsh/zsh-syntax-highlighting
```

既に存在するフォルダへの `git clone` は失敗する。

その場合は、先に内容を確認する。

```zsh
ls ~/.config/.zsh
```

---

## 6. Scoop のコマンドを Zsh から使えるようにする

Scoop の shim は通常、

```text
C:\Users\＜ユーザー名＞\scoop\shims
```

にある。

MSYS2 Zsh では次の形で PATH に追加できる。

```zsh
export PATH="$PATH:$HOME/scoop/shims"
```

これにより Scoop で導入した、

```text
fd
bat
rg
nvim
opencode
```

などを Zsh から呼び出せる。

### 動作確認

```zsh
command -v fd
command -v bat
command -v rg

fd --version
bat --version
rg --version
```

例えば `command -v fd` が、

```text
/c/Users/＜ユーザー名＞/scoop/shims/fd
```

などを返し、`fd --version` が表示されればよい。

> [!note]
> `export PATH="$PATH:$HOME/scoop/shims"` は末尾に追加しているため、同名の MSYS2 コマンドが存在する場合は MSYS2 側が優先される。今回 `fd` は MSYS2 側に入れず、Scoop 版を利用する。

---

## 7. `~/.zshrc` を設定する

編集する。

```zsh
notepad.exe "$(cygpath -w "$HOME/.zshrc")"
```

Scoop 版 Node.js や Neovim がない PC では、それぞれの PATH / alias を省略する。

以下は、今回の構成をまとめた推奨設定例である。

```zsh
# ==========================================
# PATH
# ==========================================

# Scoop の Node.js と npm コマンドを使う PC のみ
export PATH="$HOME/scoop/apps/nodejs/current/bin:$HOME/scoop/apps/nodejs/current:$PATH"

# Scoop shims
# fd / bat / rg / nvim などの Windows 側コマンドを Zsh から利用する
export PATH="$PATH:$HOME/scoop/shims"


# ==========================================
# Completion
# ==========================================

autoload -Uz compinit
compinit

# Tab補完候補をメニュー形式で選択
zstyle ':completion:*' menu select


# ==========================================
# zsh-autosuggestions
# ==========================================

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

# Scoop 版 Neovim を使う PC のみ
alias nvim="$HOME/scoop/shims/nvim.exe"
alias vim='nvim'

# Scoop 版 OpenCode を使う PC のみ
alias opencode="$HOME/scoop/shims/opencode.exe"

# ~/.antigravity-cli/antigravity.exe を使う PC のみ
alias agy="$HOME/.antigravity-cli/antigravity.exe"


# ==========================================
# Powerlevel10k
# ==========================================

source ~/.config/.zsh/powerlevel10k/powerlevel10k.zsh-theme

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh


# ==========================================
# Zoxide
# ==========================================

eval "$(zoxide init zsh)"

# zoxide 0.10.0 の MSYS2 向け回避策
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
#   .zshrc / .config などの隠しファイルも対象にする
#
# --strip-cwd-prefix
#   ./foo/bar の先頭 ./ を取り除く
#
# --exclude
#   大量の候補を生むディレクトリを除外する
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix \
  --exclude .git \
  --exclude node_modules \
  --exclude .venv"

# Ctrl + T：ファイルとディレクトリを検索
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Alt + C：ディレクトリだけを検索
export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix \
  --exclude .git \
  --exclude node_modules \
  --exclude .venv"


# ------------------------------------------
# Ctrl + T Preview
# ------------------------------------------

# ファイルなら bat、ディレクトリなら eza でプレビュー
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

export FZF_ALT_C_OPTS="
  --preview 'eza --tree --level=2 --color=always --icons=always {} | head -100'
  --preview-window=right:55%
"


# ------------------------------------------
# fzf Tab Completion
# ------------------------------------------

# ファイル / パス補完でも fd を使用
_fzf_compgen_path() {
  fd --hidden \
    --exclude .git \
    --exclude node_modules \
    --exclude .venv \
    . "$1"
}

# ディレクトリ補完でも fd を使用
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

# Ctrl + T / Ctrl + R / Alt + C / **<Tab> を有効化
#
# FZF_CTRL_T_COMMAND / FZF_ALT_C_COMMAND は
# この行より前に設定しておく
eval "$(fzf --zsh)"


# ==========================================
# History
# ==========================================

HISTFILE="$HOME/.zsh_history"

# メモリ上の履歴
HISTSIZE=10000

# ファイルに保存する履歴
SAVEHIST=10000

# 複数ターミナル間で履歴を共有
setopt share_history

# 履歴がいっぱいになった場合は古い重複履歴から削除
setopt hist_expire_dups_first

# 直前と同じコマンドを重複保存しない
setopt hist_ignore_dups

# 履歴展開後に即実行せず編集できるようにする
setopt hist_verify


# ==========================================
# History Search
# ==========================================

# 現在入力している文字列から始まる履歴を上下矢印で検索
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward


# ==========================================
# Editor
# ==========================================

export EDITOR="nvim"
export VISUAL="nvim"


# ==========================================
# Utility Alias
# ==========================================

alias edit-zsh="nvim ~/.zshrc"

# source ~/.zshrc ではなく Zsh 自体を再起動する
alias reload-zsh="exec zsh"


# ==========================================
# zsh-syntax-highlighting
# ==========================================

# 必ずほかのプラグイン・設定より後ろで読み込む
source ~/.config/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
```

### fzf 設定のポイント

fzf 周りの処理は次の関係になる。

```text
fd
 │
 ├─ fzf
 │    └─ 通常の fuzzy search
 │
 ├─ Ctrl + T
 │    ├─ ファイル + ディレクトリ検索
 │    └─ Preview
 │         ├─ file → bat
 │         └─ dir  → eza
 │
 ├─ Alt + C
 │    ├─ ディレクトリのみ検索
 │    └─ eza でツリープレビュー
 │
 └─ ** + Tab
      └─ fd → fzf 補完
```

検索対象：

```text
通常のファイル
通常のディレクトリ
.zshrc
.config/
.gitignore
```

明示的に除外：

```text
.git/
node_modules/
.venv/
```

> [!important]
> `FZF_CTRL_T_COMMAND` と `FZF_ALT_C_COMMAND` は `eval "$(fzf --zsh)"` より前に設定する。fzf の shell integration 読み込み後に設定しても、`Ctrl+T` / `Alt+C` 側に反映されない。

---

## 8. Powerlevel10k を初期設定する

`.zshrc` を保存したら Zsh を再起動する。

```zsh
exec zsh
```

Powerlevel10k の対話設定が始まらない場合：

```zsh
p10k configure
```

設定画面で記号が四角になる場合は、WezTerm のフォントを Nerd Font 対応フォントにする。

> [!warning] `p10k configure` の後
> ウィザードが `~/.zshrc` の先頭に **instant prompt** を追記する場合がある。それは残す。  
> 一方、`~/.p10k.zsh` の `source` 行が二重になった場合は 1 行だけにする。  
> `zsh-syntax-highlighting` の `source` 行は、最終的に設定ファイルの最後へ置く。

---

## 9. 会社 PC の既存コマンドを引き継ぐ

PC によって導入先が違うため、必要なら **Git Bash 側**で場所を調べる。

```bash
command -v nvim
command -v node
command -v codex
command -v opencode
command -v agy
command -v fd
command -v bat
command -v rg
```

確認の考え方：

- `nvim` が `~/scoop/shims/nvim` に相当するなら、上記の `alias nvim=...` を使用できる。
- `codex` / `opencode` が `~/scoop/apps/nodejs/current/bin/` にあれば、Node.js 用の PATH 追加で利用できる。
- **Scoop 版 OpenCode** を指定する場合は、Zsh で次を先に確認する。

```zsh
"$HOME/scoop/shims/opencode.exe" --version
```

- **Antigravity CLI** は次で確認する。

```zsh
"$HOME/.antigravity-cli/antigravity.exe" --version
```

- Scoop 版 `fd` / `bat` / `rg` は次で確認する。

```zsh
"$HOME/scoop/shims/fd.exe" --version
"$HOME/scoop/shims/bat.exe" --version
"$HOME/scoop/shims/rg.exe" --version
```

これらが動けば、

```zsh
export PATH="$PATH:$HOME/scoop/shims"
```

で Zsh から呼び出せる。

Git Bash の `~/.bashrc` は Zsh には自動で引き継がれない。

### Zsh 側で最終確認

```zsh
command -v nvim node codex opencode
command -v fd bat rg

nvim --version
node --version
codex --version
opencode --version
agy --version

fd --version
bat --version
rg --version
```

導入していないコマンドの確認行は飛ばしてよい。

---

## 10. fzf + fd の動作確認

### 10.1 fd 単体

```zsh
fd --hidden \
  --exclude .git \
  --exclude node_modules \
  --exclude .venv
```

次のような隠しファイルは検索対象になる。

```text
.zshrc
.gitignore
.config/
```

一方、次は表示されないことを確認する。

```text
.git/
node_modules/
.venv/
```

### 10.2 `Ctrl + T`

ターミナルで、

```text
Ctrl + T
```

を押す。

期待する動作：

- `fd` がファイル・ディレクトリ候補を生成する。
- `.git` / `node_modules` / `.venv` は除外される。
- ファイル選択時は右側に `bat` の内容プレビューが表示される。
- ディレクトリ選択時は右側に `eza --tree` が表示される。
- `Enter` で選択すると、パスが現在のコマンドラインへ挿入される。

例：

```zsh
bat 
```

まで入力して `Ctrl+T` → ファイルを選択すると、

```zsh
bat path/to/file.md
```

のように入力欄へ挿入される。

### 10.3 `Alt + C`

```text
Alt + C
```

を押す。

期待する動作：

- ディレクトリだけが一覧表示される。
- `.git` / `node_modules` / `.venv` は除外される。
- 右側に `eza` のツリーが表示される。
- `Enter` すると選択したディレクトリへ移動する。

### 10.4 `Ctrl + R`

```text
Ctrl + R
```

で fzf の履歴検索を開く。

上下矢印の prefix 履歴検索とは別機能であり、長いコマンドや一部しか覚えていないコマンドを曖昧検索するときに使う。

### 10.5 `** + Tab`

例：

```zsh
nvim **<Tab>
```

ファイル・パス候補を fzf で検索する。

ディレクトリの場合：

```zsh
cd **<Tab>
```

ディレクトリ候補を fzf で検索する。

---

## 11. 日常の使い方

| 操作 | 入力・キー | 何が起きるか |
| --- | --- | --- |
| ファイルを読む | `bat ~/.zshrc` | 色付き・行番号付きで表示 |
| ファイルの内容を検索 | `rg -n 'zoxide' ~/.zshrc` | 一致した行と行番号を表示 |
| フォルダ以下を検索 | `rg -n 'TODO' ~/Documents` | Documents 以下の一致箇所を表示 |
| ファイル名を検索 | `fd キーワード` | 高速にファイル・ディレクトリを検索 |
| 履歴を曖昧検索 | `Ctrl+R` | fzf で過去のコマンドを検索 |
| 入力文字から履歴検索 | 文字を入力して `↑` / `↓` | 入力文字から始まる履歴を検索 |
| ファイル名を入力欄へ挿入 | `Ctrl+T` | fd + fzf で選択し、bat/eza でプレビュー |
| フォルダを選んで移動 | `Alt+C` | fd + fzf でディレクトリを選択 |
| fzf パス補完 | `**` → `Tab` | fd で候補生成し fzf で選択 |
| 訪問履歴から移動 | `z キーワード` / `zi` | zoxide に登録されたフォルダへ移動 |
| Zsh 設定を編集 | `edit-zsh` | `.zshrc` を Neovim で開く |
| Zsh を再起動 | `reload-zsh` | `exec zsh` を実行 |
| OpenCode を起動 | `opencode` | Scoop 版 OpenCode を起動（alias 設定時） |
| Antigravity CLI を起動 | `agy` | `antigravity.exe` を起動（alias 設定時） |

### `Alt+C` と `z` / `zi` の使い分け

| 操作 | 向いている用途 |
| --- | --- |
| `Alt+C` | ファイルシステムを見ながら目的のディレクトリを探す |
| `z キーワード` | 過去によく訪問した場所へ素早く移動する |
| `zi` | zoxide の移動履歴を fzf で絞り込む |

両方を併用してよい。

---

## 12. トラブルシュート

### `fd: command not found`

まず PowerShell で確認する。

```powershell
fd --version
```

Scoop 版が存在するのに Zsh から見えない場合：

```zsh
echo "$PATH"
ls "$HOME/scoop/shims"
```

`.zshrc` に次があるか確認する。

```zsh
export PATH="$PATH:$HOME/scoop/shims"
```

反映：

```zsh
exec zsh
```

### `Ctrl+T` で fd の設定が反映されない

`FZF_CTRL_T_COMMAND` が、

```zsh
eval "$(fzf --zsh)"
```

より前にあるか確認する。

正しい順序：

```zsh
export FZF_CTRL_T_COMMAND="..."
export FZF_ALT_C_COMMAND="..."

eval "$(fzf --zsh)"
```

### プレビューで `bat: command not found`

```zsh
command -v bat
bat --version
```

Scoop の shims が PATH に入っているか確認する。

### `Alt+C` が動かない

WezTerm 側で `Alt+C` を別のキーバインドに割り当てていると、Zsh / fzf までキー入力が届かない場合がある。

まず `.zshrc` を再読み込みする。

```zsh
exec zsh
```

それでも動かない場合は WezTerm のキーバインド設定を確認する。

---

## 最終確認

```zsh
echo "$HOME"
echo "$MSYSTEM"

type z zi

command -v fd fzf bat eza zoxide
fd --version
fzf --version
bat --version
eza --version
zoxide --version

ls
```

期待する状態：

```text
HOME     → Windows のユーザーフォルダ
MSYSTEM  → UCRT64
fd       → Scoop 版
fzf      → MSYS2 版
bat      → Scoop 版
eza      → MSYS2 版
zoxide   → MSYS2 版
```

最後に以下を実操作で確認する。

```text
Ctrl+T
Alt+C
Ctrl+R
```

`z` / `zi` は zoxide の移動履歴が蓄積されるほど使いやすくなる。

Git Bash の `.bashrc` と Zsh の `.zshrc` は別ファイルなので、Bash 側の標準設定は維持される。

---

## 参考資料

- [MSYS2 公式：インストール](https://www.msys2.org/)
- [MSYS2 公式：UCRT64 と PATH](https://www.msys2.org/docs/environments/)
- [MSYS2 公式：パッケージ検索](https://packages.msys2.org/)
- [WezTerm 公式：起動メニュー](https://wezterm.org/config/launch.html)
- [Powerlevel10k 公式：手動導入と設定](https://github.com/romkatv/powerlevel10k)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-syntax-highlighting 公式：読み込み順](https://github.com/zsh-users/zsh-syntax-highlighting)
- [zoxide 公式](https://github.com/ajeetdsouza/zoxide)
- [fzf 公式：Zsh 連携とキー操作](https://github.com/junegunn/fzf)
- [fd 公式](https://github.com/sharkdp/fd)
- [bat 公式](https://github.com/sharkdp/bat)
