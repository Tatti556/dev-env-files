---
created: 2026-08-16 13:42
type: howto
status: active
area: tech
topic: codex-skills
tags:
  - codex
  - agent-skills
  - kubuntu
  - nodejs
  - nvm
aliases:
  - Matt Pocock SkillsのCodex導入手順
  - KubuntuでのCodex Skills管理
  - mattpocock skills備忘録
author: T.I.
source:
  - https://github.com/mattpocock/skills
  - https://github.com/vercel-labs/skills
  - https://github.com/nvm-sh/nvm
---

# Matt Pocock SkillsをKubuntu上のCodexへ導入・管理する備忘録

## 結論

- Matt Pocock Skillsは、Kubuntuの**ChatGPTアプリではなくCodex CLIへ導入する**。
- Node.jsと`npx`がない場合は、nvm経由でNode.js LTSを導入してから`npx skills`を使用する。
- 今回は24個のMatt Pocock SkillsをCodex向けにグローバル導入した。
- Skill本体のグローバル導入は1回でよいが、`/setup-matt-pocock-skills`は**利用するリポジトリごとに1回**実行する。
- 追加、削除、更新、一覧確認はファイルの手作業ではなく`npx skills`で行う。

> [!warning] 対象の違い
> 本手順の導入先はCodex CLIである。ChatGPTアプリ本体へSkillを組み込む手順ではない。

## 導入前提

- OSはKubuntuである。
- シェルはzshを使用している。
- Codex CLIは導入済みである。
- 当初の確認結果では、Codexは`/home/tatti556/.local/bin/codex`に存在した。
- Node.jsと`npx`は未導入であったため、先にNode.js実行環境を準備した。

確認コマンドは次のとおりである。

```bash
which codex
node -v
npx -v
```

`codex`のパスが表示され、`node`または`npx`が`command not found`となる場合は、次項のnvm導入へ進む。

## Node.jsとnvmの導入

### 1. nvmを導入する

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash
```

zshの設定を読み直す。

```bash
source ~/.zshrc
```

nvmを確認する。

```bash
command -v nvm
nvm --version
```

`command -v nvm`で`nvm`が表示されれば利用可能である。表示されない場合は、ターミナルを開き直して再確認する。

### 2. Node.js LTSを導入する

```bash
nvm install --lts
```

導入後、Node.js、npm、npxを確認する。

```bash
node -v
npm -v
npx -v
```

3つともバージョンが表示されれば準備完了である。

## Skills一覧の事前確認

インストール前に、リポジトリ内で利用可能なSkillを一覧表示する。

```bash
npx skills@latest add mattpocock/skills --list
```

このコマンドは一覧確認のみであり、Skillをインストールしない。

## Codexへのグローバル導入

Kubuntu上のCodexで、複数のプロジェクトから利用できるようにグローバル導入する。

```bash
npx skills@latest add mattpocock/skills -g -a codex
```

- `-g`はユーザー単位のグローバル導入を指定する。
- `-a codex`は対象エージェントをCodexに限定する。
- 表示された選択画面では、SpaceキーでSkillを選択し、Enterキーで確定する。
- `General`ではなく、主に`Mattpocock Skills`側から選択した。

> [!info] 保存先の確認方法
> 今回の完了表示では、24個が`~/.agents/skills/<skill名>`へ`copied`として記録された。会話中には`~/.codex/skills`という案内もあったが、実際の配置やリンク方式はskills CLIのバージョンと導入方式で変わり得る。ディレクトリを手作業で管理せず、`npx skills list -g -a codex`の結果を正とする。

## 最終導入結果：24 Skills

最終の`Installed 24 skills`表示に含まれたSkillは次のとおりである。

1. `ask-matt`
2. `code-review`
3. `codebase-design`
4. `diagnosing-bugs`
5. `domain-modeling`
6. `grill-me`
7. `grill-with-docs`
8. `grilling`
9. `handoff`
10. `implement`
11. `improve-codebase-architecture`
12. `prototype`
13. `research`
14. `resolving-merge-conflicts`
15. `setup-matt-pocock-skills`
16. `tdd`
17. `teach`
18. `to-questionnaire`
19. `to-spec`
20. `to-tickets`
21. `triage`
22. `wait-what`
23. `wizard`
24. `writing-for-agents`

選択画面には`wayfinder`も含まれていたが、最終の24個の完了一覧には表示されなかった。このため、本備忘録では導入済みとして数えない。必要な場合は一覧確認後に個別追加する。

## 主要Skillの用途

| Skill | 主な用途 |
|---|---|
| `ask-matt` | 状況に合うSkillや作業フローを案内する。 |
| `setup-matt-pocock-skills` | リポジトリごとのissue tracker、triageラベル、ドメイン文書配置を初期設定する。 |
| `grilling` | 計画、判断、アイデアを厳しく質問して弱点を洗い出す。 |
| `grill-me` | 計画や設計を質問形式で具体化する。内部で`grilling`を利用するため、関連Skillを併せて導入する。 |
| `grill-with-docs` | 計画や設計を質問で具体化しながら、ADRや用語集等の文書も作成する。 |
| `to-spec` | 現在の会話を仕様へ整理し、設定済みのissue trackerへ公開する。 |
| `to-tickets` | 計画や仕様を、依存関係付きの実装チケットへ分解する。 |
| `implement` | 仕様またはチケットに基づいて実装する。 |
| `tdd` | red-green-refactorを用いて、テスト先行で機能追加や修正を進める。 |
| `diagnosing-bugs` | 難しい不具合や性能低下を、診断ループで切り分ける。 |
| `code-review` | 基準点以降の変更を、リポジトリ規約と仕様適合の両面から確認する。 |
| `codebase-design` | 深いモジュール、境界、インターフェース、テスト容易性を設計する。 |
| `domain-modeling` | 用語、`CONTEXT.md`、ADRを通じてドメインモデルを整理する。 |
| `improve-codebase-architecture` | コードベースの構造改善候補を調査し、レポート化して検討する。 |
| `prototype` | 設計上の疑問に答えるため、捨てる前提の試作を作る。 |
| `research` | 信頼性の高い一次情報を調査し、Markdownへ記録する。 |
| `triage` | issueや外部PRを分類、検証し、実行可能なbriefへ整える。 |
| `resolving-merge-conflicts` | 進行中のGit mergeまたはrebase競合を解決する。 |
| `handoff` | 会話を別のエージェントが引き継げる文書へ圧縮する。 |
| `teach` | ワークスペース内の概念やSkillを利用者へ説明する。 |
| `to-questionnaire` | 自分だけでは決められない事項を、他者回答用の質問票へ変換する。 |
| `wait-what` | 直前の説明が伝わらなかった場合に、内容を組み直して説明する。 |
| `wizard` | 認証情報設定等、人間だけが実行できる手順を対話型bash wizardへする。 |
| `writing-for-agents` | Skill、`AGENTS.md`、`CLAUDE.md`等のエージェント向け文書を作成・編集する。 |

## find-skillsの扱い

`find-skills`はMatt Pocock Skillsの24個には含まれない。`npx skills`を提供する側の補助Skillであり、用途に合う公開Skillの発見と提案を支援する。

インストール完了後に次の一回限りの確認が表示された。

```text
Install the find-skills skill?
```

今後ほかのSkillを探す場合は`Yes`を選択してよい。

- 導入しただけで、ほかのSkillが自動的に大量インストールされるわけではない。
- 実際の追加は、候補を確認したうえで別途実行する。
- 不要になった場合は削除できる。

```bash
npx skills remove -g -a codex find-skills
```

CLIから直接検索する場合は次を使用する。

```bash
npx skills find
npx skills find typescript
```

## 導入後の一覧確認

導入結果は次のコマンドで確認する。

```bash
npx skills list -g -a codex
```

短縮形も使用できる。

```bash
npx skills ls -g -a codex
```

確認項目は次のとおりである。

- 対象がCodexになっているか。
- 24個のSkillがグローバル導入として表示されるか。
- `find-skills`を選択した場合は追加表示されるか。
- `wayfinder`が必要な場合、導入済みとして表示されるか。

## Skillの追加・削除・更新

### 追加

対話画面から追加する。

```bash
npx skills@latest add mattpocock/skills -g -a codex
```

Skill名を指定して1個追加する。

```bash
npx skills@latest add mattpocock/skills \
  --skill research \
  -g \
  -a codex
```

複数追加する。

```bash
npx skills@latest add mattpocock/skills \
  --skill research \
  --skill wayfinder \
  -g \
  -a codex
```

### 削除

1個削除する。

```bash
npx skills remove -g -a codex research
```

複数削除する。

```bash
npx skills remove -g -a codex research wayfinder
```

対話画面から削除対象を選択する。

```bash
npx skills remove -g
```

### 更新

グローバルSkillを更新する。

```bash
npx skills update -g
```

特定のSkillを更新する。

```bash
npx skills update research
```

### 一覧確認

```bash
npx skills list -g -a codex
```

## リポジトリごとの初期設定

グローバル導入後、実際に利用するリポジトリへ移動してCodexを起動する。

```bash
cd ~/Projects/対象プロジェクト
codex
```

Codex内で次を実行する。

```text
/setup-matt-pocock-skills
```

> [!important] 実行回数
> `setup-matt-pocock-skills`は、ほかのengineering Skillを初めて使う前に、リポジトリごとに1回実行する。日常的に繰り返す処理ではない。issue trackerを切り替える場合や設定を最初から作り直す場合のみ再実行する。

主な設定内容は次のとおりである。

- issue trackerの場所を決める。
- triageで使用するラベル名を決める。
- `CONTEXT.md`やADR等のドメイン文書配置を決める。
- ほかのengineering Skillが参照する設定をリポジトリ内へ記録する。

## Security Risk表示の扱い

インストール前には`Security Risk Assessments`が表示され、複数の検査結果やalert件数、risk評価を確認できる。

> [!warning] 安全性の判断
> `Safe`または`Low Risk`は無条件の安全保証ではない。Skillはエージェント権限でコマンド実行やファイル操作を指示できるため、利用前に内容を確認する。

確認方針は次のとおりである。

1. 配布元が意図した`mattpocock/skills`であることを確認する。
2. alertまたはMedium以上の表示があるSkillは、`SKILL.md`と参照スクリプトを確認する。
3. 外部通信、シェルコマンド、認証情報、ファイル削除・上書きに関する指示を確認する。
4. 内容を理解できないSkillは、確認が終わるまで導入または実行しない。
5. 不要なSkillは入れず、使用しないものは`npx skills remove`で整理する。
6. リポジトリの重要データはGit等で復旧できる状態にしてから使用する。

検査エンジン間で評価が異なる場合は、最も低い評価だけを採用せず、alertの具体的内容を確認して判断する。

## 注意点

- npmのメジャーアップデート通知は、Skills導入とは別件である。導入作業中に同時更新する必要はない。
- `~/.agents/skills`や`~/.codex/skills`を直接削除せず、原則として`npx skills remove`を使う。
- Skill同士に連携または依存がある。例として`grill-me`は`grilling`を利用する。
- グローバル導入は、すべてのリポジトリを同じ設定にすることを意味しない。リポジトリ固有設定は`setup-matt-pocock-skills`で作成する。
- 導入後にCodexがSkillを認識しない場合は、Codexを再起動し、`npx skills list -g -a codex`と実際の配置を確認する。
- `wayfinder`は最終導入一覧で確認できていない。必要な場合は個別追加する。

## 最小コマンド集

```bash
# Node.js環境の確認
node -v
npm -v
npx -v

# 利用可能なSkillの一覧
npx skills@latest add mattpocock/skills --list

# Codexへグローバル導入
npx skills@latest add mattpocock/skills -g -a codex

# 導入済みSkillの一覧
npx skills list -g -a codex

# 対話式の削除
npx skills remove -g

# グローバルSkillの更新
npx skills update -g
```

## 出典

- [Matt Pocock Skills](https://github.com/mattpocock/skills)
- [setup-matt-pocock-skillsの説明](https://github.com/mattpocock/skills/blob/main/docs/engineering/setup-matt-pocock-skills.md)
- [skills CLI](https://github.com/vercel-labs/skills)
- [nvm](https://github.com/nvm-sh/nvm)

## 前提・不足情報

- 本文は2026-08-16 13:42 JST時点の会話内容と一次資料に基づく。
- skills CLIの将来バージョンでは、保存先、表示、オプションが変更される可能性がある。
- `find-skills`で`Yes`を確定した後の最終一覧は会話内で未提示であるため、実際の導入有無は一覧コマンドによる確認が必要である。
- `wayfinder`は選択画面には含まれたが、最終の24個の完了一覧には含まれなかったため、導入状態は追加確認が必要である。

