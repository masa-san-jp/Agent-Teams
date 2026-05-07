#!/usr/bin/env bash
# visibility-check — Agent-Teams
#
# 公開／非公開の境界仕様（VISIBILITY.md）に対する整合性を機械検証。
#
# 使い方: bash .claude/scripts/visibility-check.sh
#
# 終了コード:
#   0 = OK（違反なし）
#   1 = NG（違反あり）

set -uo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO_ROOT"

NG=0

print_section() {
  echo ""
  echo "=== $1 ==="
}

check_ok() { echo "  [OK] $1"; }
check_ng() { echo "  [NG] $1"; NG=1; }
check_warn() { echo "  [WARN] $1"; }

print_section "1. VISIBILITY.md の存在"

if [ -f "VISIBILITY.md" ]; then
  check_ok "VISIBILITY.md があります"
else
  check_ng "VISIBILITY.md がありません（ルート直下に必要）"
fi

print_section "2. 認証情報が tracked に紛れていないか"

CREDS=$(git ls-files | grep -E "(credentials\.json$|token\.json$|client_secret.*\.json$|\.env$)" || true)
if [ -z "$CREDS" ]; then
  check_ok "認証情報ファイルは tracked に存在しない"
else
  check_ng "認証情報ファイルが tracked です:"
  echo "$CREDS" | sed 's/^/    /'
fi

print_section "3. .local.json が tracked に紛れていないか"

LOCAL_JSON=$(git ls-files | grep -E "\.local\.json$" || true)
if [ -z "$LOCAL_JSON" ]; then
  check_ok ".local.json は tracked に存在しない"
else
  check_warn "tracked の .local.json（意図的なら問題なし）:"
  echo "$LOCAL_JSON" | sed 's/^/    /'
fi

print_section "4. session-state 実データが tracked に紛れていないか"

SESSION=$(git ls-files | grep -E "session-state/(auto\.jsonl|current\.md)$" || true)
if [ -z "$SESSION" ]; then
  check_ok "session-state 実データは tracked に存在しない（雛形 .example のみ可）"
else
  check_ng "session-state 実データが tracked です:"
  echo "$SESSION" | sed 's/^/    /'
fi

print_section "5. リポ固有パターン辞書"

if [ -f ".claude/sensitive-patterns.local.txt" ]; then
  patterns_count=$(grep -vE '^#|^\s*$' .claude/sensitive-patterns.local.txt | wc -l | tr -d ' ')
  check_ok ".claude/sensitive-patterns.local.txt あり（$patterns_count 件のパターン）"
else
  check_warn ".claude/sensitive-patterns.local.txt なし（リポ固有のパターンを足したい時のみ作成）"
fi

print_section "6. 直近 push 予定（uncommitted を含む）"

CHANGED=$(git status --short | head -20)
if [ -z "$CHANGED" ]; then
  echo "  （変更なし）"
else
  echo "$CHANGED" | sed 's/^/  /'
fi

echo ""
if [ "$NG" -eq 0 ]; then
  echo "✓ visibility-check (Agent-Teams): すべて OK"
  exit 0
else
  echo "⛔ visibility-check (Agent-Teams): 違反あり。VISIBILITY.md と .gitignore を確認してください。"
  exit 1
fi
