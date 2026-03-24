#!/usr/bin/env bash
set -euo pipefail

# pair コマンドのセットアップスクリプト
# ~/.local/bin/pair にインストールします

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="${HOME}/.local/bin"

mkdir -p "$INSTALL_DIR"
install -m 755 "${SCRIPT_DIR}/bin/pair" "${INSTALL_DIR}/pair"

echo "✓ pair を ${INSTALL_DIR}/pair にインストールしました"

# PATH チェック
if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
  echo ""
  echo "⚠ ${INSTALL_DIR} が PATH に含まれていません。以下を追加してください:"
  echo '  export PATH="$HOME/.local/bin:$PATH"'
fi

echo ""
echo "使い方:"
echo '  pair "タスクの説明"'
echo '  pair --help'
