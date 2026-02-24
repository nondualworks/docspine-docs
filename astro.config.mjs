import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

export default defineConfig({
  site: 'https://nondualworks.github.io',
  base: '/docspine',
  integrations: [
    starlight({
      title: 'Docspine',
      description: 'A specification for federated documentation — by humans, for humans and machines.',
      social: [
        { icon: 'github', label: 'GitHub', href: 'https://github.com/nondualworks/docspine' },
      ],
      sidebar: [
        {
          label: 'Explanation',
          items: [
            { label: 'Capability Overview', slug: 'explanation/capability-overview' },
            { label: 'Philosophy', slug: 'explanation/philosophy' },
          ],
        },
        {
          label: 'Reference',
          items: [
            { label: 'Manifest Schema', slug: 'reference/manifest-schema' },
          ],
        },
        {
          label: 'Deployment Guides',
          items: [
            { label: 'GitHub Actions + GitHub Pages', slug: 'deployment/github-pages' },
            { label: 'GitHub Actions + AWS (SST)', slug: 'deployment/sst-hosting' },
            { label: 'Concourse + AWS', slug: 'deployment/implementation' },
          ],
        },
        {
          label: 'How-To Guides',
          items: [
            { label: 'Register a Docs Microsite', slug: 'how-to/register-microsite' },
            { label: 'Develop Your Docs Locally', slug: 'how-to/local-docs' },
          ],
        },
      ],
      customCss: [],
    }),
  ],
});
