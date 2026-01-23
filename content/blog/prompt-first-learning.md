+++
title = "Prompt-First Learning"
date = 2026-01-22
description = "What if textbooks adapted to your questions, not the other way around?"

[taxonomies]
tags = ["ai", "education"]

[extra]
social_media_card = "/img/you-choose-your-own-adventure.webp"
+++

![Prompt-First Learning: You choose where the story goes](/img/you-choose-your-own-adventure.webp)

Since the holiday break, I've been thinking about AI and education. It's a big part of why I started this blog two weeks ago, right after wrapping up a 10-year stint at Amazon. I wanted to experiment with how AI can help teach. Though my goals are also selfish: I learn best by teaching. Feynman had it right: if you can't explain something simply, you don't understand it well enough. And honestly, few things give me a bigger high than finally getting something to click.

A [tweet](https://x.com/AriaWestcott/status/2013153611715350783) crossed my feed last week: "BREAKING: Google just dropped the textbook killer." A system called Learn Your Way that transforms PDFs into personalized learning materials. I got excited—then clicked through to the [blog post](https://research.google/blog/learn-your-way-reimagining-textbooks-with-generative-ai/) and saw September 2025. Not exactly breaking, more like resurfacing. Still, I wanted to see what they'd built.

So I tried the [demo](https://learnyourway.withgoogle.com/) and read the [paper](https://arxiv.org/pdf/2509.13348), published earlier this month. I'm glad a company with Google's resources is investing in this space. What they've built is not trivial: LearnLM transforms PDFs into multiple formats (immersive text, slides with narration, audio-graphic lessons, mind maps), adjusts to your grade level, tailors examples to your interests, and embeds questions throughout to check understanding. The quiz at the end of each section gives you an assessment with strengths and growth areas.

<video autoplay loop muted playsinline>
  <source src="https://pub-94e31bf482a74272bb61e9559b598705.r2.dev/video/learn-your-way.mp4" type="video/mp4">
</video>

Here's where I was disappointed. I set my persona to "undergraduate interested in painting" and loaded the Hydrocarbons module. I went through the material, answered questions, got my assessment. At the end, the artifact I was left with was the original text plus one added sentence: "*We find hydrocarbons in many artist materials—for instance, the turpentine used to thin oil paints or the mineral spirits for cleaning brushes.*" No study notes reflecting my journey. No document shaped by where I struggled. The infrastructure works (format transformations, assessment pipeline, all of it), but after all that interaction, I walked away with the same material everyone else gets. I was left wondering if augmenting existing material was going to be the best direction to take for AI x Learning. No, there's probably something much more fundamental waiting to be built.

## The Problem with Augmentation

Most textbooks aren't written for you. They're written for broad audiences, optimized for the middle of the bell curve. They can't anticipate where *you* will get stuck or what background *you* bring. Augmenting that kind of source material—even with smart personalization—doesn't change the underlying problem: the text still wasn't written with your specific gaps, your specific questions, your way of learning in mind.

Anyone who's been through school knows the workaround: you write your own notes. The textbook is input; your notes are output, shaped by what confused you and what finally clicked. Those notes, not the textbook, are what you review before exams.

Learn Your Way's current approach is augmentation: take the source, add personalized touches, present it in different formats. That's valuable, but it doesn't help you write those notes. What's missing is the **natural language back-and-forth**: the chance to say "wait, I don't get this part" and **have the material respond in near real-time**.

## What Works for Me

Here's what's been working for me over the past year. I start a conversation with Claude about a topic: tell it what I'm trying to understand, my background, how I learn best. For me, that often means math; unless I see the formulas, I feel like I only have a superficial grasp. A friend of mine learns better through analogies. We're different, and that's the point.

I go back and forth: asking about the parts that confuse me, pushing back when something doesn't click, keeping at it until I get it. When I'm done, I have Claude save review notes directly to Obsidian via an MCP server (in plain markdown; no vendor lock-in), with special attention to the areas that gave me difficulty. Those notes, addressing my specific confusions, also become my textbook.

This year I added another step: I take those notes plus a rough outline and draft blog posts with Claude Code, using a custom skill that encodes my writing style and preferences (I wrote about a similar approach for [translations](@/blog/translation-with-claude-code.md)). I edit in Neovim and collaborate through the IDE integration. If something in my draft isn't clear, I keep revising until it is, whether manually or through more back-and-forth with Claude.

**By the end of the conversation, the material reflects my updated understanding**. Not a static text I had to adapt to, but a document that adapted to me.

## Prompt-First Learning

The flow looks like this:

- **Start**: Enter what you want to learn, what you already know, how you learn best. Source material (textbook section, paper, video transcript) can ground the conversation, but isn't required.
- **Loop**: The AI engages in conversation with you, occasionally searching online as needed to ground itself. The text updates dynamically based on what confuses you. You also answer assessment questions as you go.
- **End state**: Study notes co-authored with you, shaped by the questions you asked and responses you gave along the way.

Static text assumes other readers have the same gaps. Dynamic text fills *your* gaps as they emerge.

This isn't an "AI tutor," a helper you consult when the textbook fails. In prompt-first learning, conversation is the path, and the study notes you co-author are what you keep. You also choose where to go: which rabbit holes to explore, which tangents to follow. *Choose Your Own Adventure*, but for learning.

This is easier said than done. A production system needs to maintain factual accuracy as content adapts, and in formal education, ensure coverage of shared fundamentals across a student population. Hard problems. But this direction feels right.

Google's [future work section](https://arxiv.org/pdf/2509.13348) hints at something similar: "*The system could be made more adaptive, by dynamically adjusting the learning material to the performance of the learner on assessment components.*" It looks like we're circling similar ideas.

## Experimenting Here

I'm planning to hack on this directly on this blog. Run some experiments, see what sticks. The shape might look like this: you read a section, and if something doesn't make sense, you can ask questions in a sidebar or modal. The post adapts (not the entire thing, but the specific passages where you're stuck). You'd get a version of the post written for your sticking points, not a generic audience's.

The core loop exists today if you're willing to do it manually: read a post, open Claude, ask about the parts you don't understand, iterate. The challenge is building a UX that makes this seamless.

## Beyond Understanding

Prompt-first learning gets you to understanding. But understanding is just the first step. You also need to retain what you learned, and sometimes you want to learn in a different modality.

On retention: I learned Japanese despite starting at 23, and the primary reason was [Anki](https://apps.ankiweb.net/) flashcards with spaced repetition. Imagine a system that builds cards automatically from the areas where you struggled, exports them via API, and schedules reviews at optimal intervals. Understand through conversation, commit to memory through repetition.

On modality: a Japanese friend recently tried to read my posts on [private keys](@/blog/math-behind-private-key.md) and [digital signatures](@/blog/secrets-and-signatures.md). His approach: feed both to NotebookLM and ask for a podcast explaining elliptic curves using Pokemon analogies. In Japanese. The result is hilarious but surprisingly accurate; the metaphors held up when I compared them to my original descriptions. This isn't prompt-first learning—there's no back-and-forth—but it shows how far content can flex while staying faithful to the source.

<div class="centered">
<audio controls>
  <source src="https://pub-94e31bf482a74272bb61e9559b598705.r2.dev/audio/pokemon-elliptic-curves.mp3" type="audio/mpeg">
</audio>
</div>

## Why Now

AI is widening the gap between how we learn and how we could learn. Andrej Karpathy [put it well](https://youtu.be/lXUZvyajciY?si=pV2gwP7Fe9kN7Gl8&t=7731) on the Dwarkesh podcast last October: "*pre-AGI education is useful, post-AGI education is fun. People will go to school like they go to the gym—because it's enjoyable, keeps you sharp, and intelligence is attractive in the way a six-pack is attractive.*" I buy into that vision. I'd add: smart people will be attractive not just for their nuanced views on [P vs NP](https://en.wikipedia.org/wiki/P_versus_NP_problem) at dinner parties, but because they put their knowledge to use. Society rewards people who are useful. Though that's a discussion for another post.

Learn Your Way helps learners; their paper includes results to prove it. But the bigger opportunity isn't better augmentation. It's prompt-first: conversation as the path, study notes shaped by each learner's journey.

---

*This post was written in collaboration with [Claude](https://claude.ai) (Opus 4.5).*
