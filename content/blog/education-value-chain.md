+++
title = "The Education Value Chain: Where AI Fits"
date = 2026-01-29
description = "Education isn't one thing. Decomposing it into stages reveals where technology can actually help."

[taxonomies]
tags = ["ai", "education"]

[extra]
social_media_card = "/img/education-value-chain.webp"
stylesheets = ["css/details.css"]
+++

<img src="/img/education-value-chain.webp" alt="The education value chain: Discovery, Learning, Assessment, and Credentialing.">

On January 21, 2026, Google announced [SAT practice tests inside Gemini](https://blog.google/products-and-platforms/products/education/practice-sat-gemini/) (free, full-length, AI-graded). The next day, OpenAI launched [Education for Countries](https://openai.com/index/edu-for-countries/) at Davos, a program helping governments bring AI into their national education systems. Google's move is specific; OpenAI's is broader. Either way, AI in education is accelerating.

The question is *where* in education. "AI will transform education" is about as actionable as "software will fix business." A high schooler choosing between nursing and computer science has a different problem than a bootcamp student struggling with recursion, who has a different problem than a hiring manager trying to verify a candidate's credentials. Which part of education are we talking about? This post tries to answer that by decomposing education into stages, mapping what's broken at each, and sketching where technology could intervene.

## The Value Chain

Education, viewed from the learner's perspective, is a four-stage value chain. Each stage answers a different question:

{% table() %}

| Stage | Function | Core Question |
|-------|----------|---------------|
| Discovery | Navigate options, find direction | What should I learn? |
| Learning | Acquire knowledge and skills | How do I learn it? |
| Assessment | Measure what was learned | Did I learn it? |
| Credentialing | Signal competence to others | How do I prove it? |
{% end %}

Similar stage-based models exist in professional certification and learning science,[^1] but none were simple enough to use off the shelf, so I built this one. As far as I can tell, it's comprehensive.

Consider a working professional pivoting from marketing to data science. She starts at **Discovery**: researching which skills matter, comparing programs, reading job postings to understand what employers actually want. She moves to **Learning**: working through a curriculum, building projects, filling gaps in statistics and Python. Then **Assessment**: taking practice tests, submitting portfolio projects for feedback, measuring herself against job requirements. Finally, **Credentialing**: earning a certification, building a public portfolio, getting a reference from a mentor. Each stage has different failure modes and different opportunities for technology to help.

These stages are sequential but not strictly linear. Our career-switcher might loop back from Assessment to Learning when she discovers a gap. A student might cycle between Learning and Assessment many times before reaching Credentialing. The value chain describes the logical progression, not a rigid pipeline.

[^1]: The closest parallels are Learn-Practice-Certify (common in professional certification) and the seven-step transformative learning cycle from [De Witt et al. (2024)](https://journals.sagepub.com/doi/10.1177/15413446231220317).

## What's Broken: Stage by Stage

Each stage breaks in its own way. Here's what learners, educators, and employers might run into.

<img src="/img/four-stages-education.webp" alt="The four stages of the education value chain — Discovery, Learning, Assessment, and Credentialing — each with their pain points.">

I count fifteen pain points across the four stages, each with a one-line summary. Not exhaustive, but I'm pretty sure it hits the 80/20 bar:

### Discovery

<ol>
<li><strong>Orientation</strong>: hard to pin down the intersection of what you're interested in, what you're good at, what the world needs (and what pays)</li>
<li><strong>Access</strong>: suitable programs are hard to find, and harder to finance</li>
</ol>

### Learning

<ol start="3">
<li><strong>Motivation</strong>: learners lose momentum and disengage before they hit an intellectual ceiling</li>
<li><strong>Curricula</strong>: one-size-fits-all not adapted to prior knowledge or preferred pace</li>
<li><strong>Content</strong>: generic textbooks and materials that lack the learner's goals or background</li>
<li><strong>Feedback loops</strong>: learners don't know they're off track until midterms or finals</li>
</ol>

### Assessment

<ol start="7">
<li><strong>Identity</strong>: verifying the test-taker in online settings is invasive and imperfect</li>
<li><strong>Cheating</strong>: language models can write passable essays and solve problem sets</li>
<li><strong>Validity</strong>: passing an exam about debugging is not the same as being able to debug</li>
<li><strong>Anxiety</strong>: some students know the material but perform poorly under exam conditions</li>
</ol>

### Credentialing

<ol start="11">
<li><strong>Granularity</strong>: a four-year degree bundles hundreds of skills; a single badge says almost nothing</li>
<li><strong>Fraud</strong>: diploma mills issue credentials that look legitimate</li>
<li><strong>Portability</strong>: credits from college X don't transfer to college Y</li>
<li><strong>Decay</strong>: credentials don't reflect whether skills have been maintained since they were issued</li>
<li><strong>Opacity</strong>: credentials are claims backed by reputation, not auditable evidence</li>
</ol>

Without a map, you might build a better textbook and call it progress — never noticing that credentialing is the actual bottleneck. The stages force you to see all the pieces and ask: where does improvement matter most?

## Putting the Stages to Work

Now that we have the stages and their pain points, we can ask: what would it look like if we pointed current AI capabilities and other emerging technologies at each one? What follows are thought experiments — one per stage — not validated solutions.

### Discovery: AI Career Pathfinding Agent

<img src="/img/career-pathfinding-agent.webp" alt="An AI pathfinding agent analyzing uploaded documents and mapping career trajectories across data science, UX design, and AI ethics paths.">

Current AI can already parse documents, reason over structured data, and generate scenario-based analysis. A pathfinding agent would combine these capabilities: you upload your resume, transcripts, and anything else that captures where you are, and the AI cross-references it against real-time labor market data, job postings, and skill taxonomies to build a picture of where you could go. Not a quiz result — a simulation: invest six months in Python and statistics, and here's how your employability shifts across three career paths. Pivot to UX instead, and here's what changes. The four-dimensional discovery problem (interest, aptitude, demand, compensation) becomes a navigable decision space.

### Learning: Prompt-First Learning

<img src="/img/you-choose-your-own-adventure.webp" alt="A prompt-first learning system where conversation adapts in real-time to the learner's gaps and questions.">

Large language models can already hold extended, context-aware conversations and adapt their explanations on the fly. A prompt-first learning system would make that conversation the path, not a supplement: you ask about the parts that confuse you, push back when something doesn't click, and the material reshapes itself in real-time. The end artifact is co-authored study notes shaped by your specific gaps, questions, and journey. I wrote about this in more detail in [Prompt-First Learning](@/blog/prompt-first-learning.md).

### Assessment: AI-Assessed Performance Tasks

<img src="/img/ai-assessed-performance.webp" alt="An AI-assessed performance task where the system observes a learner debugging code in real-time.">

Today's models are multimodal and can react in real-time: they can watch your screen, follow your keystrokes, and interpret what you're doing as you do it. An AI-assessed performance system would use this to replace exams with task simulations. Instead of answering questions about how to debug code, you debug code — and the AI observes your process, not just your final answer. Instead of writing about project management principles, you work through a scenario while the AI evaluates your decisions as they happen. Every learner's task unfolds differently based on their choices, making certain forms of cheating significantly harder. What you're assessed on is closer to what you'd do on the job.

### Credentialing: Evidence-Anchored Credentials

<img src="/img/evidence-based-credentials.webp" alt="An evidence-anchored credentialing system storing verifiable proof of skills on a blockchain.">

Blockchain can make any record instantly verifiable and tamper-proof. An evidence-anchored credentialing system would go further: the chain stores not just the claim ("this person passed") but hashes of what was actually demonstrated — assessment responses, project artifacts, evaluator scores. The credential becomes a transparent container rather than an opaque badge. Anyone verifying it can audit the evidence behind it, shifting trust from issuer reputation to verifiable proof. This addresses fraud (credentials can't be forged), portability (anyone can verify without contacting the issuer), and opacity (the evidence is auditable).

## What's Next

Many actors participate across these stages, each with different incentives and constraints:

- **Learners**: K-12 students, university students, working adults
- **Providers**: institutions, platforms, bootcamps
- **Employers**: hiring managers, recruiters
- **Gatekeepers**: government entities, accreditors, credentialing bodies

Future posts will pick a stage, consider these actors in context, and dig into the most pressing pain points and the most promising uses of technology within that stage.

This is a starting framework. It may be missing a few pieces, or the boundaries may shift as I dig deeper. If you see a gap, I'd like to hear about it.

---

*This post was written in collaboration with [Claude](https://claude.ai) (Opus 4.5).*
