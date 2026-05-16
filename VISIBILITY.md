# Visibility — Agent-Teams

このリポジトリにおける **「公開（GitHub に同期）」** と **「非公開（ローカル限定）」** の境界を明示する仕様書です。`.gitignore` はこの仕様の実装であり、両者が乖離していたら `.gitignore` 側を修正してください。

リポジトリ：`https://github.com/masa-san-jp/Agent-Teams.git`

---

## 公開対象（GitHub に同期される）

- `README.md` / `README.en.md` — エージェントチーム公開窓口（設計思想・各エージェント解説）
- `VISIBILITY.md` — 本ファイル（公開境界の仕様）
- `LICENSE` — MIT License（Copyright (c) 2026 masa-san-jp）
- `CHANGELOG.md` — リリース履歴（SemVer）
- `reference/` — **配布パッケージ本体**（他組織が自社環境に導入できる汎用パック）
  - `INSTALL.md` / `README.md` / `ARCHITECTURE.md` / `DESIGN-PHILOSOPHY.md` / `SHARING.md`
  - `rules/` `meta-agents/` `skills/` `workflow-templates/` `config-templates/` `tools/` `_scripts/`
- `logs/` — 公開ログ（過去の試行錯誤・dev-log の sanitized 版）
- `.claude/scripts/visibility-check.sh` — 公開境界の自己検証スクリプト

---

## 非公開対象（gitignore で除外）

- OS / 言語ランタイム成果物（`.DS_Store`、`Thumbs.db`、`__pycache__/`、`*.pyc`）
- リポ固有 sensitivity パターン辞書（`**/.claude/sensitive-patterns.local.txt`）— 個人 / 案件固有のキーワードが入るためローカル限定
- 認証情報・個人作業領域・端末固有状態（一般的な慣行に準ずる）

---

## 境界の判断基準

新しいファイル・ディレクトリを足すときは次で判断：

| 質問 | Yes → 公開 | Yes → 非公開 |
|------|-----------|-------------|
| 他者が再利用する設計か？ | ✓ | |
| 個人固有の人格・履歴・認証か？ | | ✓ |
| 端末・環境ごとに異なる状態か？ | | ✓ |
| 共通ルール・スキル・ドキュメントか？ | ✓ | |

迷う場合は **非公開側（gitignore に追加）** を選び、後から公開へ昇格する方が安全。

---

## 関連リポジトリ

| リポ | 公開 | 用途 |
|------|:---:|------|
| `https://github.com/masa-san-jp/Agent-Teams` | ◯ | 本リポ。エージェントチームの公開窓口と配布パッケージ |
| `https://github.com/masa-san-jp/Agent-Aiko` | ◯ | Aiko（AI 人格システム）単体の公開配布リポ |
| `https://github.com/masa-san-jp/Agent-Lab` | × | 非公開の開発・運用実体（Teams 系も Aiko 系もここで開発） |

---

## 検証

`.gitignore` と本仕様の整合は以下で確認できます：

```bash
bash .claude/scripts/visibility-check.sh
```

加えて、user-global の Sensitivity Sentinel hook（`~/.claude/scripts/sensitivity-sentinel.sh`）が、書き込み時・push 時に個人情報パターンを自動検出します。

リポ固有の追加パターンは `.claude/sensitive-patterns.local.txt` に記述してください。

---

## 仕様変更時のチェックリスト

- [ ] 本ファイル（VISIBILITY.md）を更新
- [ ] `.gitignore` を本仕様と整合
- [ ] `bash .claude/scripts/visibility-check.sh` を実行して違反ゼロを確認
- [ ] 必要なら `.claude/sensitive-patterns.local.txt` にパターン追加
