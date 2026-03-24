#!/usr/bin/env bash
set -euo pipefail

# pair + pair-nav セットアップスクリプト
# CLI コマンドと Claude Code スキルを両方インストール

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="${HOME}/.local/bin"
SKILLS_DIR="${HOME}/.claude/skills"

echo "╭──────────────────────────────────────╮"
echo "│  pair セットアップ                   │"
echo "╰──────────────────────────────────────╯"
echo ""

# --- CLI インストール ---
mkdir -p "$INSTALL_DIR"
install -m 755 "${SCRIPT_DIR}/bin/pair" "${INSTALL_DIR}/pair"
install -m 755 "${SCRIPT_DIR}/bin/pair-nav" "${INSTALL_DIR}/pair-nav"

echo "✓ CLI: pair     → ${INSTALL_DIR}/pair"
echo "✓ CLI: pair-nav → ${INSTALL_DIR}/pair-nav"

# --- スキルインストール ---
mkdir -p "${SKILLS_DIR}/pair" "${SKILLS_DIR}/pair-nav"
cp "${SCRIPT_DIR}/skills/pair/SKILL.md" "${SKILLS_DIR}/pair/SKILL.md"
cp "${SCRIPT_DIR}/skills/pair-nav/SKILL.md" "${SKILLS_DIR}/pair-nav/SKILL.md"

echo "✓ スキル: /pair     → ${SKILLS_DIR}/pair/"
echo "✓ スキル: /pair-nav → ${SKILLS_DIR}/pair-nav/"

# --- PATH チェック ---
if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
  echo ""
  echo "⚠ ${INSTALL_DIR} が PATH に含まれていません。以下を追加してください:"
  echo '  export PATH="$HOME/.local/bin:$PATH"'
fi

echo ""
echo "使い方:"
echo '  pair "タスクの説明"              # リレー方式（ターミナル or Claude Code）'
echo '  pair-nav start                   # ナビゲーター方式（有効化）'
echo '  pair-nav stop                    # ナビゲーター方式（無効化）'
echo '  /pair "タスクの説明"             # Claude Code スラッシュコマンド'
echo '  /pair-nav start                  # Claude Code スラッシュコマンド'
echo ""
echo "セットアップ完了!"
