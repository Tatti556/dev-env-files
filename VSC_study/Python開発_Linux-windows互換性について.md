---
created: 2026-08-16 06:51
type: spec
status: active
area: tech
topic: python
tags:
  - python
  - uv
  - windows
  - kubuntu
  - git
aliases:
  - Python開発のLinux・Windows互換性
  - WindowsとKubuntuで同じPython環境を作る方法
  - uvを使ったPython開発環境の共有
author: T.I.
source:
  - https://docs.astral.sh/uv/getting-started/installation/
  - https://docs.astral.sh/uv/guides/projects/
  - https://docs.astral.sh/uv/concepts/python-versions/
  - https://docs.astral.sh/uv/concepts/projects/dependencies/
  - https://docs.astral.sh/uv/concepts/projects/layout/
  - https://docs.astral.sh/uv/concepts/projects/sync/
  - https://docs.python.org/3/library/pathlib.html
  - https://docs.python.org/3/library/tkinter.html
  - https://docs.python.org/3/library/subprocess.html
  - https://doc.qt.io/qtforpython-6/
  - https://doc.qt.io/qtforpython-6/deployment/index.html
  - https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository
  - https://pyinstaller.org/en/stable/usage.html
---

# Python開発におけるLinux・Windows互換性

## 結論

- **Windows 11を主な動作対象**とし、Kubuntuでも同じソースコードを実行・テストする。
- Python本体、仮想環境、ライブラリを`uv`で管理する。
- ソースコード、`pyproject.toml`、`uv.lock`、`.python-version`をGitHubで共有する。
- `.venv`は各パソコンで個別に作成し、Gitには登録しない。
- ファイル選択を伴うGUIアプリでは、画面処理とファイル処理を分離する。
- 小規模な個人用ツールは`tkinter`、画面の作り込みや将来の拡張を重視する場合は`PySide6`を候補とする。
- プログラム内では、OS固有のパスやコマンドを直接書かず、`pathlib`、環境変数、`sys.executable`などを使う。

> [!abstract] 推奨する全体構成
> `GitHubリポジトリ`を共有場所とし、Windows 11とKubuntuにそれぞれ同じリポジトリをcloneする。各PCでは`uv sync`を実行して、`uv.lock`からそのOSに合った`.venv`を再構築する。

## 判断理由

### uvを環境管理の中心にする

`uv`は、次の作業をまとめて扱える。

- Pythonバージョンのインストール・選択
- プロジェクト用の仮想環境の作成
- ライブラリの追加・削除
- 依存関係の解決と固定
- プロジェクト環境でのPython実行

従来の`venv`、`pip`、`requirements.txt`を個別に操作する方法より、WindowsとLinuxで同じ運用手順を作りやすい。

### uv.lockでライブラリのバージョンを揃える

`pyproject.toml`は「このプロジェクトが必要とするライブラリ」を定義する。`uv.lock`は、依存ライブラリを含む実際の解決結果を記録する。

`uv.lock`はOSやPythonバージョンごとの条件も扱えるため、同じファイルからWindows用・Linux用の環境を作りやすい。ただし、インストールされるバイナリやOS依存処理まで同一になるわけではない。

## ファイル構成

```text
my_app/
├── app.py
├── gui.py
├── processor.py
├── tests/
│   └── test_processor.py
├── pyproject.toml
├── uv.lock
├── .python-version
├── README.md
├── .gitignore
├── .gitattributes
└── .env.example
```

### Gitで共有するファイル

- Pythonソースコード
- テストコード
- `pyproject.toml`
- `uv.lock`
- `.python-version`
- `README.md`
- `.gitignore`、`.gitattributes`

### Gitで共有しないファイル

- `.venv/`
- `.env`
- APIキー、パスワード、個人データ
- `__pycache__/`
- `build/`、`dist/`

`.venv`はOSやPython本体に依存するため、2台間でコピーしない。`uv sync`で各PCに作り直す。

## 初回セットアップ

### 1. 両方のPCにuvをインストールする

**Kubuntu**

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

インストール後、新しいターミナルを開いて確認する。

```bash
uv --version
```

**Windows 11**

PowerShellで実行する。

```powershell
winget install --id=astral-sh.uv -e
```

新しいPowerShellを開いて確認する。

```powershell
uv --version
```

### 2. 使用するPythonバージョンを決める

例としてPython 3.13系を使用する。実際のバージョンは、使用するライブラリの対応状況を確認して決める。

KubuntuとWindows 11の両方で実行する。

```bash
uv python install 3.13
```

プロジェクトのディレクトリでPythonバージョンを固定する。

```bash
uv python pin 3.13
```

これにより、プロジェクト直下に`.python-version`が作成される。

```text
3.13
```

`uv`は既存のPythonを検出して使うこともできる。2台の環境を揃える目的では、両方で`uv python install`と`uv python pin`を実行し、`uv run python --version`で確認する運用が分かりやすい。

### 3. 新しいプロジェクトを作る

```bash
uv init --no-package my_app
cd my_app
uv python pin 3.13
uv sync
```

`uv init`で、`pyproject.toml`、`README.md`、サンプルのPythonファイルなどが作成される。`uv sync`により、`.venv`と`uv.lock`が作成される。

既存のGitHubリポジトリを使う場合は、次の手順にする。

```bash
git clone https://github.com/ユーザー名/リポジトリ名.git
cd リポジトリ名
uv sync
```

リポジトリに`.python-version`がない場合は、最初のPCで`uv python pin 3.13`を実行し、`.python-version`をGitへ登録する。

## ライブラリを追加する方法

実行に必要なライブラリを追加する。

```bash
uv add requests
```

テスト用ライブラリを追加する。

```bash
uv add --dev pytest
```

これにより、通常は次の2ファイルが更新される。

- `pyproject.toml`
- `uv.lock`

この2ファイルをGitへcommitし、もう一方のPCで`git pull`と`uv sync`を実行する。

## ファイル選択GUIアプリの設計方針

今回の主な用途は、GUIでファイルまたはフォルダを選択し、Pythonで処理して結果を表示・保存するアプリである。この場合、**GUI部分と処理部分を分離すること**が互換性とテストの基本になる。

### GUIフレームワークの選び方

| 候補 | 向いているケース | 注意点 |
|---|---|---|
| `tkinter` + `ttk` | 小規模な個人用ツール、ファイル選択、設定画面 | OSごとに見た目が異なる。Kubuntuでは`tkinter`の導入状態を確認する |
| `PySide6` | ボタン、表、進捗表示、複数画面などを作り込むアプリ | 依存関係が大きい。`uv add pyside6`でプロジェクトに追加する |

`tkinter`はPython標準のTcl/Tkインターフェースであり、ファイル選択用の`tkinter.filedialog`を利用できる。[Python公式：tkinter](https://docs.python.org/3/library/tkinter.html)

小さなファイル処理ツールは`tkinter`から始める。画面の見た目、表形式の表示、進捗バー、複数画面、将来の拡張を重視する場合は`PySide6`を候補とする。PySide6はQtの公式Pythonバインディングであり、Windows・Linuxを含むデスクトップアプリに対応する。[Qt for Python公式](https://doc.qt.io/qtforpython-6/)

### tkinterの動作確認

`uv`のプロジェクト環境で実行する。

```bash
uv run python -m tkinter
```

テスト用のウィンドウが表示されれば、基本的な`tkinter`の動作を確認できる。表示されない場合は、`uv sync`だけでは解決しないOS側のGUIランタイム、表示環境、PythonのTk対応を確認する。

### 画面処理とファイル処理を分ける

推奨する役割分担は次のとおりである。

| モジュール | 担当する処理 |
|---|---|
| `gui.py` | ボタン、ファイルダイアログ、進捗表示、エラーメッセージ |
| `processor.py` | `Path`を受け取り、ファイルを読み込み、結果を保存 |
| `app.py` | アプリ起動と各モジュールの接続 |
| `tests/test_processor.py` | GUIを起動せずにファイル処理を検証 |

処理関数はGUIライブラリをimportせず、`Path`を受け取る形にする。

```python
# processor.py
from pathlib import Path


def process_file(input_path: Path, output_dir: Path) -> Path:
    """入力ファイルを処理し、出力ファイルのパスを返す。"""
    output_path = output_dir / f"{input_path.stem}_processed{input_path.suffix}"
    # 実際の処理をここへ実装する
    return output_path
```

### ファイル選択時の基本ルール

- ダイアログがキャンセルされた場合は、処理を開始しない。
- ダイアログから受け取った文字列をすぐに`Path`へ変換する。
- 日本語、空白、括弧を含むパスで動作確認する。
- 入力ファイルと出力先を分ける。
- 上書きする場合は、実行前に確認ダイアログを表示する。
- ファイルが存在しない、読み込み権限がない、出力先に書き込めない場合は、利用者向けのエラーを表示する。

`tkinter`を使う場合の最小例は次のとおりである。

```python
from pathlib import Path
import tkinter as tk
from tkinter import filedialog, messagebox


def choose_file(root: tk.Tk) -> None:
    selected = filedialog.askopenfilename(
        parent=root,
        title="処理するファイルを選択",
        filetypes=[("テキストファイル", "*.txt"), ("すべてのファイル", "*.*")],
    )
    if not selected:
        return

    input_path = Path(selected)
    try:
        # ここでprocessor.pyの処理関数を呼び出す
        print(input_path)
    except OSError as error:
        messagebox.showerror("処理エラー", str(error), parent=root)
```

### 長い処理でGUIを固まらせない

画像・動画・大量ファイルの処理をボタンのイベント関数で直接実行すると、処理中にウィンドウが応答しなくなる。

- 処理本体は`processor.py`へ分離する。
- 長い処理はバックグラウンドで実行する。
- 画面の更新はGUIのメインスレッドから行う。
- 処理中はボタンを無効化し、進捗または「処理中」を表示する。
- 成功、失敗、キャンセルを区別する。

Tkinterでは`threading`と`root.after`、PySide6では`QThread`または`QRunnable`を候補とする。実装時はGUIフレームワークに合ったスレッド処理をCodexへ指定する。

## 日常の開発手順

### 作業開始時

```bash
git pull
uv sync
```

### 実行・テスト

```bash
uv run python app.py
uv run pytest
```

`uv run`を使う場合、仮想環境を手動でactivateする必要はない。WindowsとKubuntuで、基本的に同じ実行コマンドを使える。

### 作業終了時

```bash
git add .
git commit -m "機能を追加"
git push
```

Windows 11で作業した後にKubuntuで続ける場合は、Kubuntu側で次を実行する。

```bash
git pull
uv sync
```

> [!important] 環境を作り直す基本コマンド
> リポジトリをcloneした後に`uv sync`を実行すれば、`pyproject.toml`と`uv.lock`をもとにプロジェクト環境を再構築できる。`.venv`をコピーする必要はない。

## Pythonコードの互換性ルール

### パスを直接書かない

次のようなOS固有のパスは避ける。

```python
path = "C:\\Users\\名前\\Desktop\\data.txt"
```

`pathlib.Path`を使う。

```python
from pathlib import Path

base_dir = Path(__file__).resolve().parent
data_file = base_dir / "data" / "data.json"
```

### 文字コードを指定する

```python
with data_file.open("r", encoding="utf-8") as file:
    text = file.read()
```

### OSのコマンドに依存しない

`ls`、`rm`、`grep`、bashスクリプト、Windows専用の`.bat`ファイルなどを、アプリの主要処理から直接呼び出さない。

Pythonプログラムを起動する場合は、現在使用中のPythonを示す`sys.executable`を使う。

```python
import subprocess
import sys

subprocess.run([sys.executable, "other_script.py"], check=True)
```

### ファイル名の大文字・小文字を揃える

Linuxはファイル名の大文字・小文字を区別する。Windowsは区別しない設定が一般的である。

```text
Data.py
data.py
```

のように、似た名前のファイルを作らない。import名と実際のファイル名の大文字・小文字を一致させる。

### 設定や秘密情報を環境変数に分離する

APIキー、ユーザー名、データ保存先などをソースコードへ直接書かない。

```text
.env          # 各PCに個別に作成し、Git管理しない
.env.example  # 必要な項目名だけをGitで共有する
```

### OS依存ライブラリは条件付きで扱う

Windowsだけで必要なライブラリには、Pythonの環境マーカーを使える。

```toml
[project]
dependencies = [
    "pywin32; sys_platform == 'win32'",
]
```

ただし、Windows専用ライブラリを使う部分はKubuntuでは動かない。OS依存部分を専用モジュールへ分離し、共通処理から切り離す。

## Git管理用ファイル

### `.gitignore`

```gitignore
.venv/
__pycache__/
*.py[cod]
.pytest_cache/
.mypy_cache/

.env

build/
dist/
*.egg-info/
```

### `.gitattributes`

```gitattributes
* text=auto
*.py text eol=lf
*.md text eol=lf
```

PythonファイルやMarkdownの改行コードをリポジトリ内で統一し、WindowsとLinuxの不要な差分を減らす。

## 互換性を確認する方法

### 毎回確認する項目

```bash
uv run python --version
uv run python -c "import sys; print(sys.executable)"
uv run pytest
```

Windows 11とKubuntuの両方で、次を確認する。

- Pythonのmajor.minorバージョンが同じである
- `uv run`がプロジェクトの`.venv`を使っている
- 依存ライブラリのインストールに成功する
- テストが成功する
- ファイル入出力、文字コード、パス処理が正常である

### GUIアプリの手動確認項目

Windows 11とKubuntuで、少なくとも次を確認する。

- アプリが起動し、メインウィンドウが表示される。
- ファイル選択ダイアログを開ける。
- ダイアログをキャンセルしてもエラーにならない。
- 日本語、空白、括弧を含むパスを選択できる。
- 1ファイル、複数ファイル、フォルダ選択が仕様どおり動く。
- 入力ファイルが存在しない場合や、形式が不正な場合にエラーを表示できる。
- 長い処理中にウィンドウが固まらず、処理完了後に結果が表示される。
- 出力先に同名ファイルがある場合の扱いがOS間で一致する。

### 動作確認の優先順位

1. Windows 11でアプリの主要機能を確認する。
2. Kubuntuで同じテストを実行する。
3. OS固有の処理がある場合は、両方の分岐を個別に確認する。
4. `.exe`化する場合はWindows上でビルドして確認する。

## 影響・リスク

> [!warning] uvで解決できない互換性
> `uv.lock`は依存関係の再現性を高めるが、OS固有のAPI、GUIの見た目、ファイル権限、外部コマンド、GPUやドライバーの差を解消するものではない。Windows 11で動けばKubuntuでも必ず動く、またはその逆、とは限らない。

- GUIアプリは、使用するGUIライブラリのWindows・Linux対応状況を確認する必要がある。
- `uv`はPythonパッケージと仮想環境を管理するが、GUIの表示環境やOS側のランタイムをすべて用意するものではない。
- `tkinter`はOS側のTcl/Tkやフォントの違いにより、画面の見た目や日本語表示が変わる場合がある。
- ファイル選択後の長い処理をGUIスレッドで実行すると、Windows・Linuxの両方で画面が固まる可能性がある。
- C拡張を含むライブラリは、OSごとに異なるwheelがインストールされる場合がある。
- Windows用の`.exe`とLinux用の実行ファイルは別々にビルドする必要がある。
- uv管理のPythonを使う場合、uvはAstralが提供する`python-build-standalone`由来のPythonディストリビューションを使用する。対象ライブラリや配布方法に関係する場合は、uv管理Pythonでの動作確認を行う。

PyInstallerを使う場合も、Windows用はWindows上、Linux用はLinux上で個別にビルドする。[PyInstaller公式](https://pyinstaller.org/en/stable/usage.html)

## 対応方針

### 初心者向けの標準運用

- Python環境管理は`uv`へ統一する。
- プロジェクトごとに`.venv`を作る。
- ライブラリの追加は`uv add`で行う。
- 実行とテストは`uv run`で行う。
- 依存関係を変更したら、`pyproject.toml`と`uv.lock`をcommitする。
- 作業するPCを切り替える前に`git push`し、次のPCで`git pull`と`uv sync`を実行する。
- Windows 11を基準にしつつ、Kubuntuでも定期的にテストする。

## 未確認事項

- GUIを`tkinter`で作るか`PySide6`で作るかは、画面の複雑さと見た目の要求を決めた段階で選定する。
- 入力対象がテキスト、画像、動画、音声、表計算ファイルのどれかは未確定である。
- 外部コマンドや別途インストールが必要なソフトウェアを使う場合は、Windows・Kubuntuそれぞれの導入方法を確認する。
- 大量ファイルや長時間処理を扱う場合は、キャンセル、進捗表示、ログ保存の要否を決める。

## 次のアクション

> [!todo] 最初に行う作業
> 1. Windows 11とKubuntuへ`uv`をインストールする。
> 2. 使用するPythonバージョンを決め、`uv python pin`で固定する。
> 3. GitHubにプライベートリポジトリを作成する。
> 4. 2台のPCへcloneし、両方で`uv sync`を実行する。
> 5. GUIフレームワークを選び、`uv run python -m tkinter`などで動作確認する。
> 6. `uv run python app.py`と`uv run pytest`を両方のPCで実行する。

## Codexへ依頼するときのプロンプト

GUIアプリの実装をCodexへ依頼するときは、「何を処理するか」だけでなく、対象OS、環境管理、GUIの動作、互換性条件、検証方法まで指定する。次のテンプレートをコピーし、`[ ]`の部分を具体化して使用する。

~~~text
Pythonで、Windows 11とKubuntuの両方で動作するGUIアプリを作成したい。

## アプリの目的
[選択したファイルまたはフォルダに対して行う処理を具体的に書く]

## 入力と出力
- 入力：[対応する拡張子、1ファイルか複数か、フォルダか]
- 出力：[保存先、ファイル名規則、上書き可否]
- 処理後：[画面に表示する結果、ログ、エラー内容]

## 対象環境
- Windows 11：最終的な主対象
- Kubuntu：同じソースコードで動作確認する対象
- Python：[例：3.13]
- 環境管理：uv
- 依存関係：pyproject.tomlとuv.lockで管理
- 実行方法：uv runを使用する

## GUI要件
- GUIからファイルまたはフォルダを選択できること
- キャンセル時は処理を開始しないこと
- 日本語、空白、括弧を含むパスを扱えること
- 処理中は画面が固まらず、進捗または処理中表示を出すこと
- 成功、失敗、キャンセルを画面上で区別すること
- 入力不正、読み込み失敗、出力失敗を利用者向けメッセージで表示すること
- 出力先に同名ファイルがある場合の動作を明示すること

## 実装条件
- まず既存のファイル構成と設定を読み、変更方針と検証方法を短く示してから編集すること
- 不明点は勝手に補わず、置いた仮定を明記すること
- GUI処理とファイル処理を分離すること
- processor.pyの処理関数はPathを受け取り、GUIライブラリに依存しないこと
- パスはpathlib.Pathで扱うこと
- テキストの文字コードは必要に応じてencoding="utf-8"を明示すること
- 外部コマンドを使う場合はshutil.whichで存在確認し、subprocess.runへ引数のリストを渡すこと
- shell=True、OS固有のls、rm、grep、C:\や/home/から始まる固定パスを主要処理へ持ち込まないこと
- GUIフレームワークは、要件が小さければtkinterとttkを優先すること
- PySide6が適切な場合は、採用理由を説明してuv add pyside6で追加すること
- uv.lockを手作業で編集しないこと

## テスト要件
- GUIを起動せずに処理ロジックをテストできること
- 日本語・空白を含むパスをテストすること
- キャンセル、入力ファイル不在、形式不正、出力先エラーをテストすること
- 可能な範囲でWindows 11とKubuntuの両方でuv run pytestを実行すること
- GUIでは、ファイル選択、キャンセル、処理開始、処理完了、エラー表示を手動確認すること

## 変更後の報告
- 変更したファイル
- 実行したuv add、uv sync、uv runのコマンド
- テスト結果
- Windows 11とKubuntuで未確認の項目
- 残るリスクと次に確認すること
~~~

### 依頼文の具体例

処理内容が決まっている場合は、次のように依頼する。

~~~text
上の条件で、複数のCSVファイルを選択し、指定した列を加工して別フォルダへ保存するGUIアプリを作成してください。

追加条件：
- ファイル選択は複数選択に対応すること
- 出力先フォルダを別途選択できること
- 入力ファイルごとの成功・失敗を一覧表示すること
- 1ファイルの失敗で残りのファイル処理を停止しないこと
- 既存ファイルを上書きする前に確認すること
- まず設計案とファイル構成を示し、承認後に実装すること
~~~

**Codexへ必ず伝える条件**

「WindowsとLinuxで動かしたい」だけでは不十分である。使用するPythonバージョン、`uv`、GUIフレームワーク、入力・出力、キャンセル時の動作、エラー処理、テスト対象を具体的に書く。特に「GUIと処理ロジックを分離すること」を指定すると、OSごとの不具合を切り分けやすくなる。

## 出典

- [uv公式：Installation](https://docs.astral.sh/uv/getting-started/installation/)
- [uv公式：Working on projects](https://docs.astral.sh/uv/guides/projects/)
- [uv公式：Python versions](https://docs.astral.sh/uv/concepts/python-versions/)
- [uv公式：Managing dependencies](https://docs.astral.sh/uv/concepts/projects/dependencies/)
- [uv公式：Structure and files](https://docs.astral.sh/uv/concepts/projects/layout/)
- [uv公式：Locking and syncing](https://docs.astral.sh/uv/concepts/projects/sync/)
- [Python公式：pathlib](https://docs.python.org/3/library/pathlib.html)
- [Python公式：tkinter](https://docs.python.org/3/library/tkinter.html)
- [Python公式：subprocess](https://docs.python.org/3/library/subprocess.html)
- [Qt for Python公式](https://doc.qt.io/qtforpython-6/)
- [Qt for Python公式：Deployment](https://doc.qt.io/qtforpython-6/deployment/index.html)
- [GitHub Docs：Cloning a repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)
- [PyInstaller公式：Using PyInstaller](https://pyinstaller.org/en/stable/usage.html)

## 関連

- [[Kubuntu_VSCode_uv_Python_guide]]
- [[Kubuntu_VSCode_uv_Python_練習教科書]]
- [[github-2台のPCで同一リポジトリを使う方法]]
- [[githubとローカルフォルダの同期tips]]

