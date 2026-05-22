import type { MetadataRoute } from 'next';
export default function sitemap(): MetadataRoute.Sitemap { return [{ url: 'https://shoor.sa', changeFrequency: 'daily', priority: 1 }]; }
