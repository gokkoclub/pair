---
name: pair-nav
description: Codex ナビゲーターの有効化/無効化/状態確認。Claude の作業を Codex がリアルタイムでレビューするペアプロモード。
disable-model-invocation: true
allowed-tools: Bash(*)
argument-hint: start [--model MODEL] | stop | status
---

# pair-nav - Codex ナビゲーター

Claude（ドライバー）の作業を Codex（ナビゲーター）がリアルタイムでレビューします。

## 実行

```bash
pair-nav $ARGUMENTS
```

引数が空なら `pair-nav status` を実行して現在の状態を表示してください。

## コマンド

| コマンド | 説明 |
|----------|------|
| `start` | ナビゲーターを有効化（hooks設定） |
| `stop` | ナビゲーターを無効化（hooks削除） |
| `status` | 状態・レビュー統計を表示 |

## start のオプション

- `--model <model>` : Codex のモデル (デフォルト: o3)
- `--context <text>` : ナビゲーターへの追加コンテキスト

## 動作フロー

1. `pair-nav start` → hooks がプロジェクトの `.claude/settings.local.json` に設定される
2. Claude Code セッションを再起動（hooks 読み込み）
3. Claude が普通に対話モードで作業
4. Claude のレスポンス完了 → Codex が差分を自動レビュー（Stop hook）
5. 問題なし → スキップ / 問題あり → フィードバック書き出し
6. 次のプロンプトで Codex のフィードバックが自動注入（UserPromptSubmit hook）
7. Claude がフィードバックを見て改善
8. 作業完了後 `pair-nav stop`

## 前提条件

- git リポジトリ内であること
- `npx @openai/codex` が使えること

## 注意

- `start` 後は Claude Code セッションを再起動してください（hooks反映のため）
- 各レビューは最大3分のタイムアウト
- 差分が3行未満の場合はレビューをスキップ（ノイズ防止）
- LGTM の場合もスキップ（不要なフィードバックを出さない）
