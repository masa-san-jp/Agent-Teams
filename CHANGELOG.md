# Changelog

すべての注目すべき変更を本ファイルに記録します。

このプロジェクトは [Keep a Changelog](https://keepachangelog.com/) に準拠し、[セマンティックバージョニング](https://semver.org/) を採用します。

## [Unreleased]

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
