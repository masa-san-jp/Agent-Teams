# エージェントチーム

> AIが担う経営チーム。各エージェントが担当領域を自律的に運営し、
> 共通の行動指針とルーティング設計を共有する。

*最終更新: 2026-04-30*

---

## 設計思想

全エージェントが共有する3つの行動原則：

| 原則 | 説明 |
|----|----|
| **悪いニュースほど即時共有** | 問題は発見した瞬間にオーナーへ報告する。 |
| **投資対効果は両面評価** | すべての判断を「得られる利益」と「防げる損失」の両面で評価する。 |
| **目標への徹底コミット** | 自らの目標に執着し、達成まで諦めない。 |

---

## Aiko — AI人格システム

各エージェントに搭載可能な**人格レイヤー**。スキル・hooksがない環境でも CLAUDE.md 単独でフル動作するよう設計されている。

### モード

| モード | 説明 |
|--------|------|
| `origin` | リポジトリ管理者が定義したデフォルト人格 |
| `override` | ユーザーがカスタマイズした人格。INVARIANTS.md の不変条項を超えることはできない |

### コマンド

| コマンド | 動作 |
|---------|------|
| `/aiko-override [指示]` | アイコ（カスタマイズ）に切替。引数ありで人格を更新 |
| `/aiko-origin` | アイコ（オリジナル）に戻す |
| `/aiko-reset` | カスタマイズを削除し、オリジナルに完全リセット |
| `/aiko-diff` | origin と override の差分を表示 |
| `/aiko-export` | override 全文と再現手順を出力 |

### 設計方針

- **人格保護**：`aiko-origin.md` と `INVARIANTS.md` はリポジトリ管理者のみ変更可。ユーザーはコマンド経由でのみ override を変更できる
- **移植性**：CLAUDE.md 1ファイルで動作するため、任意のエージェントへ展開可能
- **永続性**：`mode` ファイルへの書き込みでセッションをまたいで状態を保持

現在の搭載エージェント：`agents`（汎用）・`logi-ops`

---

## エージェント一覧

| エージェント | 目的 | 主要ツール |
|---|---|---|
| `cfo-fpa` | キャッシュポジションを定め、現金を増やす | Google Drive MCP, gws CLI, freee API |
| `hr` | 人材の育成・定着・健康経営を通じて組織の持続的な成長基盤を構築し、「優秀な人材を輩出する企業」というポジショニングを実現する | WebSearch, Google Drive MCP, Bash |
| `logi-ops` | オペレーションを改善し続けるため、最適のリソース調達戦略を設計し、確実に実行する | gws CLI, Google Drive MCP, Google Calendar MCP |
| `marke-sales` | 売り上げトップラインを目標以上に維持し続け、トップロイヤルティ顧客を育成する | WebSearch, Google Drive MCP, gws CLI |
| `pr-brand` | 社会的価値があり独自性・唯一性のある広報・PR活動を通じてブランド価値を蓄積し、競争優位性を獲得する | WebSearch, Google Drive MCP, Bash |
| `r-d` | 既存ビジネスをディスラプトし、非線形な成長のきっかけとなる発明をする | WebSearch, Google Drive MCP, Bash |

---

## CFO+FP&A (`cfo-fpa`)

**目的:** キャッシュポジションを定め、現金を増やす

### 担当業務

- キャッシュフロー管理・予測
- 投資判断・ROI評価
- 予算策定・実績対比
- 財務KPIモニタリング（営業利益率・自己資本比率・労働生産性・有利子負債返済期間）
- シナリオ分析
- 外注費ROI評価
- ガバナンス遵守確認
- **freee試算表の取得**（`skills/freee_fetch.py` で PL・BS を workspace/input/ に保存）

### 戦術フレームワーク

1. キャッシュランウェイ監視 → 閾値割れで即報告・対策立案
2. 投資判断はROI・回収期間・リスク調整後リターンで機械的判定
3. 予算vs実績の差異分析（FP&A）、次期予測を毎回更新
4. 楽観・中立・悲観の3シナリオを常に提示

### 使用ツール

- Google Drive MCP（財務資料の読み書き）
- gws CLI（スプレッドシート操作）
- freee API（`skills/freee_client.py` 経由、トークンは `[config-path]`）

### サブエージェント委譲

タスクの種類に応じて適切なサブエージェントに委譲し、計算コストを最適化する。

| タスク種別 | サブエージェント | モデル |
|---|---|---|
| ファイル検索・ログ読み取り・input/確認 | `file-explorer` | Haiku |
| 作業ログの記録 | `log-writer` | Haiku |
| freee APIからの財務データ取得 | `freee-fetcher` | Haiku |
| KPI計算・予算実績対比・ROI算出 | `financial-analyzer` | Sonnet |
| 3シナリオ計画・複雑な投資判断・ガバナンス評価 | `scenario-planner` | Opus |

**判断に迷ったら Sonnet をデフォルトとし、データ取得・ファイル操作・ログ記録は必ず Haiku に落とす。**

### スキル一覧

- `anomaly_triage` — スキル: 財務異常値トリアージ (Anomaly Triage)
- `financial_analysis` — スキル: 財務分析レポート生成 (Financial Analysis Report)
- `financial_decision_adr` — スキル: 財務意思決定記録 (Financial Decision Record)
- `freee_fetch` — freee 試算表フェッチスクリプト
- `freee_setup` — freee OAuthセットアップスクリプト（初回のみ実行）
- `scenario_spec` — スキル: シナリオ分析仕様書 (Scenario Spec)

---

## HR (`hr`)

**目的:** 人材の育成・定着・健康経営を通じて組織の持続的な成長基盤を構築し、「優秀な人材を輩出する企業」というポジショニングを実現する

### 担当業務

- 人材育成計画の立案・研修設計・効果測定
- 定着率分析・離職リスクの早期発見
- エンゲージメントサーベイの設計・実施・分析
- 衛生委員会運営・ストレスチェック管理
- 労務管理（就業規則・36協定・各種届出）
- 助成金（キャリアアップ・両立支援等）の申請管理

### 使用ツール

- WebSearch（労務法規・助成金・HR施策の最新情報収集）
- Google Drive MCP（従業員データ・規程管理）
- Bash（データ集計・レポート自動化）

### サブエージェント委譲

| タスク種別 | サブエージェント | モデル |
|---|---|---|
| ファイル検索・ログ読み取り | `file-explorer` | Haiku |
| 作業ログの記録 | `log-writer` | Haiku |
| 労務法規・助成金・HR施策調査 | `web-researcher` | Sonnet |
| 規制・トレンドの深掘り検証 | `trend-analyst` | Opus |
| 調査結果のドキュメント化 | `knowledge-curator` | Sonnet |

### スキル一覧

- `labor_compliance_check` — Skill: labor_compliance_check

---

## Logistics+Ops (`logi-ops`)

**目的:** オペレーションを改善し続けるため、最適のリソース調達戦略を設計し、確実に実行する

### 担当業務

### オペレーション（メイン）
- 経理処理（freee/MF連携、請求書・明細のCSV変換）
- ファイル管理・命名規則統一
- 社内ドキュメント・ナレッジベース整備
- Google Driveファイル管理
- 業務プロセス標準化
- 管理系メール・カレンダー対応

### 法務（legal-counsel サブエージェントに委譲）
- 契約書一次レビュー・NDAトリアージ → `legal-counsel`
- 法令・判例調査・リスク妥当性評価 → `legal-counsel`
- 障害福祉指定基準・インボイス・電子帳簿保存法 → `legal-counsel`

### 労務（HRエージェントに委譲）
- 36協定・労働基準法の月次コンプライアンス → `agents/hr`
- キャリアアップ助成金・両立支援等助成金 → `agents/hr`

### 戦術フレームワーク

1. サプライチェーンマッピング → ヒト・モノ・カネのフローを可視化し、弱点を先手で補強
2. ボトルネック分析 → プロセスを計測し、律速箇所を特定して集中改善
3. リスクレジスター管理 → リスクを列挙・評価し、発生前に対策を打つ
4. 繰り返しタスクのスキル化・自動化

### 使用ツール

- gws CLI（Gmail/Drive/Sheets）
- Google Drive MCP
- Google Calendar MCP

### サブエージェント委譲

タスクの種類に応じて適切なサブエージェントに委譲し、計算コストを最適化する。

| タスク種別 | サブエージェント | モデル |
|---|---|---|
| ファイル検索・ログ読み取り・input/確認 | `file-explorer` | Haiku |
| 作業ログの記録 | `log-writer` | Haiku |
| ファイルリネーム・CSV変換・命名規則統一 | `doc-formatter` | Haiku |
| 繰り返し業務のスクリプト化・メール/カレンダー操作 | `process-automator` | Sonnet |
| 法務全般（契約・NDA・規制・法令調査） | `legal-counsel` | Sonnet |
| 法令解釈・重大リスクの深掘り判断 | `compliance-checker` | Opus |

**判断に迷ったら Sonnet をデフォルトとし、ファイル操作・変換・ログ記録は必ず Haiku に落とす。法令判断が絡む場合は必ず Opus を使う。**

### スキル一覧

- `annual_schedule_alert` — Skill: annual_schedule_alert
- `contract_review` — Skill: contract_review
- `disability_welfare_compliance` — Skill: disability_welfare_compliance
- `email_archive` — Skill: email_archive
- `email_triage` — Skill: email_triage
- `fetch_unread`
- `get_mail_body` — Skill: get_mail_body
- `invoice_ebookkeeping_check` — Skill: invoice_ebookkeeping_check
- `legal_risk_research` — Skill: legal_risk_research
- `nda_triage` — Skill: nda_triage
- `process_migration` — スキル: 業務プロセス移行 (Process Migration)
- `task_decomposition` — スキル: オペレーションタスク分解 (Task Decomposition)
- `task_priority_check` — Skill: task_priority_check

---

## Marketing+Sales (`marke-sales`)

**目的:** 売り上げトップラインを目標以上に維持し続け、トップロイヤルティ顧客を育成する

### 担当業務

- 競合・市場調査レポート作成
- SNS発信叩き台作成（オーナーのトーン・過去パターンを学習）
- コンテンツ戦略立案・素材作成
- 顧客インサイト調査・分析
- 案件・リード管理サポート
- カスタマーサクセス施策立案
- 調査結果のGoogle Drive保存

### 戦術フレームワーク

1. 顧客インサイト開拓 → 顧客の言語化されていないニーズを掘り起こし、コンテンツ・施策に転換
2. ロイヤルティラダー管理 → 顧客を階層化し、トップ層へのリソース集中投下
3. PDCA徹底 → 施策ごとに仮説→実施→計測→改善のサイクルを回す
4. パイプライン管理 → 案件ステータスを可視化し、CVR・リードタイムを継続改善

### 使用ツール

- WebSearch（市場調査・競合分析・トレンド収集）
- Google Drive MCP（資料保存・管理）
- gws CLI（ドキュメント作成）

### サブエージェント委譲

タスクの種類に応じて適切なサブエージェントに委譲し、計算コストを最適化する。

| タスク種別 | サブエージェント | モデル |
|---|---|---|
| ファイル検索・過去コンテンツ参照・ログ読み取り | `file-explorer` | Haiku |
| 作業ログの記録 | `log-writer` | Haiku |
| 競合調査・市場トレンド収集・Web情報収集 | `market-researcher` | Sonnet |
| SNS発信叩き台・コンテンツ草案作成 | `content-drafter` | Sonnet |
| 顧客インサイト深掘り・戦略立案・施策設計 | `insight-analyst` | Opus |

**判断に迷ったら Sonnet をデフォルトとし、ファイル確認・ログ記録は必ず Haiku に落とす。戦略・顧客インサイトの深い分析は必ず Opus を使う。**

### スキル一覧

- `campaign_spec` — スキル: 施策仕様書 (Campaign Spec)
- `research_sourcing` — スキル: リサーチ情報源管理 (Research Sourcing)

---

## PR+Brand (`pr-brand`)

**目的:** 社会的価値があり独自性・唯一性のある広報・PR活動を通じてブランド価値を蓄積し、競争優位性を獲得する

### 担当業務

- プレスリリース作成・配信
- ブランド戦略立案・ブランド監査
- 採用広報コンテンツ制作（SNS、オウンドメディア、求人票）
- メディアリレーション管理
- キャンペーン企画・効果測定
- 危機広報対応（クライシスコミュニケーション）

### 使用ツール

- WebSearch（メディア・SNS・競合動向調査）
- Google Drive MCP（コンテンツ管理・資料保存）
- Bash（データ集計・自動化スクリプト）

### サブエージェント委譲

| タスク種別 | サブエージェント | モデル |
|---|---|---|
| ファイル検索・ログ読み取り | `file-explorer` | Haiku |
| 作業ログの記録 | `log-writer` | Haiku |
| メディア・SNS・競合調査 | `web-researcher` | Sonnet |
| トレンド深掘り・反証検証 | `trend-analyst` | Opus |
| 調査結果のドキュメント化 | `knowledge-curator` | Sonnet |

---

## R&D (`r-d`)

**目的:** 既存ビジネスをディスラプトし、非線形な成長のきっかけとなる発明をする

### 担当業務

- AI・テクノロジートレンドの深掘り調査
- 業界・規制動向分析
- 新規事業・製品アイデアの調査・検証
- 技術実装サポート（スクリプト・自動化ツール開発）
- 知識ベース構築・管理
- 内部データ蓄積・インサイト抽出

### 戦術フレームワーク

1. 外部トレンドスキャン → 技術・業界・規制の変化を定期キャッチし、ディスラプション候補を特定
2. 内部インサイト蓄積 → 顧客・商品・サービスデータを蓄積し、自社固有の競争優位を発見
3. 仮説→テスト→評価→改善 → 小さくテストし、失敗を速く、学びを大きく
4. 知識グラフ構築 → 調査結果を繋げて構造化し、独自のインサイトレイヤーを育てる

### 使用ツール

- WebSearch（リサーチ・情報収集）
- Google Drive MCP（知識ベース管理）
- Bash（スクリプト開発・自動化）

### サブエージェント委譲

タスクの種類に応じて適切なサブエージェントに委譲し、計算コストを最適化する。

| タスク種別 | サブエージェント | モデル |
|---|---|---|
| ファイル検索・ログ読み取り・構造確認 | `file-explorer` | Haiku |
| 作業ログの記録 | `log-writer` | Haiku |
| Web調査・情報収集・URL取得 | `web-researcher` | Sonnet |
| スクリプト・自動化ツール開発 | `script-developer` | Sonnet |
| 調査結果のドキュメント化・スキル保存 | `knowledge-curator` | Sonnet |
| 技術・業界トレンドの深掘り検証 | `trend-analyst` | Opus |
| ディスラプション機会の戦略的評価 | `disruption-scout` | Opus |

**判断に迷ったら Sonnet をデフォルトとし、深い推論が不要な検索・記録タスクは必ず Haiku に落とす。**

### スキル一覧

- `automation_script_spec` — スキル: 自動化スクリプト仕様書 (Automation Script Spec)
- `google_workspace_mcp_setup` — スキル: Google Workspace MCP セットアップ (組織アカウント)
- `research_increment` — スキル: リサーチ・インクリメント (Research Increment)

---
