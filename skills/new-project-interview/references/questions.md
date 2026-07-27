# Question Bank — new-project-interview

Banco de perguntas, pros/cons e recomendacoes p/ cada fase. Use como referencia durante a entrevista — adapte ao contexto do usuario.

---

## Phase 1: Purpose

### Q1: Learning vs earning?

> "Esse projeto é p/ aprender uma tecnologia nova ou p/ ganhar dinheiro resolvendo um problema real?"

**Se aprender:**
| Opcao | Pro | Contra |
|-------|-----|--------|
| Qualquer stack nova | Vai aprender de verdade | Entrega mais lenta |
| Projeto pessoal sem pressao | Liberdade p/ experimentar | Pode nunca terminar |

- Recomendacao: Escolha algo que te empolgue mas resolva um problema real. Projeto sem proposito praticar raramente termina.

**Se ganhar dinheiro:**
| Opcao | Pro | Contra |
|-------|-----|--------|
| Stack que ja domina | Entrega rapida, menos bugs | Nao aprende nada novo |
| Framework batteries-included | MVP sai mais rapido | Dependency lock-in |
| Terceirizar infra (PaaS) | Foco no produto | Custo mensal maior |

- Recomendacao: Use o que ja sabe. Se for cliente pagando, batery-included framework (NextJS, Django, Laravel) acelera MVP.

### Q2: Solo vs team?

> "Vc vai desenvolver sozinho ou tem time?"

| Cenario | Implicacao |
|---------|------------|
| Solo | Monolito + framework opinado > microservicos. Menos ferramental de colaboracao. |
| Time 2-3 | Precisa de padronizacao (linter, code review, branch strategy) |
| Time 5+ | Monorepo ou multirepo? CI/CD obrigatorio. Testes obrigatorios. |

- Solo: recomende estrutura simples, sem over-engineering.
- Time: recomende definir convencoes desde o dia 1 (AGENTS.md, linter, git flow).

### Q3: Deadline / orcamento?

> "Tem deadline ou orcamento mensal p/ infra?"

- Deadline curto: maximizar reuso, minimizar customizacao. Nao inventar moda.
- Orcamento baixo: SQLite ou Postgres barato (Railway free tier). VPS R$21/mes da HostGator.
- Sem deadline: pode investir em arquitetura mais robusta, mas cuidado com over-engineering.

### Q4: Stack que ja domina?

> "Quais tecnologias vc ja domina hoje? O que usaria de olhos fechados?"

Use essa resposta como ancora p/ recomendacoes. Se ja domina JS/TS, recomende ecosystem JS. Se ja domina Python, ecosystem Python.

---

## Phase 2: Stack

### Frontend

| Tecnologia | Quando escolher |
|------------|----------------|
| **NextJS** | SPA + SEO + SSR. Fullstack JS. Maior ecosystem. _Recomendado p/ maioria dos casos JS_ |
| **Vite + React** | Dashboard interno, app sem necessidade de SEO. Mais leve que NextJS |
| **SvelteKit** | Performance, menos boilerplate. Ecosystem menor |
| **Vue/Nuxt** | Preferencia pessoal. Mercado BR forte |
| **HTMX + template** | App backend-heavy, pouca interacao JS. Simplicidade maxima |

### Backend

| Tecnologia | Pro | Contra |
|------------|-----|--------|
| **Node/Express** (ou Hono/Fastify) | Se ja domina JS. Gigante ecosystem | Async pode ser verboso |
| **Python/Django** | Batteries-included. Admin nativo. ORM maduro | Performance limitada. Async recente |
| **Python/FastAPI** | Async nativo. Type-safe. Otimo p/ APIs | Ecosystem menor que Django |
| **Go** | Performance, simplicidade, deploy binario unico | Curva de aprendizado. Ecosystem menor |
| **Ruby/Rails** | Produtividade maxima. Convention over config | Performance. Mercado BR menor |
| **PHP/Laravel** | Mercado BR forte. Hosting barato. Batteries-included | Sintaxe verbosa. Nao escala bem |

### Database

| Opcao | Pro | Contra |
|-------|-----|--------|
| **PostgreSQL** (recomendado) | Maduro, extensoes (PostGIS, pgvector), ferramental BR, escalavel | Mais recursos (pouco contra) |
| **SQLite** | Zero config, arquivo unico, otimo p/ prototipo | Nao escala p/ multiusuario concorrente |
| **MySQL** | Onipresente em hosting BR | Menos features modernas que Postgres |
| **MongoDB** | Schema flexivel, rapido p/ prototipar | Sem relacoes nativas, consistency tradeoffs |

### ORM

| Opcao | Pro | Contra |
|-------|-----|--------|
| **Drizzle** (JS/TS) | Leve, type-safe, migrations automaticas, proximo de SQL | Ecosystem menor que Prisma |
| **Prisma** (JS/TS) | Produtivo, schema declarativo, migrations faceis | Pesado, geracao de codigo lenta |
| **Django ORM** (Python) | Maduro, migrations automaticas, admin | Muito acoplado ao Django |
| **SQLAlchemy** (Python) | Flexivel, maduro, independente de framework | Mais boilerplate |
| **ActiveRecord** (Ruby/Rails) | Produtivo, convention | Acoplado ao Rails |

---

## Phase 3: MVP

### Core entities

Pergunte qual a entidade mais importante. Ex:
- "Seu sistema tem Users? Projects? Tasks? Posts? Orders?"
- "Qual o fluxo principal do usuario? O que ele faz primeiro?"

**Recomendacao:** Modele 1-2 entidades principais + relacoes basicas. Nao modele o futuro.

### Auth

> "Precisa de login desde o inicio?"

| Opcao | Pro | Contra |
|-------|-----|--------|
| **Sim, auth ja** | Produto real precisa de auth. Mais facil agora que depois | Tempo extra no setup |
| **Nao, deixa p/ depois** | MVP mais rapido | Depois refatorar é mais caro |

Recomendacao: Sim, auth ja. Lucide/Clerk (JS) ou django-allauth (Python) — 30min de setup.

### Folder structure

Se JS/TS:
```
src/
├── app/          # routes/pages
├── components/   # UI components
├── lib/          # business logic
├── db/           # schema + migrations
└── tests/        # test files
```

Se Python:
```
project/
├── app/
├── domain/
├── infra/
├── tests/
└── config/
```

---

## Phase 4: Deploy

### VPS vs PaaS vs Serverless

| Opcao | Pro | Contra |
|-------|-----|--------|
| **VPS nacional** (HostGator, Locaweb) | Latencia BR, R$21/mes, controle total | Configuracao manual, responsabilidade de manutencao |
| **Railway** | Deploy simples, bom free tier, internacional | Mais caro que VPS. Sem datacenter BR |
| **Vercel** | Otimo p/ NextJS. Deploy automatico. Free tier generoso | So frontend+serverless. Backend limitado |
| **Fly.io** | Edge computing, bom p/ apps globais | Documentacao densa |

**Recomendacao:** Se publico brasileiro, VPS em SP (HostGator). Se global, Railway ou Vercel.

### CI/CD

| Ferramenta | Pro |
|------------|-----|
| **GitHub Actions** (recomendado) | Gratuito p/ repos publicos, integracao nativa, ecosystem gigante |
| GitLab CI | Se ja usa GitLab |

Recomendacao: GitHub Actions. Setup: testar no PR, fazer deploy automatico ao mergear p/ main.

### Docker

| Opcao | Pro | Contra |
|-------|-----|--------|
| **Docker** | Ambiente reprodutivel, facil deploy em VPS | Curva de aprendizado, recursos extras |
| **Sem Docker** | Simplicidade | "Na minha maquina funciona" |

Recomendacao: Se VPS, sim (Docker + docker-compose). Se Vercel/Railway, nao precisa.

---

## Phase 5: Tests

### Types of tests

| Tipo | Quando |
|------|--------|
| **Unit tests** (recomendado desde inicio) | Testar logica de negocios, funcoes puras |
| **Integration tests** | Testar interacao com DB, API endpoints |
| **E2E** | So depois do MVP. Fluxos criticos apenas |

### Framework

| Ecosystem | Recomendado |
|-----------|-------------|
| JS/TS | Vitest (rapido, moderno, compatibilidade com Jest) |
| Python | pytest (padrao ouro) |

### CI pipeline

Recomendacao: Rodar tests em todo PR. Bloquear merge se falhar.

---

## Phase 6: DX

### AGENTS.md

> "Vou criar um AGENTS.md com instrucoes p/ IA trabalhar nesse projeto. O que vc quer incluir?"

Sugestoes:
- Comandos p/ rodar tests, dev server, build
- Padroes de codigo (TDD? componentes puros? error handling?)
- Estrutura de pastas
- Convencoes de nomenclatura
- Checklist de code review

### Linter/Formatter

| Ecosystem | Recomendado |
|-----------|-------------|
| JS/TS | ESLint + Prettier |
| Python | Ruff (rapido, substitui flake8 + isort + black) |

### Commits

Recomendacao: Conventional Commits (`feat:`, `fix:`, `chore:`, etc). Facilita geracao de changelog.

---

## Dynamic adaptation rules

1. **Pule perguntas irrelevantes.** Se usuario ja tem DB decidido, nao pergunte de novo. So valide se faz sentido.
2. **Aprofunde quando necessario.** Se usuario falar "quero algo escalavel", pergunte: "quantos usuarios vc espera no primeiro mes?" — isso muda tudo.
3. **Encurte quando estiver obvio.** Se usuario falar "NextJS + Postgres", so documente e va p/ proxima fase.
4. **Recomendacao obrigatoria.** Toda pergunta deve terminar com "Recomendo X porque...". Nao seja neutro.
