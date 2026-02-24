# Shape Up Pitch: Federated Documentation Aggregator

> **Appetite:** 4 weeks (2 engineers)
> **Status:** Ready to bet
> **Author:** Phanidhar
> **Date:** February 2026

---

## Problem

Our teams maintain MkDocs documentation in their individual repos. These docs sites are either:
- Hosted as standalone GitHub Pages that nobody can find
- Built locally and never deployed
- Replaced by Confluence pages that rot

The result: engineers can't discover documentation across services, auditors can't find compliance docs, new team members waste days hunting for context, and leadership has no visibility into what documentation exists.

When someone asks "where are the docs for the checkout API?", the answer is "let me Slack the payments team." That's not documentation — that's tribal knowledge with a docs/ directory.

---

## Appetite

**4 weeks, 2 engineers.** Not 6. This is infrastructure plumbing with a well-understood pattern — not a product with unknowns. The engineers have Concourse and AWS experience. The moving parts (S3, CloudFront, MkDocs, Concourse) are all familiar territory.

If it takes longer than 4 weeks, we've over-engineered it.

---

## Solution

A pipeline that aggregates MkDocs sites from multiple repos and hosts them under a single domain with unified search.

### How It Works

```
Team repos (MkDocs)  →  Concourse pipeline  →  S3 + CloudFront  →  docs.{company}.com
```

1. Teams add two files to their repo: a manifest (`docspine.yaml`) and a `Justfile` with standard build targets
2. A registry file lists which repos to build
3. Concourse watches those repos; on change, it runs `just docs-build`, copies the output to an aggregated S3 bucket organized by domain/service
4. A CloudFront distribution serves everything under one domain with HTTPS
5. Pagefind generates a cross-service search index at deploy time

### The Contract (What Teams Provide)

**`docspine.yaml`** — declares what this service's docs are:

```yaml
team: payments
domain: checkout            # business domain (DDD)
service: checkout-api
nav_title: Checkout API
framework: mkdocs
source_dir: docs/
output_dir: site/
```

**`Justfile`** — three standard targets:

```just
docs-build:
    cd docs && mkdocs build --site-dir ../site

docs-serve:
    cd docs && mkdocs serve --dev-addr 0.0.0.0:8000

docs-check:
    cd docs && mkdocs build --strict --site-dir ../site
```

This is the entire onboarding cost for a team. Two files, five minutes.

### URL Structure

Organized by business domain (not team), configurable via the registry:

```
docs.{company}.com/
├── checkout/
│   └── checkout-api/
├── identity/
│   └── auth-gateway/
├── platform/
│   ├── notification-worker/
│   └── base-images/
└── index.html              ← Landing page + Pagefind search
```

The `domain` field in the manifest drives the top-level grouping. If we later decide team-based grouping is better, we change one config flag in the aggregation pipeline — teams don't touch anything.

### Infrastructure

SST (Serverless Stack) deploys the static hosting: S3 bucket, CloudFront distribution, ACM certificate, Route53 DNS. Five lines of TypeScript, $1-3/month at our scale. IAM policy is scoped and documented — no AdministratorAccess.

Concourse runs the build pipeline, using a shared MkDocs builder Docker image (Python + MkDocs Material + Just).

LocalStack enables full local development — engineers exercise the entire deploy flow on their machines before touching real AWS.

---

## Rabbit Holes

**SST + LocalStack integration quirks.** SST v3 uses Pulumi internally, and its high-level `StaticSite` component may not work perfectly against LocalStack. **Mitigation:** We have an `exercise-local.sh` script that creates every AWS resource directly via `awslocal`. Use this for local validation; reserve SST for real deploys. Don't spend more than half a day debugging SST ↔ LocalStack.

**Cross-service search indexing edge cases.** Pagefind indexes HTML output regardless of generator framework — it works. But unusual MkDocs themes may put content in non-standard HTML elements. **Mitigation:** Default to MkDocs Material theme (which we'll provide via scaffold). If a team uses a weird theme, Pagefind still works — it just might index nav elements. Fix with `data-pagefind-*` attributes later.

**Pipeline parameterization.** Concourse requires a separate job definition per repo, which gets repetitive. **Mitigation:** Start with manual job definitions for the first 3-4 repos. If it becomes painful, write a pipeline generator script in Week 3. Don't over-abstract in Week 1.

**DNS propagation delays.** Custom domain + CloudFront + ACM certificate validation can take 15-30 minutes on first deploy. **Mitigation:** Deploy the placeholder site in Week 1, Day 1. Let DNS propagate while doing other work. Don't block on it.

**MkDocs version conflicts.** Different teams may use different MkDocs plugin versions. **Mitigation:** The builder Docker image pins MkDocs + Material to specific versions. Teams that need custom plugins can extend the base image (documented in onboarding guide). Don't try to support arbitrary plugin matrices in Week 1.

---

## No-Gos

- **No Astro/Starlight/Docusaurus support in this cycle.** MkDocs only. We'll add framework flexibility in a future cycle. The contract (manifest + Justfile) is framework-agnostic by design — teams won't need to change anything when we add support later.
- **No auto-discovery of repos.** Manual registry file. Auto-scanning the GitHub org for `docspine.yaml` is a nice-to-have, not a need-to-have.
- **No custom themes or branding per team.** Teams use whatever MkDocs theme they want, but the aggregator doesn't impose or customize. The landing page is a simple HTML directory.
- **No authentication or access control.** The site is either internal-only (VPN) or public. No per-team or per-role access gating.
- **No live editing or CMS.** This is static site aggregation. Teams edit docs in their repos, push, and the pipeline deploys. No WYSIWYG.
- **No Spine integration in this cycle.** This is a standalone PE capability. Spine will consume the same contract later, but this pipeline has no Spine dependency.

---

## Scopes

### Scope 1: Infrastructure Foundation (Week 1)

| Task | Owner |
|------|-------|
| SST project setup (S3 + CloudFront + Route53 + ACM) | Engineer 1 |
| Deploy placeholder site, confirm domain + HTTPS work | Engineer 1 |
| Docker image: MkDocs + Material + Just (push to ECR) | Engineer 1 |
| LocalStack docker-compose + exercise-local.sh | Engineer 1 |
| Pick pilot MkDocs repo, add manifest + Justfile | Engineer 2 |
| Create `docs-registry.yaml` with pilot entry | Engineer 2 |
| Concourse pipeline repo structure | Engineer 2 |
| IAM role `docs-pipeline-deployer` with scoped policy | Engineer 2 |

**Done when:** Placeholder site is live at `docs.{company}.com`. Builder image is in ECR. Pilot repo builds locally with `just docs-build`.

### Scope 2: Pipeline + End-to-End (Week 2)

| Task | Owner |
|------|-------|
| Concourse pipeline YAML for pilot repo | Engineer 1 |
| GitHub webhook → Concourse trigger | Engineer 1 |
| Full flow test: push to pilot → Concourse builds → S3 | Engineer 1 |
| Deploy job (S3 sync + CloudFront invalidation) | Engineer 2 |
| Landing page generator (from registry) | Engineer 2 |
| End-to-end test: docs change → live on site within 5 min | Engineer 2 |

**Done when:** Push a docs change to the pilot repo → site updates automatically at `docs.{company}.com/{domain}/{service}/`.

### Scope 3: Onboard + Search + Polish (Week 3)

| Task | Owner |
|------|-------|
| Onboard 2-3 more team repos to the registry | Both |
| Multi-repo builds verified (no conflicts) | Both |
| Pagefind cross-service search on landing page | Engineer 1 |
| Slack notification on build success/failure | Engineer 2 |
| Edge case handling: build failures, missing files | Both |

**Done when:** 3-4 services' docs are live. Search works across all of them. Slack alerts on failures.

### Scope 4: Documentation + Handoff (Week 4)

| Task | Owner |
|------|-------|
| User Guide: "How to add your team's docs" | Engineer 2 |
| SST Reference Guide for PE team | Engineer 1 |
| Pipeline operational runbook (troubleshooting, scaling) | Both |
| Demo to PE team + stakeholders | Both |
| Retrospective: what worked, what to improve | Both |

**Done when:** Any team can self-service onboard their MkDocs site by following the guide. Pipeline runs unattended. PE team understands the infrastructure.

---

## Estimated Cost

| Resource | Monthly Cost |
|----------|-------------|
| S3 storage (static HTML, < 1GB) | $0.02 |
| CloudFront (internal traffic, < 10GB) | $0.85 |
| Route53 hosted zone | $0.50 |
| ACM certificate | Free |
| ECR (builder image, < 1GB) | $0.10 |
| Concourse (existing PE infrastructure) | $0.00 (already running) |
| **Total** | **~$1.50/month** |

---

## Why Now

1. **Immediate value.** Every team that has MkDocs docs gets discoverability and search for free. No product decision needed.
2. **Validates the federated docs pattern.** The manifest + Justfile contract is the exact interface Spine's Documentation Hub will consume. Teams adopt it now for its own value; Spine benefits later with zero migration.
3. **Two engineers are available.** Concourse + AWS expertise already on the team. The work fits their skills perfectly.
4. **Low risk.** Static site hosting is a solved problem. The contract pattern is well-understood. If it doesn't work, we've lost 4 weeks of two engineers — not a product bet.

---

## Future Cycles (Not This One)

- **Multi-framework support:** Astro/Starlight, Docusaurus, Hugo. The contract is already framework-agnostic — pipeline just needs to handle different build commands.
- **Auto-discovery:** Scan GitHub org for repos with `docspine.yaml` instead of maintaining a registry.
- **Scaffold command:** `spine scaffold --template docs` (or standalone `pe-docs scaffold`) generates a starter MkDocs project with manifest, Justfile, and Diataxis skeleton.
- **Spine Documentation Hub integration:** Spine reads the same manifest, aggregates under its catalog, adds scorecard scoring for documentation completeness.
- **AI/MCP endpoint:** Single docs domain = MCP-ready corpus for AI agents to search and reference.
