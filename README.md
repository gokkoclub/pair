# pair - Claude Code × Codex ペアプロ自動化

Claude Code と OpenAI Codex を自動でペアプログラミングさせるツール。

## インストール

```bash
git clone https://github.com/gokkoclub/pair.git /tmp/pair && /tmp/pair/setup.sh
```

CLI（`~/.local/bin/`）と Claude Code スキル（`~/.claude/skills/`）を両方インストールします。

### 前提条件

- `claude` CLI（[Claude Code](https://claude.com/claude-code)）
- `npx @openai/codex`（OpenAI API キー設定済み）
- git

## 2つの方式

### リレー方式（`pair`）

交代で実装・改善を繰り返す。新規実装や大きなリファクタ向き。

```bash
# 基本（3ラウンドのping-pong）
pair "認証機能を実装して"

# モード指定
pair --mode review "REST APIを追加"
pair --mode implement-review "Claude実装→Codexレビュー→Claude修正"
pair --mode parallel "両方同時に実装→マージ"

# オプション
pair --rounds 5 "5ラウンドで改善"
pair --claude-first false "Codex先攻"
pair --claude-model opus --codex-model o3 "モデル指定"
pair --timeout 1200 "重いタスク（20分タイムアウト）"
pair --verbose "全出力表示"
```

| モード | 説明 |
|--------|------|
| `ping-pong`（デフォルト） | 交互に実装・改善 |
| `review` | 片方が実装、もう片方がレビュー＆修正 |
| `implement-review` | Claude実装 → Codexレビュー → Claude修正 |
| `parallel` | 両方同時に実装 → git worktree分離 → マージ |

リアルタイム進捗表示付き：
```
[Claude] 開始...
  [5s]  ▶ Read
      → page.tsx
  [12s] ▶ Edit
      → account-card.tsx
  [30s] ▶ Bash
      $ bun run lint
  ✓ 完了 1m45s | 8ターン | $0.42
```

### ナビゲーター方式（`pair-nav`）

Claude（ドライバー）が作業、Codex（ナビゲーター）がリアルタイムレビュー。バグ修正や既存コード改善向き。

```bash
pair-nav start                # ナビゲーター有効化
pair-nav start --model o3     # モデル指定
pair-nav status               # 状態確認
pair-nav stop                 # 無効化
```

動作フロー：
1. `pair-nav start` → プロジェクトに hooks を設定
2. Claude Code セッションを再起動
3. Claude が普通に対話モードで作業
4. Claude のレスポンス完了 → Codex が差分を自動レビュー
5. 次のプロンプトで Codex のフィードバックが自動注入
6. Claude がフィードバックを見て改善

## Claude Code スキルとして使う

インストール後、Claude Code 内でスラッシュコマンドとして使えます：

```
/pair "タスクの説明"
/pair-nav start
```

## 構成

```
├── bin/
│   ├── pair              # リレー方式スクリプト
│   └── pair-nav          # ナビゲーター方式スクリプト
├── skills/
│   ├── pair/SKILL.md     # /pair スキル定義
│   └── pair-nav/SKILL.md # /pair-nav スキル定義
├── SKILL.md              # ルートスキル定義
└── setup.sh              # インストーラ
```
