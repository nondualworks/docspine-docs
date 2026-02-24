# Docspine

**A specification for federated documentation — by humans, for humans and machines.**

Teams author docs independently. A pipeline aggregates them under one searchable domain. That's it.

```
Team repos (MkDocs, Astro, Docusaurus)  →  Pipeline  →  docs.company.com
```

## The Problem

Your organization has 30 services. Their documentation is scattered across GitHub Pages sites, Confluence pages, READMEs, and local builds nobody can find. Engineers waste time hunting for context. Auditors can't locate compliance docs. AI assistants have no single corpus to query.

## The Solution

Docspine defines a two-file contract between team repos and a central aggregation pipeline:

**`docspine.yaml`** — declares what the docs are:
```yaml
team: payments
domain: checkout          # Business domain (not team name)
service: checkout-api
nav_title: Checkout API
framework: mkdocs
source_dir: docs/
output_dir: site/
```

**`Justfile`** — exposes three standard build targets:
```just
docs-build:   # Build static HTML
docs-serve:   # Serve locally
docs-check:   # Validate (strict mode)
```

The pipeline calls `just docs-build` and deploys the output. Teams own their docs. The platform owns discoverability.

## What You Get

- **One domain** — `docs.company.com/{domain}/{service}/` for every registered service
- **Cross-service search** — Pagefind indexes all sites, zero infrastructure
- **Auto-deploy** — push to main → docs live in minutes
- **Framework-agnostic** — MkDocs, Astro, Docusaurus — anything that produces HTML
- **LLM-ready** — generates `llms.txt` on the unified domain; Diataxis URL structure serves as machine-parseable metadata
- **$1.50/month** — S3 + CloudFront, no servers

## Quick Start

Add two files to your repo:

```bash
# 1. Create the manifest
cat > docspine.yaml << 'EOF'
team: my-team
domain: my-domain
service: my-service
nav_title: My Service
framework: mkdocs
source_dir: docs/
output_dir: site/
EOF

# 2. Create the Justfile
cat > Justfile << 'EOF'
docs-build:
    cd docs && mkdocs build --site-dir ../site

docs-serve:
    cd docs && mkdocs serve

docs-check:
    cd docs && mkdocs build --strict --site-dir ../site
EOF

# 3. Verify locally
just docs-build
just docs-serve   # → http://localhost:8000
```

Then open a PR to your organization's `docs-registry.yaml` to register your service.

## Why Not Backstage TechDocs?

Backstage TechDocs locks you into MkDocs with a specific plugin chain. Teams with existing Docusaurus or Astro sites can't participate without migrating. TechDocs requires adopting Backstage itself.

Docspine is **contract-based, not tool-based**. The contract (`docspine.yaml` + Justfile) is framework-agnostic. Your pipeline can be Concourse, GitHub Actions, GitLab CI — anything. Your hosting can be S3, Cloudflare Pages, Netlify — any static host. Teams keep their tools.

## Documentation

Full documentation is available at **[nondualworks.github.io/docspine](https://nondualworks.github.io/docspine)**.

- **[Capability Overview](https://nondualworks.github.io/docspine/explanation/capability-overview/)** — What Docspine is and why it exists
- **[Philosophy](https://nondualworks.github.io/docspine/explanation/philosophy/)** — Documentation-first development and the LLM multiplier
- **[Implementation Reference](https://nondualworks.github.io/docspine/deployment/implementation/)** — Pipeline, SST, Concourse, Docker, LocalStack
- **[Manifest Schema](https://nondualworks.github.io/docspine/reference/manifest-schema/)** — The `docspine.yaml` contract
- **[Register a Microsite](https://nondualworks.github.io/docspine/how-to/register-microsite/)** — Step-by-step onboarding guide
- **[Develop Your Docs Locally](https://nondualworks.github.io/docspine/how-to/local-docs/)** — Preview and validate docs before pushing

## Examples

The [`examples/`](./examples) directory contains:

- **`mkdocs-team/`** — A complete example repo with `docspine.yaml`, `Justfile`, and MkDocs site
- **`registry/`** — An example `docs-registry.yaml` for the aggregation pipeline

## Origin

Docspine was created by the platform engineering team at [Nondual Works](https://github.com/nondualworks) as the documentation specification for [Spine](https://usespine.dev), an Internal Developer Platform. We open-sourced it because the pattern is useful independent of any IDP.

The specification is informed by a philosophy we call **documentation-first development**: V0 documentation exists before V1 code. When documentation and code are treated as one concern — not two — both humans and AI systems benefit from the structure.

## Contributing

We'd love feedback from PE practitioners. Open an issue to share your experience, suggest improvements, or discuss how you'd adapt the approach for your organization.

## License

MIT
