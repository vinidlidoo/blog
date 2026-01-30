# Japanese Translation Learnings

Terminology and conventions discovered through editing. The translation-editor agent reads this file and appends new learnings.

## Mathematical Terms

| English | Japanese | Notes |
|---------|----------|-------|
| set-builder notation | 集合の内包的記法 | Standard term |
| unrestricted comprehension | 無制限の内包 | Standard term |
| cumulative hierarchy | 累積的階層 | Standard term |
| power set | 冪集合 | Standard term |
| limit ordinal | 極限順序数 | Standard term |
| naive set theory | 素朴集合論 | Standard term |

## Style Conventions

- Prefer conversational sentence-final forms: use 「〜だ」 over 「〜である」 for most explanatory sentences to maintain a casual, blog-like tone
- English idioms should be adapted to Japanese equivalents rather than translated literally:
  - "sent me down a rabbit hole" -> 「沼にはまってしまった」 (fell into a swamp/obsession)
  - "from thin air" -> 「何もないところから」 (from where there is nothing)
  - "abstract curiosities" -> 「抽象的な珍品」 not 「抽象的な好奇心」 (curiosities = rare/unusual items, not the feeling of curiosity)
- Keep technical explanations precise but avoid overly formal academic register
- **Do NOT use em dashes (— or ―) in Japanese text.** Per the JTF Style Guide: 「原則として和文ではダッシュを使用しません」 (dashes are not used in Japanese text as a rule). Instead use:
  - Parentheses （） for clarifications and definitions
  - Period 。 to separate independent clauses
  - Restructure sentences when needed (e.g., add 「つまり」 for "that is")
- **Series/part numbering:** Use 「第N回/全M回」 format (e.g., 「第1回/全3回」). Use 回 (installment) rather than 部 (part/volume) for casual blog series—部 sounds more like book chapters.

## Technical AI/ML Terms

| English | Japanese | Notes |
|---------|----------|-------|
| KV cache | KVキャッシュ | Keep as katakana |
| prompt caching | プロンプトキャッシング | Keep as katakana |
| forward pass | フォワードパス | Keep as katakana |
| decoder block | デコーダブロック | Keep as katakana |
| hidden state | 隠れ状態 | Standard term |
| attention head | アテンションヘッド | Keep as katakana |
| cache hit/miss | キャッシュヒット/ミス | Keep as katakana |
| token | トークン | Keep as katakana |
| context engineering | コンテキストエンジニアリング | Keep as katakana |

## Additional Style Notes

- "Implications" (section header) -> 「実際の影響」 rather than the overly academic 「含意」
- "cost prohibitive" -> 「採算が合わない」 (more natural than 「コスト的に成り立たない」)
- "attends to" (attention mechanism) -> 「注目する」 rather than stiff 「アテンションを向ける」
- "grows monotonically" (casual context) -> 「増え続ける一方になりがち」 rather than mathematical 「単調に増加する傾向がある」
- "in collaboration with" -> 「と協力して〜しました」 not 「との協力で〜されました」
- "anthropomorphization" (making abstract concepts relatable through human examples) -> 「身近なたとえ話」 or 「たとえ話」, not 「擬人化」 (which means personification)
- Keep proper nouns like "Diana", "Daniella" in katakana (ダイアナ、ダニエラ) rather than substituting unrelated Japanese names, especially when they serve a mnemonic purpose (e.g., names starting with D for set D)
- Em dash alternatives also include conjunctive form 「〜で、」 to connect related clauses
- "cringe" (describing embarrassingly bad output) -> 「痛々しさ」 (more impactful than 「違和感」 which is too mild)
- "voice" (authorial voice/writing style) -> 「トーン」 is clearer than literal 「声」 in writing context
- "native speaker" -> 「〜語ネイティブ」 more natural than 「生まれながらの〜話者」

## Turing Machine / Computer Science Terms

| English | Japanese | Notes |
|---------|----------|-------|
| Turing machine | チューリングマシン | Standard term |
| Turing complete | チューリング完全 | Standard term |
| tape (Turing machine) | テープ | Keep as katakana |
| head (Turing machine) | ヘッド | Keep as katakana |
| cell | セル | Keep as katakana |
| state | 状態 | Standard term |
| transition function | 遷移関数 | Standard term |
| accept/reject | 受理/拒否 | Standard terms |
| tape alphabet | テープアルファベット | Keep as katakana |
| input alphabet | 入力アルファベット | Keep as katakana |
| language (formal) | 言語 | Standard term |
| palindrome | 回文 | Standard term |
| algorithm | アルゴリズム | Keep as katakana |
| computer (historical, person) | computer | Keep in English with quotes when referring to the historical meaning of a human calculator |

## Additional Punctuation Notes

- After introducing a strategy or explanation with 「戦略は」or similar, use 「こうだ。」 instead of colon
- When presenting numbered lists with a lead-in, end the lead-in with 「次の4つだけ。」 or similar complete sentence
- Use period 。 consistently after parenthetical explanations in running text
- **Watch for colons in English source**: When English uses "X: Y" where Y defines/explains X, Japanese needs explicit connection. Add 「つまり、」 before Y, or restructure. Without this, two separate sentences look disconnected.

## Additional Terms (Turing Completeness Article)

| English | Japanese | Notes |
|---------|----------|-------|
| Universal Turing Machine | 万能チューリングマシン | Standard term |
| Church-Turing Thesis | チャーチ=チューリングのテーゼ | Use = sign between names |
| conditional branching | 条件分岐 | Standard term |
| encoding | エンコーディング | Keep as katakana |
| general intelligence | 汎用知能 | Standard term |

## Additional Naturalness Notes

- "yes, really" (parenthetical aside) -> 「嘘じゃない」 more conversational than 「本当だ」
- "a handful of" -> 「少しばかりの」 or 「いくつかの」
- "nicer syntax" (casual) -> 「より使いやすい構文」 not 「より美しい構文」
- Restructure sentences ending awkwardly with 「〜しながら」 to flow more naturally

## Computability Theory Terms (Limits of Computation Article)

| English | Japanese | Notes |
|---------|----------|-------|
| halting problem | 停止問題 | Standard term |
| undecidable | 決定不能 | Standard term |
| decidable | 決定可能 | Standard term |
| halt decider | 停止判定器 | Standard term |
| Rice's theorem | ライスの定理 | Transliteration |
| Godel's incompleteness theorem | ゲーデルの不完全性定理 | Standard term |
| Hilbert's program | ヒルベルト・プログラム | Use middle dot for compound |
| completeness (logic) | 完全性 | Standard term |
| soundness | 健全性 | Standard term |
| consistency | 無矛盾 / 無矛盾性 | Standard term (also 整合性) |
| independent (of axioms) | 独立 | Standard term |
| diagonal argument | 対角線論法 | Standard term |

## Naturalness Notes (Limits of Computation Article)

- "Incredibly useful" -> 「これほど便利なものはない」 (more impactful than literal 「信じられないほど便利だ」)
- "Now comes the punch line" / "This is the punchline" -> 「さて、ここからが本番だ」 or 「ここが核心だ」 (captures dramatic buildup)
- "We've traced a boundary" -> 「境界をたどってきた」 (「追跡」 sounds overly investigative)
- "in a thousand and one years" -> 「あと一年で」 (preserve the rhetorical point rather than literal translation)

## Cryptography / Elliptic Curve Terms

| English | Japanese | Notes |
|---------|----------|-------|
| elliptic curve | 楕円曲線 | Standard term |
| field (algebra) | 体 | Standard term |
| finite field | 有限体 | Standard term |
| group (algebra) | 群 | Standard term |
| discrete logarithm problem (DLP) | 離散対数問題 | Standard term |
| double-and-add | ダブル・アンド・アッド | Use katakana with middle dots, include English in parentheses |
| private key | 秘密鍵 | Standard term |
| public key | 公開鍵 | Standard term |
| ECDH | 楕円曲線ディフィー・ヘルマン鍵共有 | Full name with middle dot |
| ECDSA | 楕円曲線DSA | Standard term (per Wikipedia) |
| symmetric encryption | 共通鍵暗号 | Standard term (not 対称暗号) |
| asymmetric encryption | 公開鍵暗号 | Standard term (not 非対称暗号) |
| secrecy / confidentiality | 機密性 | Prefer 機密性 over 秘密 for formal security property |
| nonce | ノンス | Keep as katakana |
| digital signature | デジタル署名 | Standard term |
| authenticity | 真正性 | Standard term |

## Additional Naturalness Notes (Cryptography Articles)

- "Turns out I was wrong" -> 「とんでもない思い違いだった」 (more emphatic than literal)
- "computationally out of reach" -> 「計算上は手の届かないところにある」 (note: 計算上**は** with は particle)
- "The cost?" (rhetorical question) -> 「代償は？」 more natural than 「コストは？」
- "expensive math" -> 「計算コストの高い演算」 not literal 「高価な数学」

## Education / AI Learning Terms

| English | Japanese | Notes |
|---------|----------|-------|
| prompt-first learning | プロンプトファースト学習 | Keep as katakana compound |
| personalization | パーソナライゼーション | Keep as katakana |
| spaced repetition | 間隔反復 | Standard term |
| modality (learning) | モダリティ | Keep as katakana |
| Choose Your Own Adventure | 『きみならどうする？』シリーズ | Japanese equivalent series |

## Additional Naturalness Notes (Education Article)

- "not trivial" (describing substantial work) -> 「並大抵ではない」 more natural than 「簡単ではない」
- "thin" (describing inadequate content) -> 「物足りない」 captures the disappointment nuance
- "rabbit hole" -> 「沼にはまる」 per established idiom (not 「穴に潜る」)
- "the key insight" -> 「ここがポイントで」 more conversational than 「重要な洞察は」
- "encodes" (capturing style in code/rules) -> 「反映させた」 more natural than 「エンコードした」
- "obviously oversimplifying" -> 「もちろんこれは単純化しすぎだ」 (「明らかに」 sounds stiff)
- "That's a discussion for another post" -> 「それはまた別の投稿で」 (concise, conversational)
- "with special attention to X" -> integrate into sentence (e.g., 「Xを重点的に」), not standalone 「Xに注意を払って」
- "we're circling the same idea" -> 「行き着く先は同じだ」 (captures convergence from different angles) not 「同じことを言っている」 (too direct)
- "the primary reason was X" -> use 「〜のは、〜のおかげだ」 to connect clauses naturally
- "metaphors" (analogies in teaching) -> 「たとえ」 not 「メタファー」 (too literary)
- "staying faithful to the source" -> 「元の意味を損なわずに」 not 「忠実」 (typically for people/loyalty)
- "put knowledge to use" -> 「知識を役立てる」 not 「知識を実践に活かす」 (emphasizes being useful)
- "I'm excited" -> 「楽しみだ」 not 「ワクワクしている」 (sounds infantile for adult writing)
- "but hey" (casual interjection) -> 「まあ、」 captures the dismissive/casual tone
- "willing to do X" -> 「Xをする気があれば」 or 「手間をかける気があれば」 (「やる気」 means motivation, not willingness)
- "the primary path" (in contrast to supplemental tools) -> 「学びの中心」 more conversational than formal 「本道」
- "the lasting artifact" -> 「残る成果物になる」 with 「になる」 flows more naturally than 「〜だ」 when describing what something becomes
- "My take is" (expressing personal opinion) -> 「私としては、〜と思う」 direct assertion preferred over rhetorical question 「〜のではないか」

## Data Engineering / Storage Terms

| English | Japanese | Notes |
|---------|----------|-------|
| row-oriented | 行指向 | Standard term |
| column-oriented / columnar | 列指向 | Standard term |
| row group | 行グループ | Standard term |
| column chunk | 列チャンク | Standard term |
| predicate pushdown | 述語プッシュダウン | Standard term |
| projection (column selection) | プロジェクション | Keep as katakana |
| dictionary encoding | 辞書エンコーディング | Standard term |
| delta encoding | デルタエンコーディング | Standard term |
| run-length encoding (RLE) | ランレングスエンコーディング（RLE） | Keep abbreviation |
| Bloom filter | Bloomフィルター | Keep "Bloom" in English |
| cardinality | カーディナリティ | Keep as katakana |
| immutable | イミュータブル | Keep as katakana |
| footer (file structure) | フッター | Keep as katakana |
| batch processing | バッチ処理 | Standard term |
| seek (disk operation) | seek | Keep in English (technical term) |
| throughput | スループット | Keep as katakana |
| latency | レイテンシ | Keep as katakana |

## Additional Naturalness Notes (Data Engineering Article)

- "It felt too good to be true" -> 「うますぎる話に聞こえた」 more natural than 「話がうますぎる気がした」
- "Neither is acceptable" -> 「どちらも現実的ではない」 (「受け入れられない」 sounds too formal)
- "terrible" (describing bad performance) -> 「最悪だ」 or 「ひどい」 depending on emphasis
- "just works" (describing simple solution) -> 「で済む」 (e.g., 「`echo ...` で済む」)
- "Implication" (table header) -> 「意味するところ」 rather than academic 「含意」
- "Here's what X looks like" -> 「Xはこんな感じだ」 more conversational than 「Xは次のようになる」
- When listing technical items inline, use 「〜向けだ」 rather than 「〜に使う」 for variety

## Pronoun Usage

- **Avoid 僕**: Use 私 when first-person is absolutely necessary, but prefer omitting pronouns entirely
- **Reduce pronoun overuse**: Japanese naturally omits pronouns when subject is clear from context. Overusing 私/あなた/僕 makes text read unnaturally
- Examples of pronoun reduction:
  - Bad: 「私は理解しようとしている」 → Good: 「理解しようとしている」
  - Bad: 「私の場合、それはよく数学を意味する」 → Good: 「数式を見ないと表面的な理解しかできていない気がするので、数学をよく求める」
  - Bad: 「あなたの混乱に合わせて」 → Good: 「自分の疑問に合わせて」 or 「混乱に合わせて」
- When emphasis on "you" is needed (contrasting with generic readers), use *あなた* with italics sparingly
- "easier said than done" -> 「言うは易く行うは難し」 (proverb form, natural)
- "I'd add" (casual interjection) -> 「付け加えるなら」 or 「一つ付け加えると」 (avoids 私)
- "What works for me" / "for me" (establishing personal context) -> use 「自分に」 in opening sentence rather than changing section headers (e.g., 「自分にうまくいっている方法」)
- "cold joint" (soldering) -> 「いもはんだ」 (standard Japanese soldering term, not 「冷たいはんだ」)
- "employability" -> 「市場価値」 more natural than 「雇用可能性」
- "highest-leverage" -> 「最も効果の大きい」 not 「最もレバレッジの高い」 (unnecessary katakana)
- "solution" (casual) -> 「解決策」 not 「ソリューション」 (less corporate)
- "dev bootcamp" -> 「プログラミングブートキャンプ」 (clearer for Japanese readers)
- "Discovery" (education stage) -> 「探索」 not 「発見」 (発見 implies finding something new; 探索 fits exploring options)
- "subfield" -> 「分野」 not 「サブフィールド」 (unnecessary katakana)
- "invasive" (privacy context) -> 「プライバシーを侵しやすい」 not 「侵襲的」 (too medical)
- "auditable" -> 「検証可能」 not 「監査可能」 (simpler, more natural)
- "navigable decision space" -> 「自分で探れる意思決定空間」 not 「ナビゲーション可能な意思決定空間」
- "remaining artifact" -> 「最終的に残るのは」 not 「残る成果物は」 (成果物 is corporate jargon)
- "transparent container" (metaphorical) -> 「中身の見える器」 not 「透明なコンテナ」
- "actors" (stakeholders) -> 「関係者」 not 「アクター」 (less jargony)
- "intervene" (technology helping) -> 「役立つ」 not 「介入」 (介入 has negative/forceful connotation)
- "let me know" (closing call-to-action) -> 「教えてください」 not 「教えてほしい」 (ほしい feels too demanding; slight politeness is appropriate for direct reader address even in だ-register articles)
- "three-dimensional X problem" -> 「3つの軸（...）からなるX」 (more natural than literal 「N次元の問題」)
- Localized contact links: use `/ja/contact/` for Japanese translations
- "accreditors" -> 「認証評価機関」 (evaluates institutions) not 「認定機関」 (too close to 資格認定団体)
- "credentialing bodies" -> 「資格認定団体」 (issues credentials to individuals)
- "performance tasks" (assessment) -> 「実技課題」 not 「パフォーマンス課題」 (実技 captures hands-on meaning)
- "AI-assessed performance" -> 「AIによる実技評価」 not 「AI評価によるパフォーマンス課題」
- "task simulations" -> 「実技シミュレーション」 not 「タスクシミュレーション」
- "certain forms of cheating" -> drop 「特定の」, just 「不正行為が」 (特定の sounds overly precise)
- "pain points" -> 「課題」 consistently, not 「問題」 (課題 implies challenges to address; 問題 is more generic/negative)
- "study notes" -> 「復習ノート」 not 「スタディノート」 (established term from prompt-first learning post)
- "Where AI Fits" (title) -> 「AIの出番はどこか」 not 「AIはどこに位置するか」 (位置する is too formal)

