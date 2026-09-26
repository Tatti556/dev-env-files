---
created: 2026-08-15 06:45
type: howto
status: active
area: tech
topic: python
tags:
  - python
  - uv
  - vscode
  - kubuntu
aliases:
  - Kubuntuでuvを使うPython開発環境
  - VS CodeとuvによるPython仮想環境
  - Python uv入門
author: T.I.
source:
  - https://note.com/thinker_inc/n/n30afbe578209
  - https://docs.astral.sh/uv/
  - https://docs.astral.sh/uv/concepts/projects/
  - https://code.visualstudio.com/docs/python/environments
---

# Kubuntu + VS Code + uvで始めるPython開発環境

## 結論

- Kubuntu上でVS Codeを使ってPython開発を始める場合、**uvをPython環境管理の中心に置く構成が分かりやすい**。
- 基本形は **1プロジェクト = 1つの`.venv` + `pyproject.toml` + `uv.lock`** とする。
- Python本体、仮想環境、ライブラリ管理をuvに寄せることで、`venv`、`pip`、`requirements.txt`などを個別に管理する負担を減らせる。
- 初心者のうちは仮想環境を手動で`activate`するより、**`uv run`で実行する運用**を基本とする。
- VS Codeにはプロジェクト内の`.venv/bin/python`をPython Interpreterとして認識させる。

## uvとは何か

uvはPythonのパッケージ・プロジェクト管理ツールである。

単なる高速な`pip`ではなく、次の役割をまとめて扱える。

- Pythonバージョンの管理
- 仮想環境の作成・管理
- Pythonライブラリの追加・削除
- 依存関係の解決
- プロジェクト設定の管理
- ロックファイルの生成
- Pythonプログラムの実行

従来は複数のツールを組み合わせることが多かった。

```text
Python本体
  ↓
venv
  ↓
pip
  ↓
requirements.txt
```

uvでは、これらを次のようにまとめて扱える。

```text
              uv
               │
      ┌────────┼────────┐
      ↓        ↓        ↓
   Python    .venv   パッケージ
                       │
               pyproject.toml
                       │
                    uv.lock
```

## 仮想環境とは何か

仮想環境は、**Pythonプロジェクトごとに独立したPython実行環境を持つ仕組み**である。

例えば、次の2つのプロジェクトがあるとする。

```text
Project-A
└─ pandas 2.x が必要

Project-B
└─ pandas 3.x が必要
```

PC全体で1つのPython環境を共有すると、ライブラリのバージョンが衝突する可能性がある。

仮想環境を使えば、次のように分離できる。

```text
Project-A
├─ Python
├─ pandas 2.x
└─ その他ライブラリ

Project-B
├─ Python
├─ pandas 3.x
└─ その他ライブラリ
```

uvでは通常、各プロジェクト内に次のディレクトリが作られる。

```text
.venv/
```

これがそのプロジェクト専用の仮想環境である。

> [!important] 基本ルール
> **1プロジェクトにつき1つの`.venv`を持たせる。**
> 複数プロジェクトで同じ仮想環境を共有しない。

## 重要な4要素

### uv

Python環境全体を管理する司令塔である。

主な操作は`uv`コマンドから行う。

### `.venv/`

実際の仮想環境が入るディレクトリである。

```text
project/
└─ .venv/
```

通常はGitへ登録しない。

削除しても、プロジェクト定義が残っていれば再構築できる。

### `pyproject.toml`

プロジェクトの設定や依存ライブラリを記録するファイルである。

例えば、`requests`と`pandas`を追加すると、概念的には次のような情報が記録される。

```toml
dependencies = [
    "pandas>=2.3",
    "requests>=2.32",
]
```

「このプロジェクトでは何を使うか」を示す設計書に相当する。

### `uv.lock`

実際に使用するライブラリの正確なバージョンを記録するファイルである。

例えば`requests`を追加すると、`requests`本体だけでなく、その依存ライブラリも含めて解決結果が保存される。

```text
requests
urllib3
certifi
charset-normalizer
idna
...
```

`uv.lock`は基本的にGitへ登録する。

これにより、別PCでも同じ依存関係を再現しやすくなる。

## 推奨するプロジェクト構成

Python学習や小規模なツール作成では、まず次の構成で十分である。

```text
~/Projects/
├── project-a/
│   ├── .venv/
│   ├── pyproject.toml
│   ├── uv.lock
│   └── main.py
│
├── project-b/
│   ├── .venv/
│   ├── pyproject.toml
│   ├── uv.lock
│   └── main.py
│
└── project-c/
    ├── .venv/
    ├── pyproject.toml
    ├── uv.lock
    └── main.py
```

`.venv`は各プロジェクト専用とする。

一方、uvはパッケージをグローバルキャッシュして再利用するため、各プロジェクトに`.venv`を持たせても単純に全データが重複するわけではない。

## 最初のプロジェクトを作る

### 1. プロジェクト保存用ディレクトリを作る

```bash
mkdir -p ~/Projects
cd ~/Projects
```

### 2. uvプロジェクトを作る

初心者向けのシンプルな構成では、次を使用する。

```bash
uv init --no-package hello-python
cd hello-python
```

作成直後は概ね次のような構成になる。

```text
hello-python/
├── .python-version
├── README.md
├── main.py
└── pyproject.toml
```

> [!warning] `uv init`の挙動
> 2026年時点のuvでは、通常の`uv init`はパッケージ化を前提とした構成を作成する。
> 初心者が単純なPythonスクリプトから始める場合は、`uv init --no-package`の方が理解しやすい。

また、`uv init`を実行した時点では、必ずしも`.venv`や`uv.lock`が作成されるわけではない。

これらは`uv add`、`uv run`、`uv sync`など、実際にプロジェクト環境が必要になった段階で生成される。

### 3. VS Codeで開く

```bash
code .
```

これにより、現在のプロジェクトをVS Codeで開ける。

## ライブラリを追加する

例えばHTTP通信に使う`requests`を追加する。

```bash
uv add requests
```

この操作により、主に次の処理が行われる。

- `requests`を依存関係へ追加
- `pyproject.toml`を更新
- 依存関係を解決
- `uv.lock`を生成または更新
- 必要に応じて`.venv`を作成
- `.venv`へ必要なライブラリを同期

従来のように、

```bash
pip install requests
```

とだけ実行するより、プロジェクト定義と実際の環境を一致させやすい。

## Pythonプログラムを実行する

例えば`main.py`を次の内容にする。

```python
import requests

response = requests.get("https://example.com")

print(response.status_code)
```

uv経由で実行する。

```bash
uv run main.py
```

または次でもよい。

```bash
uv run python main.py
```

`uv run`はプロジェクトの仮想環境を使用してコマンドを実行する。

必要に応じて環境の同期も行われるため、初心者のうちはこの方法を基本とする。

## 仮想環境のactivateは必要か

従来のPythonでは、次の操作をよく使用する。

```bash
source .venv/bin/activate
```

その後、

```bash
python main.py
```

と実行する。

uvでは、基本的に次で実行できる。

```bash
uv run python main.py
```

したがって、**`.venv`のactivateは必須ではない**。

初心者のうちは次の運用で統一すると分かりやすい。

```text
仮想環境を手動でactivateしない
        ↓
Python実行時はuv runを付ける
```

## VS Codeと`.venv`を連携する

uv側で正しい仮想環境を使用していても、VS Codeが別のPythonを参照していると、次のような問題が起こる。

- インストール済みライブラリに赤線が付く
- importエラーと表示される
- コード補完が正しく動かない
- デバッグ時に別のPythonが使われる

そのため、VS Codeにもプロジェクトの`.venv`を認識させる。

### Python Interpreterを選択する

VS Codeで次を実行する。

1. `Ctrl + Shift + P`を押す。
2. `Python: Select Interpreter`を選ぶ。
3. プロジェクト内の`.venv`を選択する。

Kubuntuでは通常、次のPythonが対象になる。

```text
<プロジェクト>/.venv/bin/python
```

例えば、

```text
/home/tatti556/Projects/hello-python/.venv/bin/python
```

となる。

通常はプロジェクト直下に`.venv`があれば、VS Codeが自動検出する。

## よく使うuvコマンド

| コマンド | 用途 |
|---|---|
| `uv init --no-package project-name` | シンプルなPythonプロジェクトを作成 |
| `uv add requests` | ライブラリを追加 |
| `uv remove requests` | ライブラリを削除 |
| `uv run main.py` | プロジェクト環境でPythonを実行 |
| `uv sync` | `.venv`とプロジェクト定義を同期 |
| `uv tree` | ライブラリの依存関係を確認 |
| `uv python list` | 使用可能なPythonを確認 |
| `uv python install 3.13` | Python 3.13をインストール |

最初から全コマンドを覚える必要はない。

まずは次の3つを覚えればよい。

```bash
uv init --no-package
uv add
uv run
```

## Python本体もuvで管理できる

uvはPython本体も管理できる。

例えばPython 3.13をインストールする場合は次を使用する。

```bash
uv python install 3.13
```

Python 3.12なら次の通りである。

```bash
uv python install 3.12
```

これにより、将来的には次の役割をuvへまとめられる。

```text
uv
├─ Pythonバージョン
├─ 仮想環境
├─ ライブラリ
├─ pyproject.toml
└─ uv.lock
```

初心者の段階で`pyenv`や複数のPython環境管理ツールを追加する必要性は低い。

## 別PCで環境を再現する

Git等からPythonプロジェクトを別PCへ持ってきた場合、`.venv`自体をコピーする必要はない。

プロジェクトへ移動して次を実行する。

```bash
uv sync
```

`pyproject.toml`と`uv.lock`を基に、そのPC用の`.venv`を再構築できる。

このためGitへ登録する対象は概ね次のようになる。

```text
登録する
├─ pyproject.toml
├─ uv.lock
├─ .python-version
├─ main.py
└─ その他ソースコード

登録しない
└─ .venv/
```

`.venv`は成果物ではなく、再生成可能な作業環境として扱う。

## 基本的な開発フロー

Pythonプロジェクトを新規作成する場合は、まず次の流れを基本とする。

```bash
cd ~/Projects

uv init --no-package my-project
cd my-project

code .
```

必要なライブラリを追加する。

```bash
uv add requests
```

コードを書く。

```python
import requests

print(requests.get("https://example.com").status_code)
```

実行する。

```bash
uv run main.py
```

別のライブラリが必要になったら追加する。

```bash
uv add pandas
```

不要になったら削除する。

```bash
uv remove pandas
```

環境を明示的に同期する場合は次を使う。

```bash
uv sync
```

## 初心者向けの運用方針

> [!tip] 当面の運用
> - Python環境管理はuvへ寄せる。
> - 1プロジェクトごとに`.venv`を持たせる。
> - ライブラリ追加は`pip install`ではなく`uv add`を使う。
> - Python実行は`uv run`を基本とする。
> - VS Codeでは`.venv/bin/python`を選択する。
> - `.venv`はGitへ登録しない。
> - `pyproject.toml`と`uv.lock`はGitへ登録する。

この運用に統一することで、Python初心者が混乱しやすい「今どのPythonを使っているのか」「どこへライブラリをインストールしたのか」という問題を減らせる。

## 次に実施すること

実際のKubuntu環境では、次の順序で進めるとよい。

1. uvがインストール済みか確認する。
2. uvをKubuntuへインストールする。
3. `~/Projects`を作成する。
4. 練習用プロジェクトを1つ作成する。
5. VS Codeでプロジェクトを開く。
6. VS CodeへPython拡張機能を導入する。
7. `.venv/bin/python`をInterpreterとして選択する。
8. `uv add`でライブラリを1つ追加する。
9. `uv run`でPythonを実行する。
10. `pyproject.toml`と`uv.lock`の中身を確認する。

ここまで実施すれば、uvを使ったPython開発環境の基本形を一通り体験できる。

## 出典

- [uv公式ドキュメント](https://docs.astral.sh/uv/)
- [uv Projects](https://docs.astral.sh/uv/concepts/projects/)
- [Visual Studio Code - Python Environments](https://code.visualstudio.com/docs/python/environments)
- [参考記事：uvを使ったPython環境構築](https://note.com/thinker_inc/n/n30afbe578209)

## 練習

[[python_uv練習01]]
