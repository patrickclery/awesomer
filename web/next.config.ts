import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  output: 'export',
  basePath: process.env.BASE_PATH || '',
  env: { NEXT_PUBLIC_BASE_PATH: process.env.BASE_PATH || '' },
  images: {
    unoptimized: true,
  },
  trailingSlash: true,
  staticPageGenerationTimeout: 180,
};

export default nextConfig;
