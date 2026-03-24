---
name: pair
description: Claude Code と OpenAI Codex のリレー式ペアプロを実行する。交互に実装・レビュー・改善を行う。
disable-model-invocation: true
allowed-tools: Bash(*)
argument-hint: [--mode ping-pong|review|implement-review|parallel] [--rounds N] "タスクの説明"
---

# pair - Claude × Codex リレー式ペアプロ

`pair` コマンドで Claude Code と Codex を交互にペアプログラミングさせます。

## 実行

```bash
pair $ARGUMENTS
```

引数が空ならユーザーにタスクの説明を聞いてください。

## モード

| モード | 説明 |
|--------|------|
| `ping-pong` (デフォルト) | 交互に実装・改善 |
| `review` | 片方が実装、もう片方がレビュー＆修正 |
| `implement-review` | Claude実装 → Codexレビュー → Claude修正 |
| `parallel` | 両方同時に実装 → worktree分離 → マージ |

## オプション

- `--mode <mode>` : 動作モード
- `--rounds <n>` : ラウンド数 (デフォルト: 3)
- `--claude-first false` : Codex を先攻にする
- `--claude-model <model>` : Claude のモデル (例: opus, sonnet)
- `--codex-model <model>` : Codex のモデル (例: o3, o4-mini)
- `--timeout <seconds>` : 各ターンのタイムアウト秒 (デフォルト: 900)
- `--verbose` : 全出力を表示

## 前提条件

- git リポジトリ内であること
- `claude` CLI と `npx @openai/codex` が使えること
