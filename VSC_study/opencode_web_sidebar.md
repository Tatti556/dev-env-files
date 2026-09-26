---
title: VS CodeでOpenCode Web Sidebarを起動・停止する方法
aliases:
  - OpenCode Web Sidebarの使い方
tags:
  - vscode
  - opencode
  - setup
---

# VS CodeでOpenCode Web Sidebarを起動・停止する方法

## 概要

[OpenCode Web Sidebar](https://github.com/bmpenuelas/opencode-web-sidebar) は、OpenCodeのWeb UIをVS Codeのサイドバーに表示する拡張機能。

> [!important] 自動接続と自動起動は別の動作
> VS Code起動時、拡張機能は `http://localhost:4096` への接続を試みる。ただし、OpenCodeサーバー自体は自動起動しない。
>
> サーバーが停止している場合は `Disconnected` と表示されるため、手動で起動する必要がある。

## 最も簡単な起動方法

1. VS Codeで対象プロジェクトのフォルダーを開く。
2. `Ctrl+Shift+P` でコマンドパレットを開く。
3. 次のコマンドを実行する。

```text
OpenCode: Start OpenCode Web Server
```

画面にサーバー一覧が表示されている場合は、次の方法でも起動できる。

1. `Local Server` の **Manage** を開く。
2. **Start and Connect** をクリックする。
3. 必要に応じて上部の **Refresh** をクリックする。

正常に接続されると、接続状態が緑色になる。

## 停止方法

パネル上部の **Stop** をクリックするか、コマンドパレットから次を実行する。

```text
OpenCode: Stop OpenCode Web Server
```

この停止コマンドは、**現在のVS Codeセッションで拡張機能自身が起動したサーバーに対してのみ表示される**。

VS Codeを再起動すると、サーバープロセスが残っていても、拡張機能がサーバーの管理情報を失う場合がある。その場合、サーバーへ接続できていても、パネルの **Stop** やコマンドパレットの停止コマンドは表示されない。

### 停止コマンドが表示されない場合

最初に、ポート4096を使用しているプロセスを確認する。

```powershell
Get-NetTCPConnection -LocalPort 4096 -State Listen |
    Select-Object LocalAddress, LocalPort, OwningProcess
```

表示された `OwningProcess` の番号を使い、プロセス名を確認する。次の例ではプロセスIDを `12345` としている。

```powershell
Get-Process -Id 12345
```

OpenCodeまたは関連するプロセスであることを確認してから停止する。

```powershell
Stop-Process -Id 12345
```

停止できたことを確認する。

```powershell
Get-NetTCPConnection -LocalPort 4096 -State Listen -ErrorAction SilentlyContinue
```

何も表示されなければ、ポート4096で待ち受けていたサーバーは停止している。

> [!warning] プロセス名を確認してから停止する
> `OwningProcess` がOpenCodeのプロセスであることを `Get-Process` で確認する。別のアプリケーションがポート4096を使用している場合、そのプロセスを誤って停止しないように注意する。

ポート4096をOpenCodeだけが使用していると確認できている場合は、次の1行でも停止できる。

```powershell
Get-NetTCPConnection -LocalPort 4096 -State Listen |
    ForEach-Object { Stop-Process -Id $_.OwningProcess }
```

## パネルを閉じるだけの場合

サーバーを停止せず、OpenCodeの表示だけを閉じる場合は次を実行する。

```text
OpenCode: Close Panel
```

| 操作 | 結果 |
| --- | --- |
| `OpenCode: Close Panel` | パネルだけを閉じる。サーバーは動作を続ける |
| `OpenCode: Stop OpenCode Web Server` | OpenCodeサーバーを停止する。ただし、拡張機能が起動した場合のみ表示される |
| `OpenCode: Toggle Panel` | パネルの表示と非表示を切り替える |

## `Disconnected` と表示される理由

通常は、`http://localhost:4096` でOpenCodeサーバーが動作していないことを意味する。

拡張機能の `autoReconnect` 設定は、既に動作しているサーバーへの再接続を自動化する設定であり、サーバーを起動する設定ではない。拡張機能には、現時点で `autoStart` 設定はない。

したがって、次の流れは正常な動作となる。

1. **Stop** でOpenCodeサーバーを停止する。
2. VS Codeを終了する。
3. VS Codeを再度起動する。
4. サーバーが動作していないため `Disconnected` と表示される。
5. `OpenCode: Start OpenCode Web Server` を実行する。

## ターミナルから起動・停止する方法

拡張機能から起動できない場合は、VS Codeのターミナルで次を実行する。

```powershell
opencode web --port 4096
```

停止する場合は、このコマンドを実行しているターミナルで `Ctrl+C` を押す。

> [!note]
> ターミナルから起動したサーバーは、拡張機能の **Stop** では停止できない場合がある。その場合は、起動したターミナルで `Ctrl+C` を使用する。

## 起動できない場合の確認事項

### 1. OpenCodeがインストールされているか確認する

```powershell
opencode --version
```

バージョンが表示されない場合は、OpenCodeがインストールされていないか、実行ファイルに `PATH` が通っていない可能性がある。

### 2. ポート4096が使用されていないか確認する

```powershell
Get-NetTCPConnection -LocalPort 4096 -ErrorAction SilentlyContinue
```

別のプロセスがポート4096を使用している場合、OpenCodeサーバーを起動できないことがある。

### 3. 接続先を確認する

OpenCode Web Sidebarの標準接続先は次のURL。

```text
http://localhost:4096
```

VS Codeの設定で `OpenCode Sidebar` を検索し、登録されている `Local Server` のURLと起動コマンドを確認する。

標準の起動コマンドは次のとおり。

```text
opencode web --port 4096
```

## 関連リンク

- [OpenCode Web Sidebar - GitHub](https://github.com/bmpenuelas/opencode-web-sidebar)
- [OpenCode Web - 公式ドキュメント](https://opencode.ai/docs/web/)
