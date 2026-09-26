# WezTerm・Neovim 操作ガイド

現在のWezTermのkeybinds.luaとNeovimのinit.luaに基づく説明書です。
Neovimは通常版で、外部プラグインや独自キーマッピングは追加していません。

## 1. 最初に覚えること

- **WezTerm**：タブやターミナルの画面分割を管理するアプリ。
- **PowerShell / Git Bash**：コマンドを入力して実行するシェル。
- **Neovim**：シェルでnvimと入力して起動するテキストエディター。
- Neovimを終了すると、起動元のシェルへ戻ります。

キー表記：
- Ctrl+Shift+T：3つのキーを同時に押す。
- Leader → r：Leaderを押して離し、その後rを押す。
- gg、dd、yy：同じ文字を2回続けて押す。
- 大文字G：Shift+g。Caps LockではなくShiftを使用する。
- :w：ノーマルモードで「:w」と入力し、Enterで実行。

**LeaderはCtrl+Qです。押して離してから2秒以内に次のキーを押します。**
これはWezTerm用のLeaderで、NeovimのLeaderとは別です。

## 2. まずファイルを作って保存する

シェルで、書き込み可能なフォルダーに移動して実行します。

~~~sh
nvim practice.txt
~~~

1. iを押す → 入力モードになる。
2. 文字を入力する。
3. Escを押す → ノーマルモードへ戻る。
4. :w と入力してEnter → 保存。
5. :q と入力してEnter → Neovimを終了。

保存して終了をまとめて行う場合は :wq。
変更を捨てて終了する場合は :q!。未保存の内容が失われるため注意してください。
日本語入力後にコマンドが効かない場合は、IMEを英数入力に戻してください。

## 3. WezTerm：タブとウィンドウ

以下は通常時の操作です。Neovimを起動していてもWezTerm側が処理します。

| キー | 操作 |
|---|---|
| Ctrl+Shift+T | 新しいタブ。現在のローカル構成では既定のPowerShell 7を起動 |
| Ctrl+Shift+W | 現在のタブを閉じる（確認あり） |
| Ctrl+Tab | 次のタブ |
| Ctrl+Shift+Tab | 前のタブ |
| Ctrl+Shift+1〜8 | 1〜8番目のタブ |
| Ctrl+Shift+9 | 最後のタブ |
| Leader → { | 現在のタブを左へ並べ替え |
| Leader → } | 現在のタブを右へ並べ替え |
| Ctrl+Shift+N | 新しいウィンドウ |
| Alt+Enter | 全画面表示を切り替え |
| Ctrl+Shift+P | コマンドパレット |
| Ctrl+Shift+R | WezTerm設定を再読み込み |
| Ctrl と + または = | 文字を大きくする |
| Ctrl と - | 文字を小さくする |
| Ctrl+0 | 文字サイズを設定値に戻す |

右上のボタンで最小化・最大化・閉じるを操作できます。
現在はタブが1つでもタブバーを表示する設定です。
タブを閉じる操作はNeovimの保存操作ではありません。先に :w または :wq を実行してください。

### Git Bashを新しいタブに開く

1. Ctrl+Qを押して離す。
2. 2秒以内にmを押す。
3. メニューでGit Bashを選び、Enter。

PowerShell 7やWindows PowerShellも同じメニューから選べます。
オフライン手動導入で削除したメニュー項目は表示されません。

## 4. WezTerm：ペイン（ターミナルの画面分割）

| キー | 操作 |
|---|---|
| Leader → r | 左右に分割 |
| Leader → d | 上下に分割 |
| Leader → h | 左のペインへ |
| Leader → j | 下のペインへ |
| Leader → k | 上のペインへ |
| Leader → l | 右のペインへ |
| Leader → z | 現在のペインを拡大／元に戻す |
| Leader → x | 現在のペインを閉じる（確認あり） |
| Ctrl+Shift+[ | ペイン選択表示を開く |
| Leader → s | サイズ調整モード |
| Leader → a → h/j/k/l | 一時的なペイン移動モード。待ち時間は1秒、通常は1操作で終了 |

方向キーの対応は次のとおりです。

~~~text
      k（上）
h（左）   l（右）
      j（下）
~~~

サイズ調整モードではh/j/k/lを繰り返し押して調整できます。
EnterまたはEscで終了します。
右側にTABLE: resize_paneと表示されている間は通常の入力モードではありません。

### 実用例：左にNeovim、右にシェル

1. Leader → rで左右に分割。
2. Leader → hで左へ移動してnvimを起動。
3. Leader → lで右へ移動してコマンドを実行。
4. Leader → zで必要なペインを大きく表示。もう一度押すと戻る。

## 5. WezTerm：コピー・貼り付け・検索

| キー | 操作 |
|---|---|
| Ctrl+Shift+C | ターミナルで選択した文字をWindowsクリップボードへコピー |
| Ctrl+Shift+V | Windowsクリップボードから貼り付け |
| Ctrl+Shift+F | ターミナルの表示内容・履歴を検索 |
| Leader → [ | WezTermのコピーモードへ |
| Ctrl+Shift+X | 同じくコピーモードへ |

通常のシェル表示ではマウスドラッグで選択できます。
NeovimではマウスがNeovimへ渡るため、同じ操作でも選択の扱いが異なります。
検索の終了はEsc。ファイル内部の検索は後述のNeovimの / を使用します。

### マウスを使わずターミナル出力をコピー

1. Leader → [。
2. h/j/k/lでコピー開始位置へ移動。
3. vで範囲選択開始。
4. 移動して範囲を広げる。
5. Enterでコピーしてコピーモード終了。

### コピーモード内のキー

この表は**WezTermのコピーモード中だけ**有効です。

| キー | 操作 |
|---|---|
| h/j/k/l | 左/下/上/右へ移動 |
| w / b / e | 次の単語/前の単語/単語末尾 |
| 0 / ^ / $ | 行の左端/最初の空白以外の文字/行末 |
| g / G | 履歴の先頭/末尾 |
| H / M / L | 表示範囲の上/中央/下 |
| Ctrl+B / Ctrl+F | 1ページ上/下 |
| Ctrl+U / Ctrl+D | 半ページ上/下 |
| f → 文字 / t → 文字 | 指定文字へ/その手前へ移動 |
| F → 文字 / T → 文字 | 逆方向へ指定文字移動 |
| ; | 文字移動を繰り返す |
| v | 文字単位で範囲選択 |
| V（Shift+v） | 行単位で範囲選択 |
| Ctrl+V | 矩形選択 |
| o | 選択範囲の反対側の端へ |
| O | 選択範囲の左右の端を切り替え |
| y | コピー。モードは終了しない |
| Enter | コピーして終了 |
| Esc / q / Ctrl+C | コピーモードを終了 |

記号の$、{、}、^等は、その記号を入力するキーを使います。
必要なShiftの組み合わせはJIS/US配列で異なり、記号キーは実機での確認が必要です。

## 6. WezTerm：ワークスペース

ワークスペースは作業単位でタブやペインをまとめる仕組みです。

| キー | 操作 |
|---|---|
| Leader → w | ワークスペース選択 |
| Leader → Shift+w | 名前を入力して作成・切り替え |
| Leader → $ | 現在のワークスペースを改名 |
| Ctrl+Q → Ctrl+Q | 本来のCtrl+Qをシェル/Neovimへ送る |

ワークスペースの自動保存・再起動後の復元プラグインは導入していません。

## 7. Neovim：モードを理解する

| モード | 用途 | 入る操作 |
|---|---|---|
| ノーマル | 移動・削除・コピーなど | Esc |
| インサート | 文字入力 | ノーマルでi |
| ビジュアル | 範囲選択 | ノーマルでv、V、Ctrl+V |
| コマンドライン | 保存・終了・設定確認 | ノーマルで: |

何を押せばよいかわからなくなったら、IMEを英数にしてEscを押します。
ただしWezTermのサイズ調整モードやコピーモードが有効なら、先にそれを終了してください。

## 8. Neovim：開く・保存・終了

シェルから：

~~~sh
nvim
nvim example.lua
nvim "folder with spaces/example.lua"
nvim file1.txt file2.txt
nvim .
~~~

nvim .は標準のディレクトリ閲覧機能を開きます。
選択したファイルはEnterで開きます。ファイルツリー用プラグインは未導入です。

Neovim内で、次を入力してEnter：

| コマンド | 操作 |
|---|---|
| :e example.lua | ファイルを開く |
| :w | 保存 |
| :w newname.txt | 指定した名前へ書き出す |
| :saveas newname.txt | 別名保存し、編集中のファイル名も変更 |
| :q | 現在のNeovimウィンドウを閉じる。最後なら終了 |
| :wq | 保存して現在のウィンドウを閉じる |
| :q! | 未保存変更を破棄して閉じる |
| :wa | すべての変更済みバッファを保存 |
| :qa | すべて閉じる。未保存変更があれば止まる |
| :wqa | すべて保存して終了 |
| :qa! | すべての未保存変更を破棄して終了 |

通常は :wq を使い、!付きは変更を捨てたいときだけ使用します。

## 9. Neovim：移動と編集

以下はノーマルモードのキーです。

| キー | 操作 |
|---|---|
| h/j/k/l、矢印キー | 左/下/上/右 |
| w / b / e | 次の単語/前の単語/単語末尾 |
| 0 / ^ / $ | 行の左端/最初の空白以外の文字/行末 |
| gg / G | ファイルの先頭/末尾 |
| 20G または :20 | 20行目へ |
| Ctrl+U / Ctrl+D | 半画面上/下 |
| Ctrl+B / Ctrl+F | 1画面上/下 |
| i / a | カーソルの前/後から入力 |
| I / A | 行の最初の空白以外の文字の前/行末から入力 |
| o / O | 下/上に新しい行を作り入力 |
| x | カーソル位置の文字を削除 |
| dd | 1行削除 |
| dw | 単語方向に削除 |
| cc | 現在行を変更し入力開始 |
| u | 元に戻す |
| Ctrl+R | やり直す |
| . | 直前の変更を繰り返す |

数字を前につけると回数を指定できます。例：5jで5行下、3ddで3行削除。

## 10. Neovim：選択・コピー・貼り付け

| キー | 操作 |
|---|---|
| v | 文字単位の選択 |
| V | 行単位の選択 |
| Ctrl+V | 矩形選択 |
| 選択してy | コピーしノーマルモードへ |
| yy | 現在の1行をコピー |
| 選択してd | 選択部分を削除 |
| 選択してc | 選択部分を変更し入力開始 |
| p / P | コピーした内容を後/前に貼り付け |
| Esc | 選択を解除 |

**Neovimのy/yyは、現在の設定ではWindowsクリップボードへ自動同期しません。**
Neovim内部のレジスターへコピーされます。

Windowsクリップボードを明示する操作：

| 操作 | キー |
|---|---|
| 現在行をWindowsへコピー | "+yy |
| 選択範囲をWindowsへコピー | 選択後 "+y |
| Windowsから貼り付け | ノーマルモードで "+p |

最初の文字はダブルクォートです。「"」「+」「y」「y」の順に入力します。
これらはNeovimのクリップボード機能が利用可能な場合に動作します。
利用できない場合は :checkhealth vim.provider で確認してください。移植先では未検証です。

Windows側から貼り付ける簡単な方法は、iで入力モードにしてCtrl+Shift+Vです。
ターミナル出力をコピーしたい場合は、WezTermのコピーモードを使います。

## 11. Neovim：検索と置換

| 操作 | 入力 |
|---|---|
| 下方向に検索 | /文字列 → Enter |
| 上方向に検索 | ?文字列 → Enter |
| 次の検索結果 | n |
| 前の検索結果 | N |
| カーソル位置の単語を下方向に検索 | * |
| 検索のハイライトを一時解除 | :noh |
| 現在行で置換 | :s/old/new/g |
| ファイル全体で確認しながら置換 | :%s/old/new/gc |

置換確認でyは置換、nはスキップ、qは中断です。
検索/置換の文字列は正規表現として扱われます。

現在はignorecaseとsmartcaseが有効です。
小文字だけの検索は大文字小文字を区別せず、大文字を含めると区別します。

## 12. Neovim：複数ファイルと分割

Neovimで開いたファイルの編集内容を「バッファ」と呼びます。

| コマンド | 操作 |
|---|---|
| :ls | バッファ一覧 |
| :bnext / :bprevious | 次/前のバッファ |
| :b 2 | 2番のバッファ |
| :split file.txt | Neovim内を上下分割して開く |
| :vsplit file.txt | Neovim内を左右分割して開く |
| :tabnew file.txt | Neovim内にタブページを作る |
| gt / gT | Neovimの次/前のタブページ（ノーマルモード） |

Neovim内の分割移動は **Ctrl+Wを押して離してからh/j/k/l** です。
Ctrl+W → wで次のウィンドウへ移動します。

- WezTermのペイン：別々のシェル/プロセス。Leader → h/j/k/lで移動。
- Neovimの分割：1つのNeovim内の編集領域。Ctrl+W → h/j/k/lで移動。
- WezTermのタブ：Ctrl+Tabで切り替え。
- Neovimのタブ：gt/gTで切り替え。

## 13. 混同しやすい操作

| やりたいこと | 正しい操作 |
|---|---|
| Neovimで文字入力 | i。起動直後はノーマルモード |
| Neovimを保存 | Esc → :w → Enter |
| Neovimのやり直し | Ctrl+R |
| WezTerm設定再読み込み | Ctrl+Shift+R |
| ファイルを検索 | Neovimで / |
| ターミナルの履歴を検索 | Ctrl+Shift+F |
| WezTermを左右分割 | Leader → r |
| Neovimを左右分割 | :vsplit |
| Neovimだけ終了 | :q または :wq |
| タブごと閉じる | Ctrl+Shift+W（保存の代わりにはならない） |

WezTermのキーが先に処理されるため、Ctrl+Shift+VやCtrl+Shift+WはNeovimの操作ではありません。
現在のWezTermはデフォルトキーバインドを無効にして独自定義を使っています。
ネット上の標準ショートカットがそのまま使えるとは限りません。

## 14. 設定ファイルとヘルプ

現在のPC：

| ファイル | 用途 |
|---|---|
| C:/Users/tatti/.config/wezterm/wezterm.lua | 外観・シェル・Leader |
| C:/Users/tatti/.config/wezterm/keybinds.lua | WezTermのキー |
| C:/Users/tatti/AppData/Local/nvim/init.lua | Neovimの基本設定 |

現在のPCでWezTerm設定を開く（PowerShell/Git Bash共通）：

~~~sh
nvim C:/Users/tatti/.config/wezterm/wezterm.lua
~~~

Neovimで現在読み込んだ設定を開く：

~~~vim
:edit $MYVIMRC
~~~

Neovimの設定変更は、初心者向けには保存後にNeovimを再起動すると確認しやすくなります。
WezTermは保存時に自動再読み込みします。必要ならCtrl+Shift+R。

オフラインパッケージでは、必ずStart-WezTerm.cmdから起動します。
設定はパッケージのconfig/weztermとconfig/nvimにあります。

PowerShellからパッケージのWezTerm設定を開く：

~~~powershell
nvim "$env:OFFLINE_DEV_ROOT/config/wezterm/wezterm.lua"
~~~

オフラインでも使えるNeovimのヘルプ：

| コマンド | 内容 |
|---|---|
| :Tutor | 初心者向け操作練習 |
| :help | ヘルプの入口 |
| :help motion | 移動 |
| :help usr_02.txt | 基本操作 |
| :help clipboard | クリップボード |
| :checkhealth | 環境診断 |

行番号、マウス操作、検索設定、透過背景を設定済みです。
ファイルツリー、IDE補完、LSP等の外部プラグインは未導入です。

## 15. この説明書の確認範囲

WezTermのキー表は現在のkeybinds.luaと照合し、Neovimの設定はinit.luaを確認しました。
Neovimの操作は通常版の標準操作です。
全キーの手動操作、各キーボード配列、移植先でのクリップボードは未検証です。
この説明書の作成に伴う設定変更はありません。