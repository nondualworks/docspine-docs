#!/bin/bash
# scripts/generate-landing-page.sh
# Reads docs-registry.yaml and generates the landing page with Pagefind search.
# Requires: yq (https://github.com/mikefarah/yq)

set -e

OUTPUT_DIR="${1:-./aggregated-site}"
REGISTRY="${2:-docs-registry.yaml}"

mkdir -p "$OUTPUT_DIR"

cat > "$OUTPUT_DIR/index.html" << 'HEADER'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Documentation Hub</title>
  <link href="/_pagefind/pagefind-ui.css" rel="stylesheet">
  <style>
    body { font-family: system-ui, -apple-system, sans-serif; max-width: 800px; margin: 2rem auto; padding: 0 1rem; }
    h1 { margin-bottom: 0.5rem; }
    .subtitle { color: #666; margin-bottom: 2rem; }
    .domain-group { margin-bottom: 1.5rem; }
    .domain-name { font-size: 1.1rem; font-weight: 600; color: #333; margin-bottom: 0.5rem; }
    .service-list { list-style: none; padding: 0; }
    .service-list li { padding: 0.4rem 0; }
    .service-list a { color: #2563eb; text-decoration: none; }
    .service-list a:hover { text-decoration: underline; }
    .team-badge { font-size: 0.75rem; color: #888; margin-left: 0.5rem; }
  </style>
</head>
<body>
  <h1>Documentation Hub</h1>
  <p class="subtitle">Search across all services or browse by domain.</p>
  <div id="search"></div>
  <script src="/_pagefind/pagefind-ui.js"></script>
  <script>
    new PagefindUI({ element: "#search", showSubResults: true });
  </script>
  <hr>
  <h2>Services</h2>
HEADER

# Parse registry and generate directory
yq -r '.repos[] | "  <div class=\"domain-group\"><div class=\"domain-name\">" + .domain + "</div><ul class=\"service-list\"><li><a href=\"/" + .domain + "/" + .service + "/\">" + .service + "</a><span class=\"team-badge\">" + .team + "</span></li></ul></div>"' "$REGISTRY" >> "$OUTPUT_DIR/index.html"

echo "</body></html>" >> "$OUTPUT_DIR/index.html"

echo "Landing page generated at $OUTPUT_DIR/index.html"
