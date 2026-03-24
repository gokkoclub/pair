---
name: pair
description: Claude Code と OpenAI Codex のペアプロ自動化。リレー方式（pair）とリアルタイムナビゲーター方式（pair-nav）の2つのモードを提供。
allowed-tools: Bash(*)
argument-hint: [nav start|stop|status] | [--mode ping-pong|review|implement-review|parallel] "タスク"
---

# pair - Claude × Codex ペアプロ自動化

2つの方式で Claude Code と OpenAI Codex をペアプログラミングさせます。

## 方式の選び方

| | リレー方式 (`pair`) | ナビゲーター方式 (`pair-nav`) |
|---|---|---|
| 動き方 | 交代で実装・改善 | Claude が作業、Codex がリアルタイムレビュー |
| フィードバック | ラウンド終了後（深い） | 各ターン後（即座） |
| 向いてる場面 | 新規実装、大きなリファクタ | バグ修正、既存コードの改善 |
| コスト | ラウンド数分 | ターン数分（ただし軽量レビューのみ） |

---

## 方式1: リレー (`pair`)

```bash
pair $ARGUMENTS
```

引数が空ならユーザーにタスクの説明を聞いてください。

### モード一覧

| モード | 説明 |
|--------|------|
| `ping-pong` (デフォルト) | 交互に実装・改善を繰り返す |
| `review` | 片方が実装、もう片方がレビュー＆修正 |
| `implement-review` | Claude実装 → Codexレビュー → Claude修正 |
| `parallel` | 両方同時に実装 → git worktreeで分離 → マージ |

### オプション

- `--mode <mode>` : 動作モード
- `--rounds <n>` : ラウンド数 (デフォルト: 3)
- `--claude-first false` : Codex を先攻にする
- `--claude-model <model>` : Claude のモデル (例: opus, sonnet)
- `--codex-model <model>` : Codex のモデル (例: o3, o4-mini)
- `--timeout <seconds>` : 各ターンのタイムアウト秒 (デフォルト: 900)
- `--verbose` : 全出力を表示

### 例

```bash
pair "FizzBuzzを実装して"
pair --mode review --claude-first false "REST APIを追加"
pair --rounds 5 "認証機能を実装"
pair --mode parallel "ソート関数を最適化"
```

---

## 方式2: ナビゲーター (`pair-nav`)

Claude（ドライバー）の作業をCodex（ナビゲーター）がリアルタイムで監視・レビューします。

```bash
pair-nav $ARGUMENTS
```

### コマンド

- `pair-nav start` : ナビゲーターを有効化（hooks設定）
- `pair-nav stop` : ナビゲーターを無効化
- `pair-nav status` : 状態確認

### オプション（start時）

- `--model <model>` : Codex のモデル (デフォルト: o3)
- `--context <text>` : ナビゲーターへの追加コンテキスト

### 動作フロー

1. `pair-nav start` でナビゲーターを有効化
2. Claude が普通に対話モードで作業
3. Claude のレスポンス完了 → Codex が差分を自動レビュー（Stop hook）
4. 次のプロンプトで Codex のフィードバックが自動注入（UserPromptSubmit hook）
5. Claude がフィードバックを見て改善
6. 作業完了後 `pair-nav stop` で無効化

### 例

```bash
pair-nav start                      # 有効化
pair-nav start --model o3           # モデル指定
pair-nav start --context "React + TypeScript のプロジェクト"
pair-nav status                     # 状態確認
pair-nav stop                       # 無効化（統計表示）
```

---

## 前提条件

- git リポジトリ内であること
- `claude` CLI がインストール済み
- `npx @openai/codex` が実行可能（OpenAI API キー設定済み）

## インストール

```bash
git clone https://github.com/gokkoclub/pair.git /tmp/pair && /tmp/pair/setup.sh
```

CLI（`~/.local/bin/`）とスキル（`~/.claude/skills/`）を両方インストールします。
