# uv 基本操作ガイド

Pythonプロジェクト管理ツール uv の基本的な使い方をまとめます。

参考動画:

- Python Tutorial: UV - A Faster, All-in-One Package Manager to Replace Pip and Venv
  https://www.youtube.com/watch?v=VgH1GKSCXJQ&t=385s

このガイドでは、現在の uv 0.12.x を前提にしています。動画の公開時期によっては、uv init のデフォルト構成などが現在と異なる場合があります。

## 1. uvの確認

~~~bash
uv --version
~~~

Pythonの一覧を確認するには、次を実行します。

~~~bash
uv python list
~~~

uv のインストール方法は、公式インストールガイドを参照してください。

https://docs.astral.sh/uv/getting-started/installation/

## 2. 最小構成のプロジェクトを作る

学習用や小規模なスクリプトでは、パッケージ構成を作らない --no-package が扱いやすいです。

~~~bash
uv init --no-package --python 3.13 my-project
cd my-project
~~~

主な構成は次のようになります。

~~~text
my-project/
├── .python-version
├── README.md
├── main.py
└── pyproject.toml
~~~

--no-package を指定すると、src/<project_name>/__init__.py や [build-system] は作成されません。main.py を直接実行する構成です。

現在のディレクトリに作る場合は、プロジェクト用ディレクトリに移動してから実行します。

~~~bash
mkdir my-project
cd my-project
uv init --no-package --python 3.13
~~~

### 主なファイル

| ファイル | 役割 |
| --- | --- |
| pyproject.toml | プロジェクト名、対応Python、依存ライブラリなどを管理 |
| .python-version | プロジェクトで使うPythonバージョンを指定 |
| main.py | サンプルのPythonコード |
| .venv/ | プロジェクト専用の仮想環境。必要時に作成される |
| uv.lock | 依存ライブラリの具体的なバージョンを固定 |

.venv/ と uv.lock は、最初の uv run、uv sync、uv lock などで作成されます。

## 3. Pythonのバージョンを切り替える

### 利用可能なバージョンを確認する

~~~bash
uv python list
uv python list 3.13
~~~

必要なPythonが見つからない場合、uv にインストールさせることもできます。

~~~bash
uv python install 3.13
~~~

### プロジェクトのPythonを指定する

~~~bash
uv python pin 3.13
~~~

これにより、プロジェクト直下の .python-version に 3.13 が記録されます。

以後、プロジェクト内で uv を実行すると、基本的にこのバージョンが選択されます。

### requires-python との関係

pyproject.toml の requires-python は、プロジェクトが対応するPythonの範囲です。

~~~toml
[project]
requires-python = ">=3.13"
~~~

例えば、次の状態では 3.13 を指定できません。

~~~toml
requires-python = ">=3.14"
~~~

その場合は、対応範囲を変更してからPythonをpinします。

~~~toml
requires-python = ">=3.13"
~~~

~~~bash
uv python pin 3.13
~~~

確認:

~~~bash
uv run python --version
~~~

## 4. 仮想環境を作る

プロジェクトのPython設定に合わせて仮想環境を作るには、次を実行します。

~~~bash
uv venv
~~~

Pythonのバージョンを明示することもできます。

~~~bash
uv venv --python 3.13
~~~

既存の .venv を別のPythonで作り直す場合は、.venv が破棄されることを確認したうえで --clear を使います。

~~~bash
uv venv --python 3.13 --clear
~~~

### 仮想環境を有効化する

Linux/macOS:

~~~bash
source .venv/bin/activate
~~~

Windows PowerShell:

~~~powershell
.venv\Scripts\Activate.ps1
~~~

有効化を解除するには、次を実行します。

~~~bash
deactivate
~~~

ただし、uv run を使えば仮想環境を有効化しなくても、プロジェクト環境でコマンドを実行できます。

## 5. ライブラリを導入する

### ライブラリを追加する

~~~bash
uv add requests
~~~

複数のライブラリを追加することもできます。

~~~bash
uv add pandas numpy
~~~

バージョンを指定する場合:

~~~bash
uv add "pandas>=2.2"
uv add "requests==2.32.3"
~~~

uv add は、次の処理をまとめて行います。

1. pyproject.toml に依存関係を追加する
2. 依存関係を解決して uv.lock を更新する
3. .venv にライブラリをインストールする

開発時だけ使うライブラリは、開発用依存関係として追加します。

~~~bash
uv add --dev pytest ruff
~~~

### ライブラリを削除する

~~~bash
uv remove requests
~~~

プロジェクトの依存関係を管理する場合は、手動で pip install や uv pip install を実行するより、uv add を使うのが基本です。

## 6. Pythonコードを実行する

main.py を実行します。

~~~bash
uv run main.py
~~~

uv run は、必要に応じて仮想環境を作成・更新し、uv.lock に基づく環境でコマンドを実行します。

Pythonインタープリターを直接実行することもできます。

~~~bash
uv run python --version
uv run python -c "import requests; print(requests.__version__)"
~~~

仮想環境を有効化した場合は、通常のPythonコマンドも使えます。

~~~bash
source .venv/bin/activate
python main.py
~~~

## 7. 環境を同期する

pyproject.toml と uv.lock の内容を .venv に反映するには、次を実行します。

~~~bash
uv sync
~~~

他の人がプロジェクトを取得した場合は、通常次の流れで環境を再現できます。

~~~bash
uv sync
uv run main.py
~~~

## 8. 依存関係を確認する

依存関係の一覧は、次で確認できます。

~~~bash
uv tree
~~~

ロックファイルを更新するだけなら、次を実行します。

~~~bash
uv lock
~~~

uv.lock は通常、手動編集せず uv のコマンドで管理します。再現可能な環境を作るため、Git管理するプロジェクトでは uv.lock をコミットします。

## 9. 最初に実行するコマンドの例

新しい小規模プロジェクトを作成して、ライブラリを追加し、実行するまでの一連の流れです。

~~~bash
uv init --no-package --python 3.13 my-project
cd my-project

uv python pin 3.13
uv venv
uv add requests
uv add --dev pytest

uv run main.py
uv run python -c "import requests; print(requests.__version__)"
~~~

## よくある注意点

### uv run __init__.py で何も表示されない

次のように関数を定義しただけでは、main() は呼び出されません。

~~~python
def main():
    print("Hello")
~~~

直接実行するなら、次の処理も必要です。

~~~python
if __name__ == "__main__":
    main()
~~~

--no-package 構成では、基本的に main.py を作成して uv run main.py で実行します。

### Pythonバージョンのエラーが出る

次の2つを確認します。

~~~bash
cat .python-version
grep requires-python pyproject.toml
~~~

.python-version で指定したバージョンが、pyproject.toml の requires-python の範囲に含まれている必要があります。

### 仮想環境を有効化したのに別のPythonが使われる

確認には次を使います。

~~~bash
which python
python --version
uv run python --version
~~~

プロジェクトの環境を確実に使いたい場合は、python ではなく uv run python を使います。

## 参考

- uv公式: Creating projects
  https://docs.astral.sh/uv/concepts/projects/init/
- uv公式: Python versions
  https://docs.astral.sh/uv/concepts/python-versions/
- uv公式: Working on projects
  https://docs.astral.sh/uv/guides/projects/
- uv公式: Project structure and files
  https://docs.astral.sh/uv/concepts/projects/layout/

