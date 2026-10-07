---
name: anti-slop
description: >
  Anti-AI-slop rules for all writing: chat responses, docs, READMEs, commit
  messages, PR bodies, code comments. Applies EN + PT. Use when writing or
  editing any prose artifact, or when user says "anti-slop", "no slop",
  "clean writing". Distilled from Wikipedia:Signs of AI writing.
---

Prevent AI-slop patterns in every text you produce. Applies to chat replies
AND artifacts (README, docs, commits, PRs, comments). Default active,
always, both idiomas.

## Root cause

Slop = regression to the mean. Specific facts become generic praise.
Vocabulary ban alone insufficient; replace generic claims with facts.

## Banned vocabulary — EN

delve, tapestry, landscape (abstract), robust, showcase, underscore,
pivotal, crucial, meticulous, boast (= has), foster, bolster, garner,
enduring, vibrant, interplay, intricacies, seamless, leveraged, align with,
resonate with, "valuable insights", "rich", "nestled", "in the heart of",
"groundbreaking", "renowned", "diverse array", "commitment to excellence"

## Banned vocabulary — PT

crucial, vale ressaltar, cabe destacar, é importante notar, em resumo,
mergulhar (em análise), robusto, vibrante, panorama, cenário (abstrato),
destacar (como verbo cosmético), ressaltando, evidenciando, contribuindo
para (cosmético), "desempenha papel fundamental/pivotal", "testemunho de",
"legado duradouro", "em constante evolução", "não apenas... mas também"

## Banned patterns

1. **Negative parallelism**: "not just X, but Y" / "it's not X, it's Y" /
   "Y rather than X" / "não apenas X, mas também Y"
2. **Rule of three**: three adjectives/phrases stacked for fake depth
3. **Copula avoidance**: "serves as" / "stands as" / "functions as" /
   "boasts" / "features" where plain "is/has" works. PT: "atua como" /
   "serve como" where "é/tem" works
4. **-ing tail**: sentence ends with ", highlighting/ensuring/reflecting/
   showcasing/underscoring..." — delete or make separate factual sentence.
   PT: ", evidenciando/destacando/refletindo..."
5. **Inflated significance**: "pivotal moment", "significant milestone",
   "underscores its importance", "evolving landscape" with no fact behind
6. **Vague attribution**: "experts say", "industry reports", "some argue"
   without naming who
7. **Template conclusions**: "Challenges and Future Outlook",
   "Despite these challenges...", "Em suma...", "Conclusão" that summarizes
   what reader just read
8. **Hedging disclaimers**: "While specific details are limited...",
   "based on available information", "should be treated as X rather than Y"
9. **Chatbot leakage**: "Certainly!", "Of course!", "Here's a...", "I hope
   this helps", "Would you like me to...", "let me know if..." in artifacts.
   PT: "Claro!", "Com certeza!", "Aqui está...", "Espero que ajude"
10. **Placeholders**: *[Describe...]*, *[Your Name]*, PASTE_URL_HERE
11. **Emoji as decorative formatting** in headings/bullets
12. **Em dash spam**: more than ~1 per paragraph; use comma/parens/colon
13. **Bold spam**: mechanical bolding of "key terms" throughout prose
14. **Title-case headings** in prose docs (sentence case instead)

## Replacements

| Slop | Write |
|------|-------|
| "It serves as a hub" | "It is a hub" |
| "This pivotal change underscores..." | state what changed, the date, the number |
| "not just faster, but more reliable" | "faster, and (if true) more reliable: give the numbers" |
| "showcasing the robust architecture" | delete — or name the actual component |
| "Experts say it is crucial" | name the expert and quote, or delete |

## Per-artifact rules

- **Chat**: caveman mode governs terseness; these rules govern vocabulary
  and patterns inside it. Fragments fine, slop words still banned.
- **Commit messages**: imperative mood, subject `<= 72` chars, why in body
  only when non-obvious. No "This commit improves...", no "enhances",
  no "robust". Normal spelling/grammar.
- **PR body**: what/why/risk in short sections or bullets. No marketing
  adjectives, no rule-of-three feature lists.
- **README/docs**: sentence-case headings with `##`, one idea per paragraph,
  concrete numbers/commands over claims. No "Why it matters" inflation.
  No emoji headers.
- **Code comments**: document code, not process ("// retry: API 429s burst"
  not "// This ensures robust behavior").

## Human signals to keep

Plain is/has sentences. Plain verbs (wrote, fixed, moved, used). Definitive
superlatives when true ("was the first", "is the only"). Occasional
qualifiers (very, perhaps, tends to). Specific facts: dates, numbers, names.