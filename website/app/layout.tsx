import type { Metadata } from "next";
import { Sora, Inter } from "next/font/google";
import "./globals.css";
import { Toaster } from "react-hot-toast";

const sora = Sora({
  subsets: ["latin"],
  variable: "--font-sora",
  display: "swap",
  weight: ["500", "600", "700", "800"],
});

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
  display: "swap",
  weight: ["400", "500", "600"],
});

export const metadata: Metadata = {
  title: {
    default: "Wall My Paper — Premium 4K Wallpapers & Backgrounds",
    template: "%s | Wall My Paper",
  },
  description:
    "Your screen, your story. Discover, preview in realistic phone frames, and download stunning 4K and AMOLED wallpapers created by world-class digital artists.",
  keywords: [
    "wallpapers",
    "4K wallpapers",
    "AMOLED wallpapers",
    "free wallpapers",
    "phone backgrounds",
    "iPhone wallpapers",
    "Android wallpapers",
    "Wall My Paper",
    "WMP",
  ],
  openGraph: {
    title: "Wall My Paper — Premium 4K Wallpapers",
    description: "Your screen, your story. Discover & download stunning 4K wallpapers.",
    type: "website",
    locale: "en_US",
    siteName: "Wall My Paper",
  },
  twitter: {
    card: "summary_large_image",
    title: "Wall My Paper — Premium 4K Wallpapers",
    description: "Your screen, your story. Discover & download stunning 4K wallpapers.",
  },
  robots: {
    index: true,
    follow: true,
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className={`${sora.variable} ${inter.variable}`}>
      <body className="bg-[var(--color-bg)] text-[var(--color-text)] antialiased font-sans selection:bg-[var(--color-primary)] selection:text-white">
        {children}
        <Toaster
          position="bottom-center"
          toastOptions={{
            style: {
              background: "var(--color-surface-2)",
              color: "var(--color-text)",
              border: "1px solid var(--color-border)",
              borderRadius: "14px",
              boxShadow: "0 10px 30px rgba(0, 0, 0, 0.4)",
            },
          }}
        />
      </body>
    </html>
  );
}
