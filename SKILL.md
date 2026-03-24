---
name: pair
description: Claude Code と OpenAI Codex を自動でペアプログラミングさせる。交互に実装・レビュー・改善を繰り返し、両者の強みを活かしたコードを生成する。
allowed-tools: Bash(*)
argument-hint: [--mode ping-pong|review|implement-review|parallel] [--rounds N] "タスクの説明"
---

# pair - Claude × Codex ペアプロ自動化

Claude Code と OpenAI Codex を自動的にペアプログラミングさせるスキルです。

## 実行

ユーザーの引数をそのまま `pair` コマンドに渡してください:

```bash
pair $ARGUMENTS
```

## 引数が空の場合

ユーザーにタスクの説明を聞いてください。最低限「タスクの説明」が必要です。

## モード一覧

| モード | 説明 |
|--------|------|
| `ping-pong` (デフォルト) | 交互に実装・改善を繰り返す |
| `review` | 片方が実装、もう片方がレビュー＆修正 |
| `implement-review` | Claude実装 → Codexレビュー → Claude修正 |
| `parallel` | 両方同時に実装 → git worktreeで分離 → マージ |

## オプション

- `--mode <mode>` : 動作モード
- `--rounds <n>` : ラウンド数 (デフォルト: 3)
- `--claude-first false` : Codex を先攻にする
- `--claude-model <model>` : Claude のモデル指定 (例: opus, sonnet)
- `--codex-model <model>` : Codex のモデル指定 (例: o3, o4-mini)
- `--timeout <seconds>` : 各ターンのタイムアウト秒 (デフォルト: 900)
- `--verbose` : 全出力を表示

## 使用例

```bash
# 基本（3ラウンドのping-pong）
pair "FizzBuzzを実装して"

# レビューモード（Codex実装 → Claude レビュー）
pair --mode review --claude-first false "REST APIを追加"

# 5ラウンドでじっくり改善
pair --rounds 5 --mode ping-pong "認証機能を実装"

# 並列実装して良いとこ取り
pair --mode parallel "ソート関数を最適化"

# モデル指定 + タイムアウト20分
pair --claude-model opus --codex-model o3 --timeout 1200 "複雑なアルゴリズム"
```

## 進捗表示

実行中はリアルタイムで進捗が表示されます:
- ツール呼び出し名（Read, Edit, Bash 等）
- 操作対象ファイル
- 経過時間
- 完了時のコスト・ターン数

## 前提条件

- カレントディレクトリが git リポジトリであること
- `claude` CLI がインストール済みであること
- `npx @openai/codex` が実行可能であること（OpenAI API キー設定済み）

## インストール

```bash
# pair コマンドをグローバルインストール
install -m 755 "$(dirname "$0")/bin/pair" ~/.local/bin/pair
```

または手動で:

```bash
cp bin/pair ~/.local/bin/pair
chmod +x ~/.local/bin/pair
```

## 実行前の確認

- git リポジトリかチェックし、そうでなければ `git init` を提案
- 未コミットの変更があれば、先にコミットするか確認
