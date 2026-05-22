import './globals.css';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Shoor | شور',
  description: 'Saudi legal directory and consultation platform',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return <html lang="ar" dir="rtl"><body>{children}</body></html>;
}
