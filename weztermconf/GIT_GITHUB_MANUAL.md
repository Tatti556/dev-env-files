# Git & GitHub 基本操作・連携マニュアル（初心者向け）

このドキュメントは、ローカル環境（PC）で管理している設定ファイルやコードを **GitHub** と連携・運用するための基本操作ガイドです。

---

## 1. 全体像の理解（Git と GitHub の関係）

Git では、ファイルが以下の 4 つの場所を移動しながら管理されます。

```text
[ あなたのPC (ローカル) ]
1. 作業ディレクトリ (Working Directory) : 実際にファイルを編集する場所
      │  git add
      ▼
2. ステージングエリア (Index / Staging) : コミットするファイルを一時的に並べる場所
      │  git commit
      ▼
3. ローカルリポジトリ (Local Repo)      : PC 内に履歴として保存された状態 (.git フォルダ)
      │
──────┼───────────────────────────── (ネットワーク経由)
      │  git push (送信)  /  git pull (取得)
      ▼
[ GitHub (リモート) ]
4. リモートリポジトリ (Remote Repo)    : クラウド上の保存先
```

---

## 2. 初期セットアップ・状況別の開始手順

開始するシチュエーションに合わせて、必要な手順を選んでください。

### 📌 パターン A: すでにローカルで Git 管理しているものを GitHub に繋ぐ（今回のケース）
ローカルで既にコミット済み（`.git` フォルダが存在する）の場合、**`git init` は不要** です。GitHub の空リポジトリと紐付けるだけで完了します。

```powershell
# 1. GitHub のリポジトリ URL を origin として登録（紐付け）
git remote add origin https://github.com/<ユーザー名>/<リポジトリ名>.git

# 2. 正しく登録できたか確認
git remote -v

# 3. GitHub へプッシュ（送信）
git push -u origin main
```

---

### 📌 パターン B: まだ Git 管理していないフォルダを新しく始める (`git init`)
まだ `.git` がない通常のフォルダを、新しく Git 管理にして GitHub に上げる場合の手順です。

```powershell
# 1. 該当フォルダで Git 管理を開始（.git フォルダが作成されます）
git init

# 2. ブランチ名を main に設定
git branch -M main

# 3. フォルダ内の全ファイルを登録して初回コミット
git add .
git commit -m "Initial commit"

# 4. GitHub のリポジトリ（空）を作成し、URL を紐付け
git remote add origin https://github.com/<ユーザー名>/<リポジトリ名>.git

# 5. GitHub へ初回プッシュ
git push -u origin main
```

---

### 📌 パターン C: GitHub 上のリポジトリを PC に複製して始める (`git clone`)
すでに GitHub にあるリポジトリを自分の PC にダウンロードして作業を始める場合です。

```powershell
git clone https://github.com/<ユーザー名>/<リポジトリ名>.git
```
*(自動的に `git init` やリモートの設定が行われます)*

---

## 3. 日常の基本作業サイクル（4ステップ）

設定ファイル（`wezterm.lua` など）を編集した後は、基本的に以下の **4 つのコマンド** を順番に実行します。

### ステップ 1: 状態の確認
どのファイルが変更・追加されたかを確認します。

```powershell
git status
```
- 赤色で表示されるファイル：変更されたが、まだステージングされていないファイル。

---

### ステップ 2: 変更の登録（ステージング）
コミット対象としてファイルを登録します。

```powershell
# すべての変更・新規ファイルをまとめて登録する場合
git add .

# 特定のファイルだけを登録する場合（例: wezterm.lua）
git add wezterm.lua
```

---

### ステップ 3: コミット（ローカルへ記録）
変更内容をローカルリポジトリに記録します。後から見返して分かりやすいメッセージを付けます。

```powershell
git commit -m "キーバインドの設定を変更"
```

> **コミットメッセージのコツ**
> - 「何を変更したか」を簡潔に書く（例: `フォントサイズを変更`, `プラグイン追加` など）

---

### ステップ 4: GitHub へ送信（プッシュ）
ローカルに記録したコミットを GitHub に送信してバックアップ・共有します。

```powershell
git push
```
*(初回に `-u origin main` でプッシュ済みであれば、2回目以降は `git push` だけで送信できます)*

---

## 4. GitHub から最新の変更を取り込む（Pull）

別の PC で作業した場合や、GitHub の Web 上で直接 README などを編集した場合は、ローカルに最新状態を取り込みます。

```powershell
git pull
```

---

## 5. 変更差分・履歴の確認

### 編集した内容（差分）を確認する
コミット前に「具体的にどこを書き換えたか」を行単位で確認できます。

```powershell
git diff
```

### 過去のコミット履歴を確認する
過去の履歴を 1 行ずつ見やすく表示します。

```powershell
git log --oneline
```
*(終了するにはキーボードの `q` を押します)*

---

## 6. ブランチを活用した安全な変更作業

大きな変更や実験的な設定を試すときは、メイン（`main`）とは別の「ブランチ（枝分かれ）」を作成して作業すると安全です。

### 1. 新しいブランチを作成して切り替える
```powershell
# "test-colorscheme" という名前のブランチを作成して移動
git switch -c test-colorscheme
```

### 2. 作業してコミット・プッシュ
```powershell
git add .
git commit -m "新しいカラースキームのテスト"
git push -u origin test-colorscheme
```

### 3. メインブランチに戻る
```powershell
git switch main
```

### 4. ブランチ一覧を確認する
```powershell
git branch
```

---

## 7. よくあるトラブルと解決策（Q&A）

### Q1. `git push` を実行したらエラー（rejected）が出た
**原因:** GitHub 側に、ローカルにまだ取り込んでいない新しいコミットが存在します。  
**解決策:** 先に `git pull` で取り込んでからプッシュします。
```powershell
git pull
git push
```

---

### Q2. 間違えて `git add` してしまったファイルを戻したい
**解決策:** コミット前であれば、ステージング状態を解除できます。
```powershell
# 特定のファイルのステージングを解除
git restore --staged <ファイル名>

# すべてのステージングを解除
git restore --staged .
```

---

### Q3. ファイルを編集したが、編集前の状態（最後のコミット状態）に戻したい
> ⚠️ **注意:** まだコミットしていないローカルの変更が消去されます。

```powershell
git restore <ファイル名>
```

---

### Q4. 直前のコミットメッセージを修正したい
```powershell
git commit --amend -m "正しいコミットメッセージ"
```

---

## 8. コマンド早見表（チートシート）

| コマンド | 説明 |
| :--- | :--- |
| `git remote add origin <URL>` | GitHub リポジトリをリモート先として登録 |
| `git push` | GitHub に変更を送信 |
| `git pull` | GitHub から最新の変更を取得 |
| `git status` | 現在の変更状態を確認 |
| `git add .` | すべての変更をステージング |
| `git commit -m "メッセージ"` | 変更をローカルに記録 |
| `git init` | まだ管理していないフォルダで新規 Git リポジトリを初期化 |
| `git clone <URL>` | リモートリポジトリを手元に複製 |
| `git diff` | まだステージングしていない変更差分を確認 |
| `git log --oneline` | コミット履歴を簡潔に一覧表示 |
| `git switch -c <ブランチ名>` | 新しいブランチを作成して移動 |
| `git switch <ブランチ名>` | 既存のブランチへ移動 |
| `git remote -v` | 設定されているリモートリポジトリを確認 |
