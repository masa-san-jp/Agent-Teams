# Visibility — Agent-Teams

このリポジトリにおける **「公開（GitHub に同期）」** と **「非公開（ローカル限定）」** の境界を明示する仕様書です。`.gitignore` はこの仕様の実装であり、両者が乖離していたら `.gitignore` 側を修正してください。

リポジトリ：`https://github.com/masa-san-jp/Agent-Teams.git`

---

## 公開対象（GitHub に同期される）

> **TODO: ここを各リポジトリの実情に合わせて埋める**
>
> 例：
> - ソースコード（`src/`、`lib/` 等）
> - ドキュメント（`README.md`、`docs/`、`VISIBILITY.md`）
> - 設定の雛形（`.example` 付きのファイル）
> - 共有スキル・テンプレート（`.claude/skills/`、`templates/` 等）
>
> 削除して、実際の公開対象のリストに置き換えてください。

---

## 非公開対象（gitignore で除外）

> **TODO: ここを各リポジトリの実情に合わせて埋める**
>
> 例：
> - 認証情報（`*.local.json`、`credentials.json`、`token.json`）
> - 個人作業領域（`local-workspace/`）
> - 端末固有の状態（`.last-run-*`、`.cache/`）
> - 個人カスタマイズ（`session-state/auto.jsonl`、`session-state/current.md`）
> - OS / 言語ランタイム成果物（`.DS_Store`、`__pycache__/`、`node_modules/`）

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

> **TODO: 兄弟リポ・派生リポがあれば記載**
>
> 例：
> | リポ | 用途 |
> |------|------|
> | `https://github.com/<owner>/<related-repo>` | 開発ログ／設計メモ |

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
