---
created: 2026-08-15 07:21
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
  - uvとVS Codeで学ぶPython開発環境
  - Python仮想環境の復習教材
  - Kubuntu Python練習教科書
author: T.I.
---

# Kubuntu + VS Code + uvで学ぶPython開発環境 練習教科書

## 結論

- Python開発環境は、**uvを中心に管理し、VS Codeは編集とデバッグに使う**構成とする。
- 基本形は **1プロジェクト = 1つの`.venv`** とする。
- Python実行は、当面 **`uv run main.py`** に統一する。
- VS Codeでは、各プロジェクトの **`.venv/bin/python`** をInterpreterとして選択する。
- Kubuntu標準のPythonと、自分の開発用Pythonは分離して扱う。
- 忘れた場合は、この教科書を上から順に実行すれば、練習環境を再構築できる。

## この教科書の目的

このノートは、次回Python開発環境の作り方を忘れたときに、ゼロからもう一度練習するための教材である。

対象は次の環境とする。

```text
OS        : Kubuntu
エディタ   : VS Code
環境管理   : uv
Python     : 3.13系
Shell      : zsh
仮想環境   : .venv
```

今回の練習では、実際に以下を確認した。

- uvのインストール確認
- uv管理Python 3.13の導入
- 練習用プロジェクトの作成
- `.venv`の生成
- Python 3.13の利用確認
- VS CodeのInterpreter設定
- `main.py`の作成
- `uv run`による実行
- VS Code標準ターミナルをzshへ統一

---

## 1. まず理解しておく全体像

今回作る環境は次の構成である。

```text
Kubuntu
│
├─ OS標準Python
│   └─ /usr/bin/python3
│
└─ 自分の開発環境
    │
    └─ uv
        │
        ├─ Python 3.13
        │
        └─ 各プロジェクト
            │
            └─ .venv
                └─ プロジェクト専用Python
```

重要なのは、**OS標準Pythonを自分の開発用として直接いじらないこと**である。

自分のPython開発はuv側で完結させる。

---

## 2. uvとは何か

uvはPython開発環境をまとめて管理するツールである。

今回の用途では、主に次を担当する。

- Python本体の管理
- 仮想環境の作成
- プロジェクト管理
- ライブラリ管理
- Pythonプログラムの実行
- 依存関係の管理

従来は次のように複数の仕組みを意識する必要があった。

```text
Python
↓
venv
↓
pip
↓
requirements.txt
```

uvを使うと、これらをかなり一本化できる。

```text
              uv
               │
      ┌────────┼────────┐
      ↓        ↓        ↓
   Python    .venv   ライブラリ
                       │
               pyproject.toml
                       │
                    uv.lock
```

---

## 3. 仮想環境`.venv`とは何か

`.venv`は、**そのプロジェクト専用のPython環境**である。

例えば次のように分離する。

```text
project-a/
└─ .venv/
   └─ project-a専用Python環境

project-b/
└─ .venv/
   └─ project-b専用Python環境
```

各プロジェクトで別のライブラリやバージョンを使っても、互いに影響しにくくなる。

> [!important] 基本ルール
> 1プロジェクトにつき1つの`.venv`を持たせる。
> `.venv`を複数プロジェクトで共有しない。

---

## 4. uvが入っているか確認する

ターミナルで次を実行する。

```bash
uv --version
```

今回の環境では次のように表示された。

```text
uv 0.12.5 (x86_64-unknown-linux-gnu)
```

このようにバージョンが表示されればuvは利用可能である。

---

## 5. uvで利用可能なPythonを確認する

```bash
uv python list
```

今回の環境では、Kubuntu標準Pythonとして3.14系が存在していた。

```text
/usr/bin/python3.14
/usr/bin/python3 -> python3.14
```

一方で、Python 3.13はuvからダウンロード可能な状態だった。

```text
cpython-3.13.15-linux-x86_64-gnu
```

今回は練習用としてPython 3.13を使用する。

---

## 6. uv管理のPython 3.13をインストールする

```bash
uv python install 3.13
```

今回の実行結果は次の通りだった。

```text
Installed Python 3.13.15
```

確認する。

```bash
uv python list
```

今回の環境では、uv管理Python 3.13.15が次の場所に入った。

```text
~/.local/share/uv/python/cpython-3.13-linux-x86_64-gnu/bin/python3.13
```

また、次のリンクも作られた。

```text
~/.local/bin/python3.13
```

このPythonを元に、各プロジェクト専用の`.venv`を作る。

---

## 7. 練習用プロジェクトを作る

開発用ディレクトリを作る。

```bash
mkdir -p ~/Projects
cd ~/Projects
```

練習プロジェクトを作る。

```bash
uv init --no-package uv-practice
```

プロジェクトへ移動する。

```bash
cd uv-practice
```

`--no-package`を使うことで、初心者向けの単純なPythonスクリプト構成にする。

---

## 8. Python 3.13をこのプロジェクトで使うように指定する

```bash
uv python pin 3.13
```

確認する。

```bash
cat .python-version
```

次のように表示されればよい。

```text
3.13
```

`.python-version`は、このプロジェクトで使用するPython系列を示す。

---

## 9. 仮想環境`.venv`を作る

```bash
uv sync
```

今回の実行結果は次の通りだった。

```text
Using CPython 3.13.15
Creating virtual environment at: .venv
```

これでプロジェクト内に`.venv`が生成される。

概ね次のような構成になる。

```text
uv-practice/
├── .venv/
├── .python-version
├── README.md
├── main.py
├── pyproject.toml
└── uv.lock
```

---

## 10. 本当にPython 3.13を使っているか確認する

```bash
uv run python --version
```

今回の結果は次の通りだった。

```text
Python 3.13.15
```

さらに実際に使われているPythonの場所を確認する。

```bash
uv run python -c "import sys; print(sys.executable)"
```

今回の結果は次の通りだった。

```text
/home/tatti556/Projects/uv-practice/.venv/bin/python3
```

つまり実際の実行経路は次のようになっている。

```text
uv管理 Python 3.13.15
        ↓
uv-practice用の.venvを生成
        ↓
uv-practice/.venv/bin/python3
        ↓
Pythonプログラムを実行
```

---

## 11. VS Codeでプロジェクトを開く

プロジェクトディレクトリにいる状態で実行する。

```bash
code .
```

`.`は現在のディレクトリを意味する。

したがって、`code .`は現在のプロジェクトをVS Codeで開く操作である。

---

## 12. VS CodeのPython Interpreterを設定する

VS Codeでは、uvが作った`.venv`を選択する。

1. `Ctrl + Shift + P`を押す。
2. `Python: Select Interpreter`を選ぶ。
3. 次のような項目を選ぶ。

```text
uv-practice (3.13.x) ./.venv/bin/python
```

今回選択したものは実質的に次のPythonである。

```text
/home/tatti556/Projects/uv-practice/.venv/bin/python
```

### 選んではいけない候補

今回のプロジェクトでは、次を直接選ばない。

```text
/usr/bin/python3
~/.local/bin/python3.13
~/.local/share/uv/python/...
```

これらはプロジェクト専用環境ではない。

選ぶのは必ず次である。

```text
uv-practice/.venv/bin/python
```

---

## 13. 最初のPythonファイルを書く

`main.py`を次の内容にする。

```python
name = "Tatsuya"

print("Hello, Python!")
print(f"こんにちは、{name}さん")
```

保存する。

```text
Ctrl + S
```

---

## 14. Pythonを実行する

VS Codeのターミナルで次を実行する。

```bash
uv run main.py
```

今回の結果は次の通りだった。

```text
Hello, Python!
こんにちは、Tatsuyaさん
```

これでPython 3.13の仮想環境から`main.py`を実行できたことになる。

---

## 15. なぜ`uv run`を使うのか

従来は次のように仮想環境をactivateすることが多い。

```bash
source .venv/bin/activate
```

その後、

```bash
python main.py
```

と実行する。

しかしuvを使う場合、基本的には次だけでよい。

```bash
uv run main.py
```

当面は、Python実行方法をこれに統一する。

```text
コードを書く
↓
保存する
↓
uv run main.py
```

この方が、どのPythonを使っているのか分からなくなる問題を減らせる。

---

## 16. VS Codeのターミナルをzshへ統一する

今回、VS Codeでターミナルを開く方法によって表示が異なる問題があった。

通常のzshターミナルでは、既に設定済みのカラフルなプロンプトが表示された。

一方、VS Codeの設定によっては異なるターミナルが選ばれる場合がある。

### 標準ターミナルをzshにする

`Ctrl + Shift + P`を押す。

次を選ぶ。

```text
Terminal: Select Default Profile
```

その中から、

```text
zsh
```

を選ぶ。

その後、既存ターミナルを閉じて、新しく開く。

```text
Ctrl + Shift + `
```

これで、普段使用しているzshのカラフルなターミナルが標準になる。

---

## 17. VS Code右上の三角ボタンについて

Pythonファイル右上にある実行ボタンは、VS CodeのPython拡張機能が管理する実行方法である。

実際には次のような処理が行われる。

```text
Python用ターミナルを開く
↓
.venvをactivate
↓
.venv/bin/pythonで実行
```

今回の環境では、次のようなコマンドが自動実行された。

```bash
source /home/tatti556/Projects/uv-practice/.venv/bin/activate
```

その後、

```text
/home/tatti556/Projects/uv-practice/.venv/bin/python
```

で`main.py`が実行された。

これは間違いではない。

ただし、uvの仕組みを理解する練習中は、当面次へ統一する方が分かりやすい。

```bash
uv run main.py
```

---

## 18. よく使うuvコマンド

| やりたいこと | コマンド |
|---|---|
| uvバージョン確認 | `uv --version` |
| Python一覧確認 | `uv python list` |
| Python 3.13導入 | `uv python install 3.13` |
| 新規プロジェクト作成 | `uv init --no-package 名前` |
| Pythonバージョン固定 | `uv python pin 3.13` |
| 仮想環境同期 | `uv sync` |
| Pythonバージョン確認 | `uv run python --version` |
| Pythonファイル実行 | `uv run main.py` |

---

## 19. 練習用の再現手順

次回もう一度練習するときは、別名のプロジェクトを作る。

例えば、

```bash
cd ~/Projects

uv init --no-package uv-practice-2
cd uv-practice-2

uv python pin 3.13
uv sync

code .
```

VS CodeでInterpreterを選ぶ。

```text
Python: Select Interpreter
↓
./.venv/bin/python
```

`main.py`を書く。

```python
name = "Tatsuya"

print("Hello, Python!")
print(f"こんにちは、{name}さん")
```

実行する。

```bash
uv run main.py
```

ここまで何も見ずにできれば、基本操作はかなり身についている。

---

## 20. 復習問題

### 問1

`.venv`は何のためにあるか。

### 問2

なぜ`/usr/bin/python3`ではなく、プロジェクト内の`.venv/bin/python`をVS Codeで選ぶのか。

### 問3

次のコマンドは何をするか。

```bash
uv python install 3.13
```

### 問4

次のコマンドは何をするか。

```bash
uv python pin 3.13
```

### 問5

次のコマンドは何をするか。

```bash
uv sync
```

### 問6

Pythonファイルをuv管理環境で実行する基本コマンドは何か。

### 問7

VS CodeでPython Interpreterを選択するコマンド名は何か。

---

## 21. 復習問題の答え

### 問1

そのプロジェクト専用のPython環境を分離するために使う。

### 問2

プロジェクト専用のPython環境とVS Codeが同じInterpreterを見るようにするためである。

### 問3

uv管理のPython 3.13系をインストールする。

### 問4

そのプロジェクトでPython 3.13系を使用するよう指定する。

### 問5

プロジェクト定義に基づいて仮想環境を作成・同期する。

### 問6

```bash
uv run main.py
```

### 問7

```text
Python: Select Interpreter
```

---

## 22. 自力練習課題

次回は以下を見ずに実行する。

### 課題1

新しいプロジェクトを作る。

```text
~/Projects/uv-review
```

### 課題2

Python 3.13を使うよう設定する。

### 課題3

`.venv`を作る。

### 課題4

VS Codeで開く。

### 課題5

Interpreterとして`.venv/bin/python`を選ぶ。

### 課題6

`main.py`に次の処理を書く。

- 名前を変数へ入れる
- 年齢を変数へ入れる
- 来年の年齢を計算する
- 名前と来年の年齢を表示する

完成例は次のようになる。

```python
name = "Tatsuya"
age = 30

next_age = age + 1

print(f"{name}さん")
print(f"来年は{next_age}歳です")
```

実行する。

```bash
uv run main.py
```

---

## 23. トラブル時の確認順序

### `uv`が見つからない

```bash
uv --version
```

が失敗する場合は、uv自体のPATH設定を確認する。

### Python 3.13にならない

```bash
cat .python-version
```

を確認する。

```text
3.13
```

でなければ、次を実行する。

```bash
uv python pin 3.13
```

### `.venv`がない

```bash
uv sync
```

を実行する。

### VS Codeで違うPythonが選ばれている

```text
Ctrl + Shift + P
↓
Python: Select Interpreter
↓
./.venv/bin/python
```

を選ぶ。

### 実際のPythonの場所を確認したい

```bash
uv run python -c "import sys; print(sys.executable)"
```

正常なら、プロジェクト内の次のようなパスが表示される。

```text
.../uv-practice/.venv/bin/python3
```

### VS Codeのターミナルが普段のzsh表示にならない

```text
Ctrl + Shift + P
↓
Terminal: Select Default Profile
↓
zsh
```

を選ぶ。

---

## 24. 今回覚えるべき最小セット

全部を暗記する必要はない。

まず次の流れだけ覚える。

```bash
cd ~/Projects
uv init --no-package project-name
cd project-name
uv python pin 3.13
uv sync
code .
```

VS Codeで、

```text
Python: Select Interpreter
↓
./.venv/bin/python
```

Pythonを実行するときは、

```bash
uv run main.py
```

これが今回の基本形である。

> [!tip] 覚え方
> **作る → Pythonを決める → syncする → VS Codeで開く → `.venv`を選ぶ → `uv run`で実行する**
