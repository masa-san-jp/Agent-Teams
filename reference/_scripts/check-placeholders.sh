#!/bin/bash
# check-placeholders.sh — プレースホルダ・個人情報漏洩の検出
#
# 用途:
#   1. 配布前チェック（送り手）: 未定義 {{...}} と個人情報残存を検出
#   2. 導入後チェック（受け手）: --strict で全プレースホルダ未置換を検出
#
# 配置:
#   reference/_scripts/check-placeholders.sh
#
# 実行:
#   bash reference/_scripts/check-placeholders.sh                # 通常モード
#   bash reference/_scripts/check-placeholders.sh --strict       # 全 {{...}} を error 扱い
#   bash reference/_scripts/check-placeholders.sh --target <dir> # 走査対象を指定（既定: スクリプトの親ディレクトリ）
#
# 終了コード:
#   0: 問題なし
#   1: 検出あり（findings あり）
#   2: 引数エラー

set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
STRICT=0

while [ $# -gt 0 ]; do
  case "$1" in
    --strict)
      STRICT=1
      shift
      ;;
    --target)
      TARGET_DIR="$2"
      shift 2
      ;;
    -h|--help)
      sed -n '2,20p' "$0"
      exit 0
      ;;
    *)
      echo "不明な引数: $1" >&2
      exit 2
      ;;
  esac
done

if [ ! -d "$TARGET_DIR" ]; then
  echo "走査対象ディレクトリが存在しません: $TARGET_DIR" >&2
  exit 2
fi

# ----- 許可プレースホルダ（INSTALL.md セクション 0 + テンプレ用 と一致させる） -----
ALLOWED_PLACEHOLDERS=(
  "{{REFERENCE_ROOT}}"
  "{{ORG_REPO_PATH}}"
  "{{ORG_REPO_NAME}}"
  "{{ORG_NAME}}"
  "{{TEAM_AGENTS}}"
  "{{DEFAULT_MODEL}}"
  "{{CLAUDE_RULES_DIR}}"
  "{{AGENT_NAME}}"
  "{{AGENT_PURPOSE}}"
  "{{AGENT_1_NAME}}"
  "{{AGENT_1_PURPOSE}}"
  "{{AGENT_2_NAME}}"
  "{{AGENT_2_PURPOSE}}"
)

# ----- 個人情報パターン（送り手チェック用） -----
LEAK_PATTERNS=(
  "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
  "/Users/[a-zA-Z0-9_-]+/"
  "/home/[a-zA-Z0-9_-]+/"
  "C:\\\\Users\\\\[a-zA-Z0-9_-]+\\\\"
)

cd "$TARGET_DIR" || exit 2

echo "============================================"
echo "check-placeholders.sh"
echo "  対象: $TARGET_DIR"
if [ $STRICT -eq 1 ]; then
  echo "  モード: strict（全 {{...}} を error 扱い）"
else
  echo "  モード: 通常（未定義 {{...}} と個人情報を検出）"
fi
echo "  自スクリプトは走査対象から除外"
echo "============================================"
echo

# ----- ファイル列挙（拡張子別） -----
# tr-quoted の拡張子で find を組み立てる
FILES=$(find . -type f \
  \( -name "*.md" -o -name "*.json" -o -name "*.sh" -o -name "*.py" -o -name "*.yaml" -o -name "*.yml" -o -name "*.template" \) \
  -not -path "./_scripts/check-placeholders.sh" \
  -not -path "./.git/*" 2>/dev/null | sort)

FINDINGS=0

# ----- {{...}} 検出 -----
echo "## プレースホルダ検出"
echo
PLACEHOLDER_HITS=0
while IFS= read -r FILE; do
  [ -z "$FILE" ] && continue
  # ファイル内の各行をスキャンし {{...}} を抽出
  while IFS=: read -r LINE_NO MATCH; do
    [ -z "$MATCH" ] && continue
    # マッチ行から {{...}} を全て抽出
    PHS=$(echo "$MATCH" | grep -oE '\{\{[A-Z_][A-Z0-9_]*\}\}')
    [ -z "$PHS" ] && continue
    while IFS= read -r PH; do
      [ -z "$PH" ] && continue
      if [ $STRICT -eq 1 ]; then
        echo "  [STRICT] $FILE:$LINE_NO  未置換: $PH"
        PLACEHOLDER_HITS=$((PLACEHOLDER_HITS + 1))
      else
        IS_ALLOWED=0
        for ALLOWED in "${ALLOWED_PLACEHOLDERS[@]}"; do
          if [ "$PH" = "$ALLOWED" ]; then
            IS_ALLOWED=1
            break
          fi
        done
        if [ $IS_ALLOWED -eq 0 ]; then
          echo "  [UNKNOWN] $FILE:$LINE_NO  未定義プレースホルダ: $PH"
          PLACEHOLDER_HITS=$((PLACEHOLDER_HITS + 1))
        fi
      fi
    done <<< "$PHS"
  done < <(grep -nE '\{\{[A-Z_][A-Z0-9_]*\}\}' "$FILE" 2>/dev/null)
done <<< "$FILES"

if [ $PLACEHOLDER_HITS -eq 0 ]; then
  echo "  ✓ 検出なし"
fi
echo
FINDINGS=$((FINDINGS + PLACEHOLDER_HITS))

# ----- 個人情報パターン検出（strict モードでは省略） -----
if [ $STRICT -eq 0 ]; then
  echo "## 個人情報パターン検出"
  echo
  LEAK_HITS=0
  for PATTERN in "${LEAK_PATTERNS[@]}"; do
    while IFS=: read -r FILE LINE_NO MATCH; do
      [ -z "$FILE" ] && continue
      [ "$FILE" = "./_scripts/check-placeholders.sh" ] && continue
      # 説明文中の例示は除外
      if echo "$MATCH" | grep -qE 'placeholder|{{.*}}|例:|例：|<.*>|`.*`'; then
        continue
      fi
      echo "  [LEAK] $FILE:$LINE_NO  パターン: $PATTERN"
      echo "         → $(echo "$MATCH" | head -c 100)"
      LEAK_HITS=$((LEAK_HITS + 1))
    done < <(grep -rnE "$PATTERN" \
      --include="*.md" --include="*.json" --include="*.sh" \
      --include="*.py" --include="*.yaml" --include="*.yml" --include="*.template" \
      . 2>/dev/null)
  done
  if [ $LEAK_HITS -eq 0 ]; then
    echo "  ✓ 検出なし"
  fi
  echo
  FINDINGS=$((FINDINGS + LEAK_HITS))
fi

# ----- サマリ -----
echo "============================================"
echo "結果: $FINDINGS 件の検出"
echo "============================================"

if [ $FINDINGS -gt 0 ]; then
  exit 1
fi
exit 0
