#!/usr/bin/env bash
set -euo pipefail

# pair + pair-nav セットアップスクリプト

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="${HOME}/.local/bin"

mkdir -p "$INSTALL_DIR"
install -m 755 "${SCRIPT_DIR}/bin/pair" "${INSTALL_DIR}/pair"
install -m 755 "${SCRIPT_DIR}/bin/pair-nav" "${INSTALL_DIR}/pair-nav"

echo "✓ pair     → ${INSTALL_DIR}/pair"
echo "✓ pair-nav → ${INSTALL_DIR}/pair-nav"

# PATH チェック
if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
  echo ""
  echo "⚠ ${INSTALL_DIR} が PATH に含まれていません。以下を追加してください:"
  echo '  export PATH="$HOME/.local/bin:$PATH"'
fi

echo ""
echo "使い方:"
echo '  pair "タスクの説明"              # リレー方式'
echo '  pair-nav start                   # ナビゲーター方式（有効化）'
echo '  pair-nav stop                    # ナビゲーター方式（無効化）'
echo '  pair --help / pair-nav --help    # 詳細ヘルプ'
