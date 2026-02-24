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
            { label: 'Implementation', slug: 'reference/implementation' },
            { label: 'SST for Static Hosting', slug: 'reference/sst-hosting' },
          ],
        },
        {
          label: 'How-To Guides',
          items: [
            { label: 'Register a Docs Microsite', slug: 'how-to/register-microsite' },
            { label: 'Local Development', slug: 'how-to/local-development' },
          ],
        },
      ],
      customCss: [],
    }),
  ],
});
