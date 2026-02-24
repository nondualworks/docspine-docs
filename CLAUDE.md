# Docspine — Claude Code Context

## What This Is

Docspine is an open-source specification for federated documentation aggregation. Teams author docs independently in their own repos using any framework (MkDocs, Astro, Docusaurus). A central pipeline aggregates them under a single searchable domain.

## Key Files

- `docspine.yaml` — The manifest contract. Each participating repo declares team, domain, service, framework, and paths.
- `Justfile` — Three standard targets: `docs-build`, `docs-serve`, `docs-check`. Framework-agnostic interface.
- `docs-registry.yaml` — Lists repos the pipeline should build. Lives in the pipeline repo.

## Architecture

```
Team repos → Concourse pipeline → S3 + CloudFront → docs.company.com
```

Infrastructure: SST (StaticSite component) → S3 + CloudFront + ACM + Route53. ~$1.50/month.
Search: Pagefind (static, MIT licensed, framework-agnostic).
URL structure: `docs.company.com/{domain}/{service}/` — grouped by DDD bounded context.

## This Repo

This repo contains the Docspine specification documentation (Astro Starlight site), examples, and infrastructure templates:

- `src/content/docs/` — Starlight documentation site (Diataxis: explanation, reference, how-to)
- `src/content.config.ts` — Content collection config (required for Starlight + Astro 5)
- `public/llms.txt` — AI-readable content discovery file (served at /docspine/llms.txt)
- `examples/mkdocs-team/` — Example repo with docspine.yaml + Justfile
- `examples/registry/` — Example docs-registry.yaml
- `docker/` — Builder image Dockerfile
- `iam/` — AWS IAM policy for the deploy role
- `scripts/` — Landing page generator, LocalStack exercise script

## Tech Stack

- Astro 5 + Starlight 0.37.x
- Deployed to GitHub Pages via `.github/workflows/deploy.yml`
- Live at: https://nondualworks.github.io/docspine

## Organization

- **Company:** Nondual Works (github.com/nondualworks)
- **Product:** Spine (Internal Developer Platform)
- **This specification:** Docspine (open-source, standalone)

## Philosophy

Documentation-first development. V0 docs before V1 code. Nondual thinking: docs and code, human and AI readers, authoring and publishing are not separate concerns. Diataxis structure serves as machine semantics for AI/LLM consumption.
