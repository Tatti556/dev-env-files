# obsidian.nvim 基本操作ガイド

このガイドは、現在の Neovim 設定で `obsidian-nvim/obsidian.nvim` を使い始めるための入門資料です。

## 1. obsidian.nvim とは

`obsidian.nvim` は、Obsidian Vault 内の Markdown ノートを Neovim から編集・検索・移動するためのプラグインです。

主に次のことができます。

- ノートの新規作成
- ノート名・本文・タグからの検索
- `[[Wikiリンク]]` の補完と移動
- バックリンクの確認
- デイリーノートの作成
- テンプレートの利用
- チェックボックスの切り替え
- 選択した文章からのノート作成

Obsidian のグラフビューや Canvas を Neovim に再現するものではありません。ノートの編集は Neovim、グラフ表示などは Obsidian アプリ、というように併用できます。

## 2. 現在の設定

現在は次のように設定されています。

| 項目 | 設定 |
|---|---|
| Workspace名 | `personal` |
| Vault | `C:/Users/tatti/Documents/Obsidan_DATA/2607_vault` |
| 通常ノートの保存先 | `000_inbox` |
| テンプレートの保存先 | `999_template` |
| デイリーノートの保存先 | `001_DailyNotes` |
| デイリーノートの形式 | `YYYY/YYYY-MM/YYYY-MM-DD.md` |
| デイリーテンプレート | `daily-temp_v2_tasks.md` |
| 検索画面 | Telescope |
| 補完画面 | blink.cmp |
| Obsidian Sync | 無効 |

通常ノートを作ると `000_inbox` に保存されます。たとえば「Neovimメモ」というノートは、おおむね次のような場所に作成されます。

```text
000_inbox/neovimメモ.md
```

## 3. コマンドの入力方法

ノーマルモードで `:` を押し、コマンドを入力して Enter で実行します。

```vim
:Obsidian
```

`Obsidian` の後にスペースを入力して Tab を押すと、利用できるサブコマンドを補完できます。

```vim
:Obsidian <Tab>
```

この環境では新形式のコマンドを使用します。

```vim
:Obsidian new
```

旧形式の `:ObsidianNew` などは使用しません。

## 4. 最初に覚える6つの操作

### 4.1 新しいノートを作る

```vim
:Obsidian new
```

タイトルを指定する場合：

```vim
:Obsidian new Neovimのメモ
```

作成したノートは、現在の設定では `000_inbox` に保存されます。

### 4.2 ノート名から探す

```vim
:Obsidian quick_switch
```

Telescope が開きます。文字を入力してノートを絞り込み、Enter で開きます。

### 4.3 ノート本文を検索する

```vim
:Obsidian search
```

検索語を直接指定することもできます。

```vim
:Obsidian search Telescope
```

- `quick_switch`: ノート名から探す
- `search`: ノート本文から探す

と覚えると分かりやすくなります。

### 4.4 今日のデイリーノートを開く

```vim
:Obsidian today
```

ノートが存在しない場合は、`999_template/daily-temp_v2_tasks.md` を利用して作成されます。

2026年9月22日の場合、保存先は次のようになります。

```text
001_DailyNotes/2026/2026-09/2026-09-22.md
```

昨日と明日のノートも開けます。

```vim
:Obsidian yesterday
:Obsidian tomorrow
```

日数を指定することもできます。

```vim
:Obsidian today -1
:Obsidian today +7
```

デイリーノートの一覧を表示する場合：

```vim
:Obsidian dailies
```

### 4.5 ノート間をリンクする

挿入モードで `[[` に続けてノート名を入力します。

```markdown
[[Neovim
```

2文字程度入力すると、blink.cmp が既存ノートの候補を表示します。

| キー | 動作 |
|---|---|
| `<C-n>` | 次の候補 |
| `<C-p>` | 前の候補 |
| `↑` / `↓` | 候補を移動 |
| `<C-y>` | 選択した候補を確定 |
| `<C-e>` | 補完メニューを閉じる |
| `<C-Space>` | 補完メニューを手動表示 |

候補を確定すると、次のようなリンクになります。

```markdown
[[Neovim設定]]
```

リンク上にカーソルを置いて Enter または `gf` を押すと、リンク先を開けます。

```text
]o    次のリンクへ移動
[o    前のリンクへ移動
```

存在しないノートへのリンクを開いた場合は、新しいノートを作成できます。

### 4.6 バックリンクを確認する

バックリンクとは、現在のノートを参照している別のノートです。

```vim
:Obsidian backlinks
```

Telescope に参照元のノートが表示されます。

## 5. リンクと関連情報を調べる

### 現在のノート内にあるリンクを一覧表示

```vim
:Obsidian links
```

### 現在のノートの目次を表示

```vim
:Obsidian toc
```

### カーソル位置のリンクを開く

```vim
:Obsidian follow_link
```

画面を分割して開く場合：

```vim
:Obsidian follow_link vsplit
:Obsidian follow_link hsplit
```

## 6. タグを使う

Markdown にタグを書きます。

```markdown
#neovim
```

タグを検索する場合：

```vim
:Obsidian tags neovim
```

タグ上にカーソルを置いて Enter を押すことでも、同じタグを持つノートを検索できます。

## 7. テンプレートを使う

テンプレートは `999_template` に保存します。

### 現在のノートへテンプレートを挿入

```vim
:Obsidian template
```

テンプレート一覧から選択すると、カーソル位置へ内容が挿入されます。

### テンプレートから新しいノートを作成

```vim
:Obsidian new_from_template
```

タイトルとテンプレート名を指定することもできます。

```vim
:Obsidian new_from_template 会議メモ meeting.md
```

### テンプレート変数

テンプレートには次のような変数を書けます。

```markdown
# {{title}}

作成日: {{date}}
作成時刻: {{time}}
```

現在の設定では次の形式に置き換わります。

```text
{{date}} → 2026-09-22
{{time}} → 14:30
```

## 8. チェックボックスを使う

Markdown のタスクは次のように書きます。

```markdown
- [ ] 未完了のタスク
```

チェックボックスの行にカーソルを置いて Enter を押すか、次のコマンドを実行します。

```vim
:Obsidian toggle_checkbox
```

チェックボックスの状態が順番に切り替わります。

## 9. 選択した文章からリンクやノートを作る

まずビジュアルモードで文章を選択します。

### 選択部分を既存ノートへのリンクにする

```vim
:Obsidian link
```

### 選択部分から新しいノートとリンクを作る

```vim
:Obsidian link_new
```

### 選択部分を別ノートへ移動する

```vim
:Obsidian extract_note
```

選択部分が新しいノートへ移され、元の場所にはそのノートへのリンクが残ります。

## 10. ノート名を変更する

現在開いているノートをリネームします。

```vim
:Obsidian rename 新しい名前
```

Vault内のバックリンクも更新対象になります。リネーム前後には保存状態を確認してください。

## 11. Obsidianアプリで開く

現在のノートをObsidianアプリ側で開く場合：

```vim
:Obsidian open
```

Neovim内で別ノートを開く `quick_switch` とは用途が異なります。

## 12. Enterキーの動作

ノート内では、カーソル位置によって Enter の動作が変化します。

| カーソル位置 | 動作 |
|---|---|
| Wikiリンク | リンク先を開く |
| タグ | 同じタグを持つノートを検索 |
| チェックボックス | 状態を切り替える |
| 見出し | 折り畳み状態を切り替える |

通常の改行は挿入モードで Enter を押します。

## 13. 困ったときの確認方法

### obsidian.nvim の状態を診断

```vim
:checkhealth obsidian
```

```vim
:Obsidian check
```

### blink.cmp の状態を診断

```vim
:checkhealth blink.cmp
```

### obsidian-ls が接続されているか確認

Vault内のMarkdownを開いた状態で実行します。

```vim
:LspInfo
```

クライアント一覧に `obsidian-ls` があれば接続されています。

### 手元のバージョンに対応したヘルプ

```vim
:Obsidian help
:Obsidian helpgrep
```

## 14. よくある問題

### `[[` を入力しても候補が出ない

次を順番に確認します。

1. 開いているファイルが設定済みVault内にあるか
2. filetypeが `markdown` になっているか
3. `:LspInfo` に `obsidian-ls` があるか
4. `:checkhealth obsidian` にエラーがないか
5. `<C-Space>` で候補を手動表示できるか

filetypeは次のコマンドで確認できます。

```vim
:set filetype?
```

### 検索できない

検索には `ripgrep` を使用します。次のコマンドで診断してください。

```vim
:checkhealth obsidian
```

### コマンドが見つからない

この環境は新形式のコマンドだけを使用します。

```vim
:Obsidian new
```

次の旧形式は使用できません。

```vim
:ObsidianNew
```

## 15. 初心者向けのおすすめ運用

最初は次の流れだけで十分です。

1. `:Obsidian today` で今日のノートを開く
2. 思いついたことをデイリーノートへ書く
3. 独立させたい内容は `:Obsidian new タイトル` でノートにする
4. 関連ノートを `[[ノート名]]` でつなぐ
5. `:Obsidian quick_switch` でノートを探す
6. `:Obsidian search` で本文を検索する
7. `:Obsidian backlinks` で関連ノートを確認する

## 16. コマンド早見表

| 目的 | コマンド |
|---|---|
| 新規ノート | `:Obsidian new [タイトル]` |
| ノート名検索 | `:Obsidian quick_switch` |
| 本文検索 | `:Obsidian search [検索語]` |
| 今日のノート | `:Obsidian today` |
| 昨日のノート | `:Obsidian yesterday` |
| 明日のノート | `:Obsidian tomorrow` |
| デイリー一覧 | `:Obsidian dailies` |
| バックリンク | `:Obsidian backlinks` |
| ノート内リンク一覧 | `:Obsidian links` |
| 目次 | `:Obsidian toc` |
| タグ検索 | `:Obsidian tags [タグ]` |
| テンプレート挿入 | `:Obsidian template` |
| テンプレートから作成 | `:Obsidian new_from_template` |
| チェック切り替え | `:Obsidian toggle_checkbox` |
| ノート名変更 | `:Obsidian rename [新しい名前]` |
| Obsidianアプリで開く | `:Obsidian open` |
| 設定診断 | `:Obsidian check` |
| ヘルプ | `:Obsidian help` |

## 参考資料

- [obsidian.nvim 公式リポジトリ](https://github.com/obsidian-nvim/obsidian.nvim)
- [obsidian.nvim 公式Wiki](https://github.com/obsidian-nvim/obsidian.nvim/wiki)
- [blink.cmp 公式ドキュメント](https://cmp.saghen.dev/)

