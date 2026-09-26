---
title: "Scoopのapps・shimsと手動CLI管理：OpenCodeの配置例"
tags: [Windows, Scoop, CLI, PATH, OpenCode]
---

# Scoopの`apps`・`shims`と手動CLI管理

> [!summary] 結論
> `scoop\apps`は**Scoopが管理するアプリ本体**、`scoop\shims`は**コマンドを本体につなぐ起動用ファイル**の置き場所である。GitHubから手動取得したCLIはScoopのフォルダに混ぜず、`%USERPROFILE%\tools`などで管理する。

## 1. フォルダと環境変数の基本

| 項目 | 意味 | 例 |
|---|---|---|
| `scoop\apps` | Scoopでインストールしたアプリ本体。通常、バージョン別に保存する | `C:\Users\tatti\scoop\apps\fzf\current` |
| `scoop\shims` | `fzf`などのコマンドを本体へつなぐ入口。Scoopが作成する | `C:\Users\tatti\scoop\shims\fzf.exe`（例） |
| `current` | 使用中バージョンを指すディレクトリリンク | `apps\fzf\current` |
| `PATH` | コマンド入力時に実行ファイルを探す**フォルダの一覧** | `C:\Users\tatti\scoop\shims` |
| `%USERPROFILE%` | Windowsで現在ログイン中のユーザーのプロファイルフォルダを指す環境変数 | `C:\Users\tatti` |

例えば、`%USERPROFILE%\tools\bin`は、ユーザー名が`tatti`なら`C:\Users\tatti\tools\bin`を表す。**`%USERPROFILE%`は主にcmdや`.cmd`ファイルで使う記法**である。

| 使用場所 | ユーザーフォルダを参照する記法 |
|---|---|
| コマンドプロンプト・`.cmd` | `%USERPROFILE%` |
| PowerShell | `$env:USERPROFILE`（`$HOME`も通常は同じ場所） |
| Git Bash / zsh | `$HOME`（通常は`/c/Users/tatti`などのUnix風パス。設定により異なる） |

```text
ターミナルで fzf と入力
  → PATHから scoop\shims 内のshimを発見
  → shimが scoop\apps\fzf\current 内のアプリを起動
```

> [!note]
> `scoop\apps`と`scoop\shims`はScoopに管理させる。手動でダウンロードした実行ファイルを、これらのフォルダに直接追加しない。

## 2. 手動導入するCLIのおすすめ配置

手動導入するCLIが複数になっても、**PATHへの登録は共通の`tools\bin`だけ**にする方法が管理しやすい。

```text
C:\Users\tatti\tools\
├─ apps\
│  └─ opencode\
│     └─ opencode.exe       ← GitHubから取得・展開した本体（例）
└─ bin\
   └─ opencode-manual.cmd   ← 手動版を起動するラッパー
```

`bin`には起動用の小さなファイルだけを置き、実行ファイル本体や同梱DLLは`apps\opencode`に置く。バージョンを複数保存したくなった場合にだけ、`apps\opencode\<バージョン>\`という階層を追加すればよい。

## 3. 例：GitHubから手動取得した`opencode.exe`を起動する

以下は**Windows向け配布物を展開すると`opencode.exe`が得られる場合の配置例**である。実際の配布形式・ファイル名はリリースごとに確認すること。

### 手順① 本体を配置する

1. OpenCodeの**公式GitHubリポジトリのReleases**から、自分のWindows・CPUに対応する配布物を入手する。ZIP形式なら展開し、同梱ファイルを確認する。
2. `C:\Users\tatti\tools\apps\opencode\`を作成し、`opencode.exe`と実行に必要な同梱ファイルを配置する。配布元が公開するハッシュや署名があれば確認する。
3. まずPowerShellで本体を直接起動し、動作を確認する。

```powershell
& "$env:USERPROFILE\tools\apps\opencode\opencode.exe" --version
```

### 手順② ラッパーを作成する

`C:\Users\tatti\tools\bin\opencode-manual.cmd`をテキストエディタで作成し、以下を保存する。

```bat
@echo off
"%USERPROFILE%\tools\apps\opencode\opencode.exe" %*
```

- 1行目：実行したコマンド自体を画面に表示しない。
- 2行目：実行ファイル本体を起動する。`%*`は`--version`などの**引数をそのまま転送**する。
- この例はユーザープロファイルの場所が標準的な`C:\Users\tatti`以外でも、そのユーザーの`tools`にある本体を参照できる。

> [!important] なぜ`opencode-manual.cmd`という名前なのか
> すでにScoop等で`opencode`をインストールしている場合、`opencode.cmd`を追加すると同名コマンドが競合する。**既存環境を壊さないため、まずは`opencode-manual`で手動版を区別する。** 手動版だけを利用することに決めた後でラッパー名を`opencode.cmd`に変更してもよい。

### 手順③ `tools\bin`をPATHに追加する

Windowsの「スタート」から**環境変数を編集**を検索 → **ユーザー環境変数**の`Path` → **編集** → **新規**から次を追加する。

```text
C:\Users\tatti\tools\bin
```

追加後、**新しいターミナルを開く**。管理者権限や、アプリごとの個別PATH登録は通常不要である。`%USERPROFILE%`表記をPATHに手入力する代わりに、ここでは展開済みの実際のフルパスを登録する。

### 手順④ 起動確認と競合チェック

PowerShellの場合：

```powershell
Get-Command opencode-manual -All    # ラッパーの場所を確認
opencode-manual --version           # 手動版が起動するか確認
Get-Command opencode -All           # 既存の同名コマンドがあるか確認
```

Git Bash / zshの場合：

```bash
type -a opencode-manual
opencode-manual --version
```

`opencode-manual`が見つからない場合は、**新しいターミナルを開いたか、PATHに`tools\bin`が入っているか、ファイル名が`opencode-manual.cmd`になっているか**を確認する。シェルによって`.cmd`の検索・起動方法が異なる場合は、PowerShellでの動作を先に確認する。

## 4. 更新・削除の考え方

| 管理対象 | 更新方法 | 削除方法 |
|---|---|---|
| Scoop版 | `scoop update <アプリ名>` | `scoop uninstall <アプリ名>` |
| 手動版 | 公式配布物を取得し、動作確認後に`apps\opencode`内の本体を入れ替える | 本体と専用ラッパーを削除する |

手動版を削除しても、**他のCLIが`tools\bin`を使っていればPATHの登録は残す**。また、アプリ本体とは別の設定・データフォルダは、必要なデータを確認してから削除する。会社PCでは、組織のソフトウェア導入・実行ポリシーに従う。

**使い分け：** Scoopで問題なく管理できるCLIはScoopを使い、公式配布物を直接使う必要があるCLIのみ`tools`で手動管理する。既存の`opencode`が動いているなら、起動元を確認する前に移動・上書きしない。
