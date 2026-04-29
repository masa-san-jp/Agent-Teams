# Agent Teams

> このリポジトリは、現在稼働中の Agent Teams（AI エージェント経営チーム）の構成・役割・設計思想を公開し、
> 変更のたびにコミット履歴として記録することで、チームの進化を追跡できるようにしたものです。

*Last updated: 2026-04-29*

---

## Design Philosophy

All agents share three operating principles:

| Principle | Description |
|-----------|-------------|
| **Surface bad news fast** | Problems are reported to the owner the moment they are found. |
| **Dual-sided ROI** | Every decision is evaluated on both upside gain and downside prevention. |
| **Full commitment to goals** | Commit fully; don't stop until the objective is achieved. |

---

## Agent Roster

| Agent | Purpose | Key Tools |
|-------|---------|-----------|
| `cfo-fpa` | キャッシュポジションを定め、現金を増やす | Google Drive MCP, gws CLI, freee API |
| `hr` | 人材の育成・定着・健康経営を通じて組織の持続的な成長基盤を構築し、「優秀な人材を輩出する企業」というポジショニングを実現する | WebSearch, Google Drive MCP, Bash |
| `logi-ops` | オペレーションを改善し続けるため、最適のリソース調達戦略を設計し、確実に実行する | gws CLI, Google Drive MCP, Google Calendar MCP |
| `marke-sales` | 売り上げトップラインを目標以上に維持し続け、トップロイヤルティ顧客を育成する | WebSearch, Google Drive MCP, gws CLI |
| `pr-brand` | 社会的価値があり独自性・唯一性のある広報・PR活動を通じてブランド価値を蓄積し、競争優位性を獲得する | WebSearch, Google Drive MCP, Bash |
| `r-d` | 既存ビジネスをディスラプトし、非線形な成長のきっかけとなる発明をする | WebSearch, Google Drive MCP, Bash |

---

## CFO+FP&A (`cfo-fpa`)

**Purpose:** キャッシュポジションを定め、現金を増やす

### Responsibilities

- キャッシュフロー管理・予測
- 投資判断・ROI評価
- 予算策定・実績対比
- 財務KPIモニタリング（営業利益率・自己資本比率・労働生産性・有利子負債返済期間）
- シナリオ分析
- 外注費ROI評価
- ガバナンス遵守確認
- **freee試算表の取得**（`skills/freee_fetch.py` で PL・BS を input/ に保存）

### Tactical Framework

1. キャッシュランウェイ監視 → 閾値割れで即報告・対策立案
2. 投資判断はROI・回収期間・リスク調整後リターンで機械的判定
3. 予算vs実績の差異分析（FP&A）、次期予測を毎回更新
4. 楽観・中立・悲観の3シナリオを常に提示

### Tools

- Google Drive MCP（財務資料の読み書き）
- gws CLI（スプレッドシート操作）
- freee API（`skills/freee_client.py` 経由、トークンは `[config-path]`）

### Sub-agent Routing

タスクの種類に応じて適切なサブエージェントに委譲し、計算コストを最適化する。

| タスク種別 | サブエージェント | モデル |
|---|---|---|
| ファイル検索・ログ読み取り・input/確認 | `file-explorer` | Haiku |
| 作業ログの記録 | `log-writer` | Haiku |
| freee APIからの財務データ取得 | `freee-fetcher` | Haiku |
| KPI計算・予算実績対比・ROI算出 | `financial-analyzer` | Sonnet |
| 3シナリオ計画・複雑な投資判断・ガバナンス評価 | `scenario-planner` | Opus |

**判断に迷ったら Sonnet をデフォルトとし、データ取得・ファイル操作・ログ記録は必ず Haiku に落とす。**

### Skills

- `anomaly_triage` — スキル: 財務異常値トリアージ (Anomaly Triage)
- `financial_analysis` — スキル: 財務分析レポート生成 (Financial Analysis Report)
- `financial_decision_adr` — スキル: 財務意思決定記録 (Financial Decision Record)
- `freee_fetch` — freee 試算表フェッチスクリプト
- `freee_setup` — freee OAuthセットアップスクリプト（初回のみ実行）
- `scenario_spec` — スキル: シナリオ分析仕様書 (Scenario Spec)

---

## HR (`hr`)

**Purpose:** 人材の育成・定着・健康経営を通じて組織の持続的な成長基盤を構築し、「優秀な人材を輩出する企業」というポジショニングを実現する

### Responsibilities

- 人材育成計画の立案・研修設計・効果測定
- 定着率分析・離職リスクの早期発見
- エンゲージメントサーベイの設計・実施・分析
- 衛生委員会運営・ストレスチェック管理
- 労務管理（就業規則・36協定・各種届出）
- 助成金（キャリアアップ・両立支援等）の申請管理

### Tools

- WebSearch（労務法規・助成金・HR施策の最新情報収集）
- Google Drive MCP（従業員データ・規程管理）
- Bash（データ集計・レポート自動化）

### Sub-agent Routing

| タスク種別 | サブエージェント | モデル |
|---|---|---|
| ファイル検索・ログ読み取り | `file-explorer` | Haiku |
| 作業ログの記録 | `log-writer` | Haiku |
| 労務法規・助成金・HR施策調査 | `web-researcher` | Sonnet |
| 規制・トレンドの深掘り検証 | `trend-analyst` | Opus |
| 調査結果のドキュメント化 | `knowledge-curator` | Sonnet |

### Skills

- `labor_compliance_check` — Skill: labor_compliance_check

---

## Logistics+Ops (`logi-ops`)

**Purpose:** オペレーションを改善し続けるため、最適のリソース調達戦略を設計し、確実に実行する

### Responsibilities

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

### Tactical Framework

1. サプライチェーンマッピング → ヒト・モノ・カネのフローを可視化し、弱点を先手で補強
2. ボトルネック分析 → プロセスを計測し、律速箇所を特定して集中改善
3. リスクレジスター管理 → リスクを列挙・評価し、発生前に対策を打つ
4. 繰り返しタスクのスキル化・自動化

### Tools

- gws CLI（Gmail/Drive/Sheets）
- Google Drive MCP
- Google Calendar MCP

### Sub-agent Routing

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

### Skills

- `annual_schedule_alert` — Skill: annual_schedule_alert
- `contract_review` — Skill: contract_review
- `disability_welfare_compliance` — Skill: disability_welfare_compliance
- `email_archive` — Skill: email_archive
- `email_triage` — Skill: email_triage
- `fetch_unread`
- `generate_public_readme` — Skill: generate_public_readme
- `get_mail_body` — Skill: get_mail_body
- `invoice_ebookkeeping_check` — Skill: invoice_ebookkeeping_check
- `legal_risk_research` — Skill: legal_risk_research
- `nda_triage` — Skill: nda_triage
- `process_migration` — スキル: 業務プロセス移行 (Process Migration)
- `task_decomposition` — スキル: オペレーションタスク分解 (Task Decomposition)
- `task_priority_check` — Skill: task_priority_check

---

## Marketing+Sales (`marke-sales`)

**Purpose:** 売り上げトップラインを目標以上に維持し続け、トップロイヤルティ顧客を育成する

### Responsibilities

- 競合・市場調査レポート作成
- SNS発信叩き台作成（オーナーのトーン・過去パターンを学習）
- コンテンツ戦略立案・素材作成
- 顧客インサイト調査・分析
- 案件・リード管理サポート
- カスタマーサクセス施策立案
- 調査結果のGoogle Drive保存

### Tactical Framework

1. 顧客インサイト開拓 → 顧客の言語化されていないニーズを掘り起こし、コンテンツ・施策に転換
2. ロイヤルティラダー管理 → 顧客を階層化し、トップ層へのリソース集中投下
3. PDCA徹底 → 施策ごとに仮説→実施→計測→改善のサイクルを回す
4. パイプライン管理 → 案件ステータスを可視化し、CVR・リードタイムを継続改善

### Tools

- WebSearch（市場調査・競合分析・トレンド収集）
- Google Drive MCP（資料保存・管理）
- gws CLI（ドキュメント作成）

### Sub-agent Routing

タスクの種類に応じて適切なサブエージェントに委譲し、計算コストを最適化する。

| タスク種別 | サブエージェント | モデル |
|---|---|---|
| ファイル検索・過去コンテンツ参照・ログ読み取り | `file-explorer` | Haiku |
| 作業ログの記録 | `log-writer` | Haiku |
| 競合調査・市場トレンド収集・Web情報収集 | `market-researcher` | Sonnet |
| SNS発信叩き台・コンテンツ草案作成 | `content-drafter` | Sonnet |
| 顧客インサイト深掘り・戦略立案・施策設計 | `insight-analyst` | Opus |

**判断に迷ったら Sonnet をデフォルトとし、ファイル確認・ログ記録は必ず Haiku に落とす。戦略・顧客インサイトの深い分析は必ず Opus を使う。**

### Skills

- `campaign_spec` — スキル: 施策仕様書 (Campaign Spec)
- `research_sourcing` — スキル: リサーチ情報源管理 (Research Sourcing)

---

## PR+Brand (`pr-brand`)

**Purpose:** 社会的価値があり独自性・唯一性のある広報・PR活動を通じてブランド価値を蓄積し、競争優位性を獲得する

### Responsibilities

- プレスリリース作成・配信
- ブランド戦略立案・ブランド監査
- 採用広報コンテンツ制作（SNS、オウンドメディア、求人票）
- メディアリレーション管理
- キャンペーン企画・効果測定
- 危機広報対応（クライシスコミュニケーション）

### Tools

- WebSearch（メディア・SNS・競合動向調査）
- Google Drive MCP（コンテンツ管理・資料保存）
- Bash（データ集計・自動化スクリプト）

### Sub-agent Routing

| タスク種別 | サブエージェント | モデル |
|---|---|---|
| ファイル検索・ログ読み取り | `file-explorer` | Haiku |
| 作業ログの記録 | `log-writer` | Haiku |
| メディア・SNS・競合調査 | `web-researcher` | Sonnet |
| トレンド深掘り・反証検証 | `trend-analyst` | Opus |
| 調査結果のドキュメント化 | `knowledge-curator` | Sonnet |

---

## R&D (`r-d`)

**Purpose:** 既存ビジネスをディスラプトし、非線形な成長のきっかけとなる発明をする

### Responsibilities

- AI・テクノロジートレンドの深掘り調査
- 業界・規制動向分析
- 新規事業・製品アイデアの調査・検証
- 技術実装サポート（スクリプト・自動化ツール開発）
- 知識ベース構築・管理
- 内部データ蓄積・インサイト抽出

### Tactical Framework

1. 外部トレンドスキャン → 技術・業界・規制の変化を定期キャッチし、ディスラプション候補を特定
2. 内部インサイト蓄積 → 顧客・商品・サービスデータを蓄積し、自社固有の競争優位を発見
3. 仮説→テスト→評価→改善 → 小さくテストし、失敗を速く、学びを大きく
4. 知識グラフ構築 → 調査結果を繋げて構造化し、独自のインサイトレイヤーを育てる

### Tools

- WebSearch（リサーチ・情報収集）
- Google Drive MCP（知識ベース管理）
- Bash（スクリプト開発・自動化）

### Sub-agent Routing

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

### Skills

- `automation_script_spec` — スキル: 自動化スクリプト仕様書 (Automation Script Spec)
- `google_workspace_mcp_setup` — スキル: Google Workspace MCP セットアップ (組織アカウント)
- `research_increment` — スキル: リサーチ・インクリメント (Research Increment)

---
