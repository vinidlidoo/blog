+++
title = "Claude Codeスキルによる翻訳"
date = 2026-01-14
description = "カスタムスキルとサブエージェントで、多言語公開を手動翻訳より速く、安く、高品質に"

[taxonomies]
tags = ["dev"]
+++

![Claude Codeによる翻訳](/img/translation-with-claude-code-main-image.webp)

今では、すべてのブログ記事をフランス語と日本語に1分以内で翻訳できる。手動での修正は一切不要だ。最も技術的なコンテンツでも、驚くほど自然に仕上がる。しかもClaudeのサブスクリプションがあれば、追加コストはゼロ。最近はAIの可能性を信じずにはいられない。

この記事では、Claude Codeの**スキル**と**サブエージェント**を使ってこのシステムを構築した方法を説明する。

## スキルとサブエージェント

これを可能にするのは、Claude Codeの2つの機能だ。

[スキル](https://docs.anthropic.com/en/docs/claude-code/skills)は、Claudeに特定のタスクの実行方法を教える再利用可能なプロンプトだ。スキルはファイルを読み、シェルスクリプトを実行し、複雑なワークフローを調整できる。スラッシュコマンド（次のセクションで紹介する`/sync-translations`のように）で呼び出すこともできるし、Claude Codeがコンテキストに基づいて自動的にトリガーすることもできる。

[サブエージェント](https://docs.anthropic.com/en/docs/claude-code/sub-agents)は、メインエージェントが起動できる別のClaudeインスタンスだ。各サブエージェントは独自のシステムプロンプトを持ち、新しいコンテキストウィンドウで開始し、メインエージェントのコンテキストを自分の作業で汚染しない。複数のサブエージェントが並列で実行できる。これらの特性すべてが品質にとって重要だ。

## システムの概要

このブログはZolaとmarkdownファイルで動いている。このアプローチは、人間が読めるソースファイルを持つどんなブログにも一般化できる。関連する構造はこうだ。

```
.claude/
├── skills/
│   └── sync-translations/
│       ├── SKILL.md          # スキル定義
│       └── check-sync.sh     # 作業が必要なものを検出
├── agents/
│   └── translation-editor.md # 翻訳をレビュー
└── translation-learnings/
    ├── fr.md                 # フランス語の用語とスタイル
    └── ja.md                 # 日本語の用語とスタイル

content/blog/
├── kv-cache-invalidation.md     # 英語のオリジナル
├── kv-cache-invalidation.fr.md  # フランス語翻訳
├── kv-cache-invalidation.ja.md  # 日本語翻訳
├── blog-translation-with-claude-code.md  # この記事（まだ翻訳なし）
└── ...
```

メインエージェントは[sync-translations](https://github.com/vinidlidoo/vinidlidoo.github.io/blob/main/.claude/skills/sync-translations/SKILL.md) **スキル**を使ってすべてを調整する。`check-sync.sh`シェルスクリプトを実行して作業が必要なものを検出し、用語のガイダンスのために`{fr.md, ja.md}`学習ファイルを読み、翻訳の下書きを作成し、それから2つの[translation-editor](https://github.com/vinidlidoo/vinidlidoo.github.io/blob/main/.claude/agents/translation-editor.md) **サブエージェント**（各言語に1つ）を起動して新鮮な目でレビューする。エディターは発見を学習ファイルにフィードバックするので、システムは時間とともに改善される。

<img src="/img/translation-workflow.svg" alt="翻訳ワークフロー図" />

## 作業が必要なものを検出する

最初のステップはシェルスクリプトだ。[^1] 各英語記事とターゲット言語について、3つの状態のいずれかを出力する。**NEW**（翻訳ファイルが存在しない）、**SYNC**（翻訳は存在するが英語が変更された）、**ABORT**（翻訳は最新）。

NEWとABORTは単純なファイルチェックだ。SYNCはもっと難しい。gitの履歴が必要だ（ファイルの更新日時だけでなく）。エージェントは何かが変わった*こと*だけでなく、*何が*変わったかを知る必要があるからだ。正確なdiffがなければ、記事全体を再翻訳してしまい、以前に磨き上げたセクションが不必要に書き直されて翻訳が不安定になる。

スクリプトは翻訳の*内容*が最後に更新されたタイミングを見つけ、それ以降の英語のdiffを抽出する。`kv-cache-invalidation.md`というフランス語翻訳`kv-cache-invalidation.fr.md`を持つ記事の場合はこうなる。

```bash
# フランス語の内容が最後に変更されたコミットを見つける（リネームだけでなく）
baseline=$(git log --follow --format="%H" -- "kv-cache-invalidation.fr.md" \
    | while read commit; do
        # このコミットに実際の内容変更があったかチェック（+++ ---ヘッダーだけでなく）
        changes=$(git show "$commit" -- "kv-cache-invalidation.fr.md" | grep -c "^[-+]")
        [[ "$changes" -gt 4 ]] && echo "$commit" && break
    done)

# そのベースライン以降に英語が変更されたかチェック
git diff "$baseline"..HEAD -- "kv-cache-invalidation.md"
```

diffの出力があれば、英語のソースが分岐しており、翻訳の同期が必要だということだ。

[^1]: スクリプトは内部で異なるラベルを使用している。`NEEDS TRANSLATION`、`NEEDS SYNC`、`UP TO DATE`。

## ドラフターとエディター

メインエージェントが翻訳を下書きするが、自分の作業はレビューしない。別の[エディターサブエージェント](https://github.com/vinidlidoo/vinidlidoo.github.io/blob/main/.claude/agents/translation-editor.md)がそれを担当する。この分離が重要だ。

何かを書いたばかりのとき、人はそれに対してバイアスがかかる。自分で選んだばかりだから、表現が問題なく見える。ぎこちない構文が見逃される。新鮮な読者は、書き手が見落とすものを捉える。これは人間に当てはまるし、LLMにも当てはまる。

エディターはクリーンなコンテキストで開始する。英語のソース、レビューする翻訳、共有の学習ファイル（後述）だけを見る。自然さ（翻訳調かネイティブ調か？）、慣用句の適応（英語の表現は意味で訳されたか、直訳か？）、技術用語（ターゲット言語の標準用語か？）、トーン（まだ自分らしさがあるか？）をチェックする。

引き継ぎの仕方はコンテキストによって変わる。新規翻訳の場合、エディターは全体をレビューする。同期の場合は、変更されたセクションに集中する（残りはすでにレビュー済みだから）。そして、各言語が独立したファイルで作業する専用のエディターを持つので、並列実行が可能だ。

## 蓄積される学習

両方のエージェントが言語ごとに[学習ファイル](https://github.com/vinidlidoo/vinidlidoo.github.io/tree/main/.claude/translation-learnings)を共有している。メインエージェントは下書き前にそれを読み、エディターはレビュー中に読んで、その後新しい発見を追記する。これがフィードバックループを作る。各翻訳が次の翻訳をより良くする。

フランス語では、このファイルに「proof by contradiction」は「par l'absurde」であるべき（直訳の「en vue d'une contradiction」ではなく）、アテンションメカニズムでの「attends to」は「prête attention à」を意味する（「assiste à」ではなく）、「forward pass」のような技術用語は英語のままにすべき、といったことが記録されている。

日本語では、emダッシュは完全に避けること（日本語テキストでは標準ではないため）、「sent me down a rabbit hole」は「沼にはまってしまった」と訳すこと、シリーズの番号付けは「第N回/全M回」形式を使うこと、といったことが記録されている。

これらは私が事前に書いたルールではない。編集セッションから生まれ、記事ごとに蓄積されていく。

## 結論

私はフランス語ネイティブで、日本で10年間生活し働いていた。このブログを英語で書くことはリーチの面で理にかなっていたが、読者（友人や家族）を置き去りにすることを意味していた。

代替案は良くなかった。手動翻訳は記事ごとに言語ごとに3〜4時間かかり、品質は中程度だろう。技術的な語彙は英語で学び、数学はフランス語で学び、日本語は流暢だが洗練された文章を書くスキルはあまり練習していない。プロの翻訳は高価だ。そして技術コンテンツのGoogle翻訳の出力を読んだことがある人なら、あの痛々しさを知っているだろう。ぎこちない表現、間違った用語、「私はロボットです」と叫んでいるような文章。

これでゲームが変わる。翻訳は完璧ではないが、かなり近い。コストは1分待つことだけ。この選択肢がなければ、私はこのブログを翻訳しようとは思わなかっただろう。これからの数カ月で、オンラインの多言語コンテンツがもっと増えていくと思う。

システムの構築には数時間かかった。今は英語で書いて、コミットして、`/sync-translations`を実行するだけだ。この記事もこのシステムで翻訳された。フランス語版か日本語版を読んでいるなら、まさにその結果を見ていることになる。似たようなものを構築したいなら、この記事内のリンクをたどるか、[リポジトリ全体](https://github.com/vinidlidoo/vinidlidoo.github.io/tree/main/.claude)を覗いてみてほしい。

---

*この記事は[Claude](https://claude.ai)（Opus 4.5）と協力して書きました。*
