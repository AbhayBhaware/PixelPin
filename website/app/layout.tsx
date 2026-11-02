import type { Metadata } from "next";
import "./globals.css";
import { Toaster } from "react-hot-toast";

export const metadata: Metadata = {
  title: {
    default: "PixelPin — Curated 4K & HD Wallpapers for Android",
    template: "%s | PixelPin",
  },
  description:
    "Your screen, your story. Discover, preview in realistic phone frames, and download stunning 4K and AMOLED wallpapers created by world-class digital artists.",
  keywords: [
    "PixelPin",
    "wallpapers",
    "4K wallpapers",
    "AMOLED wallpapers",
    "free wallpapers",
    "phone backgrounds",
    "Android wallpapers",
    "HD wallpapers",
  ],
  openGraph: {
    title: "PixelPin — Curated 4K Wallpapers for Android",
    description: "Your screen, your story. Discover & download stunning 4K wallpapers.",
    type: "website",
    locale: "en_US",
    siteName: "PixelPin",
  },
  twitter: {
    card: "summary_large_image",
    title: "PixelPin — Curated 4K Wallpapers",
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
    <html lang="en">
      <head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link
          href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Sora:wght@600;700;800&display=swap"
          rel="stylesheet"
        />
      </head>
      <body className="bg-[var(--color-bg)] text-[var(--color-text)] antialiased font-sans selection:bg-[var(--color-primary)] selection:text-white">
        {children}
        <Toaster
          position="bottom-center"
          toastOptions={{
            style: {
              background: "#FFFFFF",
              color: "#0F172A",
              border: "1px solid #E2E8F0",
              borderRadius: "14px",
              boxShadow: "0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.05)",
              fontWeight: 500,
              fontSize: "14px",
            },
          }}
        />
      </body>
    </html>
  );
}
