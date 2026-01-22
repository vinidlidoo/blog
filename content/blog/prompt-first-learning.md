+++
title = "Prompt-First Learning"
date = 2026-01-22
description = "What if textbooks adapted to your questions, not the other way around?"

[taxonomies]
tags = ["ai", "education"]
+++

Since the holiday break, I've been thinking about AI and education. It's a big part of why I started this blog two weeks ago, right after wrapping up a 10-year stint at Amazon. I wanted to experiment with how AI can help teach, though my goals are also selfish: I learn best by teaching. Feynman had it right: if you can't explain something simply, you don't understand it well enough. And honestly, few things give me a bigger high than finally getting something to click.

A [tweet](https://x.com/AriaWestcott/status/2013153611715350783) crossed my feed last week claiming Google had dropped "the textbook killer": a system called Learn Your Way that transforms PDFs into personalized learning materials. The original [blog post announcement](https://research.google/blog/learn-your-way-reimagining-textbooks-with-generative-ai/) turned out to be from September 2025, but hey, what matters is what they built and where it points.

So I tried the [demo](https://learnyourway.withgoogle.com/) and read the [paper](https://arxiv.org/pdf/2509.13348), published earlier this month. I'm glad a company with Google's resources is investing in this space. What they've built is not trivial: LearnLM transforms PDFs into multiple formats (immersive text, slides with narration, audio-graphic lessons, mind maps), adjusts to your grade level, tailors examples to your interests, and embeds questions throughout to check understanding. The quiz at the end of each section gives you an assessment with strengths and growth areas. Real work has gone into this.

Here's where I was a bit disappointed. I set my persona to "undergraduate interested in painting" and loaded the Hydrocarbons module. The personalization I received was a single sentence: "*We find hydrocarbons in many artist materials—for instance, the turpentine used to thin oil paints or the mineral spirits for cleaning brushes.*" The rest of the text was unchanged from the source material. Thin, but the infrastructure is there: the format transformations work, the assessment pipeline works, and all the rest too. Going through the material, the question I kept coming back to was: is augmenting existing material the right direction though, or is there something more fundamental waiting to be built?

## The Problem with Augmentation

Most textbooks aren't written for you. They're written for broad audiences, optimized for the middle of the bell curve. They can't anticipate where *you* will get stuck or what background *you* bring. Augmenting that kind of source material—even with smart personalization—doesn't change the underlying problem: the text still wasn't written with your specific gaps, your specific questions, your way of learning in mind.

Learn Your Way's current approach is augmentation: take the source, add personalized touches, present it in different formats. That's valuable, but it's still fundamentally one-directional. The text talks at you. What's missing is the back-and-forth—the chance to say "wait, I don't get this part" and have the material respond. And beyond that: the chance to choose where you go next. Think *Choose Your Own Adventure*, but for learning. You decide which rabbit hole to explore, which tangent to follow, which connection to chase. You're not just a reader; you're the protagonist of your own curriculum.

## What Works for Me

Here's what's been working for me over the past year. I start a conversation with Claude about a topic: tell it what I'm trying to understand, my background, how I learn best. For me, that often means math; unless I see the formulas, I feel like I only have a superficial grasp. A friend of mine learns better through analogies. We're different, and that's the point.

I go back and forth: asking about the parts that confuse me, pushing back when something doesn't click, keeping at it until I get it. When I'm done, I have Claude save review notes directly to Obsidian via an MCP server, with special attention to the areas that gave me difficulty. Plain Markdown, no vendor lock-in. Those notes, addressing my specific confusions, become my textbook.

This year I added another step: I take those notes plus a rough outline and draft blog posts with Claude Code, using a custom skill that encodes my writing style and preferences (I wrote about a similar approach for [translations](@/blog/translation-with-claude-code.md)). I edit in Neovim and collaborate through the IDE integration. If something in my draft isn't clear to me, I revise until it is.

The key insight: **by the end of the conversation, the material reflects my updated understanding**. Not a static text I had to adapt to, but a document that adapted to me.

## Prompt-First Learning

The vision I keep returning to:

- **Start**: Source material (textbook section, paper, video transcript) plus a learner profile (background, goals, preferred learning style)
- **Loop**: AI engages in conversation. The text updates dynamically based on what confuses you. You also answer assessment questions as you go.
- **End state**: A document co-authored with you, shaped by the questions you asked along the way.

Static text assumes all readers have the same gaps. Dynamic text fills *your* gaps as they emerge. This isn't a tutor you consult when the textbook fails you—it's the primary path, and the document you co-author is the lasting artifact.

This is obviously oversimplifying. A real system would need to maintain factual accuracy as content adapts, and in formal education, ensure coverage of shared fundamentals across a student population. Hard problems. But the direction feels right.

Google's [future work section](https://arxiv.org/pdf/2509.13348) hints at something similar: "*The system could be made more adaptive, by dynamically adjusting the learning material to the performance of the learner on assessment components.*" We're circling the same idea.

## Experimenting Here

I'm planning to hack on this directly on this blog. Run some experiments, see what sticks. The shape might look like this: you read a section, and if something doesn't make sense, you can ask questions in a sidebar or modal. The post adapts (not the entire thing, but the specific passages where you're stuck). You'd get a version of the post written for your confusions, not a generic audience's.

As a first step, I recently added comments to this blog. If readers point out where they got confused, I can update the post to address those gaps. It's manual, and it's not truly personalized—everyone sees the same updated text. But it's the same loop: feedback in, clearer text out. Per-reader adaptation could come later.

The core loop exists today if you're willing to do it manually. Read a post, open Claude, ask about the parts you don't understand, iterate. The challenge is building a UX that makes this seamless and frictionless, with as few back-and-forths as possible to get you unstuck.

## Beyond Understanding

Prompt-first learning gets you to understanding. But understanding is just the first step. You also need to retain what you learned, and sometimes you want to learn in a different modality.

On retention: I learned Japanese despite starting at 23, and the primary reason was [Anki](https://apps.ankiweb.net/) flashcards with spaced repetition. Imagine a system that builds cards automatically from the areas where you struggled, exports them via API, and schedules reviews at optimal intervals. Understand through conversation, commit to memory through repetition.

On modality: a Japanese friend recently tried to read my posts on [private keys](@/blog/math-behind-private-key.md) and [digital signatures](@/blog/secrets-and-signatures.md). His approach: feed both to NotebookLM and ask for a podcast explaining elliptic curves using Pokemon analogies. In Japanese. The [result](https://drive.google.com/file/d/1WHzCb_1I8f_OAGiKehAbtkZ91GgH1D3X/view) is hilarious but surprisingly accurate; the metaphors held up when I compared them to my original descriptions. This isn't prompt-first learning—there's no back-and-forth—but it shows how far content can flex while staying faithful to the source.

## Why Now

AI is widening the gap between how we learn and how we could learn. Andrej Karpathy [put it well](https://youtu.be/lXUZvyajciY?si=pV2gwP7Fe9kN7Gl8&t=7731) on the Dwarkesh podcast last October: "*pre-AGI education is useful, post-AGI education is fun. People will go to school like they go to the gym—because it's enjoyable, keeps you sharp, and intelligence is attractive in the way a six-pack is attractive.*"

I buy into that vision, but I'd add: smart people will be attractive not just for their nuanced views on [P vs NP](https://en.wikipedia.org/wiki/P_versus_NP_problem) at dinner parties, but because they put their knowledge to use. Society rewards people who are useful. That's a discussion for another post.

For now, I'm excited about what's possible. Learn Your Way opens a door. I'm curious to see what's on the other side.

---

*This post was written in collaboration with [Claude](https://claude.ai) (Opus 4.5).*
