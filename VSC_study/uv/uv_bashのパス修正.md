原因は、`uv` が未インストールなのではなく、インストール先が `PATH` に入っていないことです。

確認した実体:

```text
C:\Users\tatti\.local\bin\uv.exe
uv 0.12.5
```

## 一時的に実行する

現在の Git Bash で次を実行してください。

```bash
export PATH="$HOME/.local/bin:$PATH"
uv --version
uv run uv-test00
```

`pyproject.toml` の定義は以下なので、コマンド名は `uv-test00` が正解です。

```toml
[project.scripts]
uv-test00 = "uv_test00:main"
```

## 永続的に修正する

Git Bash で次を実行します。

```bash
"$HOME/.local/bin/uv.exe" tool update-shell
```

その後、VS Codeのターミナルをすべて閉じて、新しいGit Bashを開いてください。これは `uv` 公式のPATH設定用コマンドです。[uv公式ドキュメント](https://docs.astral.sh/uv/concepts/tools/)

確認:

```bash
which uv
uv --version
uv run uv-test00
```

期待される `which uv` の結果:

```text
/c/Users/tatti/.local/bin/uv
```

- 変更内容: なし（診断のみ）
- 変更ファイル: なし
- 検証結果: 一時的にPATHを追加するとGit Bashで `uv 0.12.5` を認識
- 残る点: `uv run` 自体は、仮想環境作成や依存関係取得を伴う可能性があるため未実行です


---

スクリーンショットの入力値は正しいですが、有効な `PATH` には反映されていません。

確認した保存状態では、ユーザー／システム双方の `PATH` に `C:\Users\tatti\.local\bin` が存在しません。環境変数画面では、手前の「OK」に続いて背面の「環境変数」画面でも「OK」を押して確定する必要があります。

まずGit Bashで確実に直すなら、以下を実行してください。

```bash
code ~/.bash_profile
```

開いたファイルに次の1行を保存します。

```bash
export PATH="$HOME/.local/bin:$PATH"
```

ターミナルへ反映します。

```bash
source ~/.bash_profile
hash -r
which uv
uv --version
```

期待結果:

```text
/c/Users/tatti/.local/bin/uv
uv 0.12.5 ...
```

続いてプロジェクトを実行します。

```bash
cd ~/Documents/011_coding/03_product/uv-test00
uv run uv-test00
```

Windows環境変数側を再確認する場合は、スタートメニューからPowerShellを新規起動し、次を実行してください。

```powershell
[Environment]::GetEnvironmentVariable("Path", "User") -split ";"
```

一覧に次がなければ、環境変数画面での変更が保存されていません。

```text
C:\Users\tatti\.local\bin
```

- 変更内容: なし
- 検証結果: `uv.exe` は存在するが、有効なユーザー／システム／Git Bashの全PATHから欠落
- 推奨対応: `~/.bash_profile` へPATHを明示的に追加
- 残る点: Windows環境変数画面の変更が保存されなかった理由自体は特定できていません
