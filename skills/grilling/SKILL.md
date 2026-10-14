---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.

## Asking a round

If an interactive question tool is available (`AskUserQuestion` in Claude Code), ask every round through it:

- The tool takes at most 4 questions per call. If the frontier is larger, split the round into consecutive calls of up to 4 questions each, and send them all before starting the next round.
- Each question needs 2–4 concrete options. Put your recommendation first and add "(Recommended)" to its label. Use each option's `description` for the trade-off. The user can always pick "Other" to type a free answer, so open-ended questions (budgets, dates, names) still work: offer your best guesses as options.
- Keep the question text self-contained: include the facts the user needs to decide, such as numbers you found. If a question needs more background than fits, give a short plain-text preamble before the call, then ask.
- Use `multiSelect` only when the options genuinely combine.
- If the user rejects the tool or asks for plain text, switch to the text format below for the rest of the session.

Without an interactive question tool, write the round as text, like so:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>

---

❓ **Q2** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, etc.), dispatch a sub-agent to find it; don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report; ask the rest of the frontier now. The _decisions_ are the user's: put each to them and wait.

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding.
