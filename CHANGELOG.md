# Changelog

すべての注目すべき変更を本ファイルに記録します。

このプロジェクトは [Keep a Changelog](https://keepachangelog.com/) に準拠し、[セマンティックバージョニング](https://semver.org/) を採用します。

## [Unreleased]

## [0.1.2] - 2026-05-17

### Fixed

社内検証（deploy-007、`Agent-Lab/architecture/2026-05-17-deploy-007-internal-test.md`）で発見された 8 件の findings を反映。

**Critical（受け取り側が確実に詰まる zsh 非互換の解消）**
- **F2 / F3**: `for agent in $AGENTS` を zsh で word-split しない問題を全面修正。配列構文 `AGENTS=(...)` + `"${AGENTS[@]}"` に統一。Python に渡す場合は `TEAM_AGENTS_STR` env var 経由。macOS 標準シェル（zsh）受け取り側でも動作。

**High（UX 改善）**
- **F4**: Section 6 で `AGENTS.md` の `{{ORG_REPO_PATH}}` と `spec.json` の `{{ORG_REPO_NAME}}` / `{{ORG_NAME}}` を Python 置換で自動化。中間 check の false-positive を削減
- **F8**: `check-placeholders.sh` に `--receiver` モードを追加（既存 `--strict` と同義のエイリアス）。受け取り側用途を明示し、LEAK パターン（正しい絶対パスの誤検出）を意図的にスキップ。`Section 11-5` MANDATORY check と Troubleshooting も `--receiver` に統一

**Medium**
- **F5**: Section 7-3 の Python heredoc を `<<'PY'`（クォート版）に変更。shell substitution への依存を排除
- **F7**: Section 10 で `YYYY-MM-DD` と `<ORG_NAME>` を Python 置換で自動化

**Low**
- **F1**: Section 0-1 に 6 項目の質問テンプレを明示
- **F6**: Section 8 の `.gitignore` 追記を `# === BEGIN agent-team ===` / `# === END agent-team ===` マーカー付きにし、再実行時の二重追記を防止
- (bonus) **rules/hooks.md** の例示中の `{{ORG_REPO_PATH}}` を `<your-org-repo>` に変更。受け取り側の receiver check 誤検出を回避

### Verification

社内検証（マサさんが「初めて kit を受け取った Claude Code」のふりをして実走）：
- 修正前：受け取り側の最終 check で 17 件の検出（false-positive 含む）、Section 1 の for ループが zsh で**確実に詰まる**
- 修正後：受け取り側の最終 check は 13 件のみ（すべて `spec.json` の意図的な手編集対象 `{{AGENT_*_NAME}}` 系）、zsh / bash 両対応

## [0.1.1] - 2026-05-16

### Added

- `LICENSE`（MIT、Copyright (c) 2026 masa-san-jp）— v0.1.0 はライセンス未設定で受け取り側の利用権が不明確だったため、配布パッケージとして使える状態に修正
- README.md 末尾に License 言及セクション
- VISIBILITY.md の公開対象に LICENSE を明記

## [0.1.0] - 2026-05-16

### Added

- 初版リリース。配布パッケージ `reference/` を同梱：
  - グローバル規約 8 ファイル（`reference/rules/`）— coding-style / git-workflow / testing / security / patterns / performance / hooks / agents
  - メタエージェント 4 種（`reference/meta-agents/`）— reviewer / scout / lab / janitor
  - 多エージェント運用スキル 8 件（`reference/skills/`）— agent-call / delegate-suggest / peer-inbox / codex / meta / run-meta-pending / startup / teardown
  - ワークフローテンプレート 6 件（`reference/workflow-templates/`）— peer_review / self_review / idea_refine / context_engineering / planning_and_task_breakdown / task_handoff
  - 設定テンプレート 5 件（`reference/config-templates/`）— AGENTS.md / spec.json / rules.json / CLAUDE.md / scout_sources.json
  - 同梱スクリプト 3 本（`reference/tools/`）— agent-call.sh / peer-inbox.sh / meta-check.sh（すべて完全実装）
  - プレースホルダ・個人情報漏洩検出スクリプト（`reference/_scripts/check-placeholders.sh`）
- 受け取り側 Claude Code への導入指示書 `reference/INSTALL.md`（Section 0〜12 + Troubleshooting、Codex 第二意見レビューを反映済）
- 設計思想・配布留意事項のドキュメント（`reference/DESIGN-PHILOSOPHY.md` / `reference/SHARING.md`）
- README.md にクイックスタート（Reference Pack 誘導）セクションを追加

### Notes

- `meta-check.sh` は `META_CHECK_REPO_NAME` 環境変数でリポ絞り込みを制御する設計（sed による分岐改変は廃止）
- `agent-call.sh` / `peer-inbox.sh` は `WORKPLACE_ROOT` 環境変数を期待（または `git rev-parse` で自動解決）
- 配布前検証：`check-placeholders.sh` 通常モードで 0 件、strict モードで 149 件（すべて意図的なテンプレート箇所）
