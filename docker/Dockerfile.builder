# docker/Dockerfile.builder
# Shared build environment for all Docspine pipeline jobs.

FROM python:3.12-slim

# MkDocs + Material theme + common plugins
RUN pip install --no-cache-dir \
    mkdocs==1.6.* \
    mkdocs-material==9.* \
    mkdocs-awesome-pages-plugin \
    mkdocs-minify-plugin

# Just (command runner)
RUN curl -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin

# Node.js (for teams with npm-based plugins or Pagefind)
RUN apt-get update && apt-get install -y --no-install-recommends \
    nodejs npm \
    && rm -rf /var/lib/apt/lists/*

# Pagefind (cross-service search indexer)
RUN npm install -g pagefind

WORKDIR /workspace
