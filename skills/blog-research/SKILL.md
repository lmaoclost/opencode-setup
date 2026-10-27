---
name: blog-research
description: Research what people are actually saying about a topic right now, to feed blog post ideas. Pulls recent Hacker News threads, Reddit discussions, and web results via public endpoints — no API keys. Use when the user asks "research X", "what are people saying about X", "angles for a post about X", "pesquisar pauta sobre X", or invokes /research <topic>. Output is a structured brief in Portuguese, saved to the Obsidian vault.
---

# blog-research

Pesquisa opinião recente sobre um tema pra alimentar pauta de post de blog.
Diferença de `topic-distill`: aquela pega UMA URL e extrai conceitos. Esta
varre a conversa pública de um TEMA e devolve ângulos, discordâncias e
lacunas que valem post.

**Sem chaves de API.** Só ferramentas nativas (`websearch`, `webfetch`) e
endpoints públicos. Nada de `SCRAPECREATORS_API_KEY`, nada de credencial.

## Invocation

```
/research <tema> [--janela 30d] [--idioma pt] [--context "por que isso importa agora"]
```

`--janela` default `30d`. `--idioma` default `pt` (saída em PT; fontes em
qualquer idioma). `--context` opcional — prioriza ângulos alinhados ao
objetivo do usuário e vai no frontmatter.

## Sources

| Fonte | Endpoint | Sem chave? |
|-------|----------|-----------|
| Hacker News (histórias) | `https://hn.algolia.com/api/v1/search?query=Q&tags=story&hitsPerPage=20` | Sim |
| Hacker News (comentários) | `https://hn.algolia.com/api/v1/search?query=Q&tags=comment&hitsPerPage=30` | Sim |
| Reddit (busca) | `https://www.reddit.com/r/SUB/search.json?q=Q&restrict_sr=1&sort=new` | Sim, mas bloqueia anônimo às vezes |
| Web geral | `websearch` | Sim |

Ordem de esforço: HN primeiro (mais confiável, sem bloqueio), depois
`websearch`, depois Reddit como reforço. Se Reddit devolver 403, **não
insista** — registra a fonte como indisponível e segue.

## Workflow

### Step 1 — Normalizar o tema

Extrai 3-5 termos de busca: o termo literal, sinônimos, o nome do projeto
se houver, e a forma inglesa do termo. Busca em PT costuma devolver pouco;
busca em EN costuma devolver muito. **Busca sempre nas duas** e anota a
diferença de volume — ela mesma é achado.

### Step 2 — Puxar fontes

Roda os endpoints acima. Pra HN, usa `created_at` pra filtrar dentro da
janela. Guarda pra cada hit: título, URL, pontos, nº de comentários, data.

### Step 3 — Ler os comentários, não só os títulos

Título diz o que o post é. Comentário diz o que as pessoas **discordam**.
É onde a pauta mora. Pra cada thread de alto engajamento, puxa os
comentários e procura: reclamação recorrente, workaround improvisado,
comparação com alternativa, previsão que pode estar errada.

### Step 4 — Sintetizar

Quatro seções, obrigatórias. Se uma sair vazia, diz que saiu vazia — não
inventa.

## Output

Vai pro chat **e** pra `3. Resources/raw-research/YYYY-MM-DD-slug-do-tema.md`
no vault (`/home/renan/code/obsidian-backup`).

Frontmatter: `tema`, `data`, `janela`, `fontes` (lista), `contexto`
(se `--context` dado), `type: research`.

### Formato do chat

**O que estão dizendo**
Panorama factual. Volume por fonte, período, direção do sentimento.

**Pontos de calor**
Threads com mais engajamento. Cada uma: título, link, nº de comentários,
e a frase que resume a discordância.

**Ângulos pro post**
3-5 ângulos. Cada um com: a pergunta que o post responderia, a fonte que
sustenta, e por que ninguém publicou ainda (se ninguém publicou — se
já publicaram, diz e sugere o diferencial).

**Lacunas**
O que a conversa NÃO cobriu. Geralmente a parte técnica mais funda, o
caso de borda, ou a conta de custo.

Depois, **Connections** — como os ângulos se relacionam entre si, no mesmo
formato do `topic-distill`.

## Regras

- Cita link real de cada afirmação. Sem link = não afirma.
- Números verbatim. "muita gente reclamou" é proibido; "47 comentários
  reclamando de X em 3 threads" é o mínimo.
- Não confunde volume de menção com consenso. 200 upvotes num sub não é
  opinião da indústria.
- Datas sempre. Um thread de 29 dias atrás não é "recente".
- Saída em PT, exceto nomes de projeto, CLI, e trecho citado.

## Boundaries

Não gera texto de post — só pesquisa. Escrita é com o usuário.
Não cria nota zettelkasten final. Igual ao `topic-distill`: extração, não
conclusão.
