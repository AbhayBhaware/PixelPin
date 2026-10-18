import Link from "next/link";
import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Wall My Paper — Premium 4K Wallpapers & Phone Backgrounds",
  description:
    "Your screen, your story. Discover and download curated 4K, AMOLED, and anime wallpapers. Free, fast, zero login required.",
};

const SAMPLE_WALLPAPERS = [
  {
    id: "w1",
    title: "Neon Cyber Horizon",
    category: "AMOLED",
    badge: "4K",
    creator: "AetherArt",
    downloads: "14.2K",
    gradient: "from-purple-900 via-indigo-950 to-black",
    aspect: "aspect-[9/16]",
  },
  {
    id: "w2",
    title: "Misty Alpine Dawn",
    category: "Nature",
    badge: "4K",
    creator: "Elena Vance",
    downloads: "9.8K",
    gradient: "from-emerald-900 via-teal-950 to-slate-900",
    aspect: "aspect-[9/14]",
  },
  {
    id: "w3",
    title: "Midnight Void",
    category: "AMOLED",
    badge: "AMOLED",
    creator: "OnyxStudio",
    downloads: "21.5K",
    gradient: "from-neutral-900 via-black to-zinc-950",
    aspect: "aspect-[9/18]",
  },
  {
    id: "w4",
    title: "Tokyo Rainy Alley",
    category: "Anime",
    badge: "NEW",
    creator: "Kenji Sato",
    downloads: "6.1K",
    gradient: "from-violet-950 via-fuchsia-950 to-slate-950",
    aspect: "aspect-[9/15]",
  },
  {
    id: "w5",
    title: "Galactic Nebula Core",
    category: "Space",
    badge: "4K",
    creator: "CosmoLens",
    downloads: "18.3K",
    gradient: "from-blue-900 via-indigo-950 to-purple-950",
    aspect: "aspect-[9/16]",
  },
  {
    id: "w6",
    title: "Minimal Dunes",
    category: "Minimal",
    badge: "4K",
    creator: "SoraDesign",
    downloads: "11.4K",
    gradient: "from-amber-950 via-stone-900 to-neutral-950",
    aspect: "aspect-[9/14]",
  },
];

const CATEGORIES = [
  "All",
  "AMOLED",
  "Nature",
  "Anime",
  "Abstract",
  "Minimal",
  "Space",
  "Cars",
  "Cyberpunk",
  "Dark",
];

export default function HomePage() {
  return (
    <main className="min-h-screen bg-[var(--color-bg)] text-[var(--color-text)]">
      {/* Navigation Header */}
      <nav className="glass fixed top-0 left-0 right-0 z-50 px-6 py-4 flex items-center justify-between border-b border-[var(--color-border)]">
        <Link href="/" className="flex items-center gap-3 group">
          {/* Logo Frame: Rounded square with gradient mountain/wave */}
          <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-[var(--color-primary)] to-[var(--color-accent)] p-[2px] shadow-lg shadow-[var(--color-primary)]/20 transition-transform group-hover:scale-105">
            <div className="w-full h-full bg-[var(--color-surface)] rounded-[14px] flex items-center justify-center">
              <svg
                className="w-5 h-5 text-white"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="2.2"
                strokeLinecap="round"
                strokeLinejoin="round"
              >
                <path d="m8 3 4 8 5-5 5 15H2L8 3z" />
              </svg>
            </div>
          </div>
          <div className="flex flex-col">
            <span className="font-heading font-extrabold text-xl tracking-tight text-white flex items-center gap-1.5">
              Wall My Paper
              <span className="text-[10px] uppercase font-bold tracking-wider px-1.5 py-0.5 rounded-full bg-[var(--color-primary)]/20 text-[var(--color-primary)] border border-[var(--color-primary)]/30">
                4K
              </span>
            </span>
          </div>
        </Link>

        {/* Center links */}
        <div className="hidden md:flex items-center gap-7 text-sm font-medium">
          <Link
            href="/explore"
            className="text-[var(--color-text-muted)] hover:text-white transition-colors"
          >
            Explore
          </Link>
          <Link
            href="/categories"
            className="text-[var(--color-text-muted)] hover:text-white transition-colors"
          >
            Categories
          </Link>
          <Link
            href="/collections"
            className="text-[var(--color-text-muted)] hover:text-white transition-colors"
          >
            Collections
          </Link>
          <Link
            href="/become-creator"
            className="text-[var(--color-accent)] hover:text-white transition-colors flex items-center gap-1"
          >
            <span>★</span> Become a Creator
          </Link>
        </div>

        {/* Right CTA */}
        <div className="flex items-center gap-3">
          <Link
            href="/studio"
            className="btn-ghost hidden sm:inline-flex text-sm py-2 px-4"
          >
            Creator Studio
          </Link>
          <a
            href="https://play.google.com/store"
            target="_blank"
            rel="noopener noreferrer"
            className="btn-primary text-sm py-2 px-5 flex items-center gap-2"
          >
            <svg className="w-4 h-4 fill-current" viewBox="0 0 24 24">
              <path d="M3 20.5v-17c0-.83 1.01-1.3 1.6-.73L21.3 11.5a1 1 0 010 1l-16.7 8.73C3.01 21.8 3 21.33 3 20.5z" />
            </svg>
            <span>Get App</span>
          </a>
        </div>
      </nav>

      {/* Hero Section */}
      <section className="relative pt-36 pb-20 px-6 overflow-hidden">
        {/* Ambient atmospheric glows */}
        <div
          className="absolute top-10 left-1/3 w-[500px] h-[500px] rounded-full blur-[140px] opacity-25 pointer-events-none"
          style={{ background: "radial-gradient(circle, var(--color-primary), transparent 70%)" }}
        />
        <div
          className="absolute top-48 right-1/4 w-[400px] h-[400px] rounded-full blur-[130px] opacity-20 pointer-events-none"
          style={{ background: "radial-gradient(circle, var(--color-accent), transparent 70%)" }}
        />

        <div className="relative z-10 max-w-4xl mx-auto text-center">
          {/* Tagline Pill */}
          <div className="inline-flex items-center gap-2.5 px-4 py-2 rounded-full text-xs font-semibold uppercase tracking-wider mb-8 bg-[var(--color-surface-2)] border border-[var(--color-border)] text-[var(--color-text-muted)] shadow-md">
            <span className="w-2 h-2 rounded-full bg-[var(--color-success)] animate-ping" />
            Your screen, your story
          </div>

          <h1 className="font-heading text-5xl sm:text-6xl md:text-7xl font-extrabold tracking-tight leading-[1.08] mb-6">
            Walls worth{" "}
            <span className="gradient-text">looking at.</span>
          </h1>

          <p className="text-[var(--color-text-muted)] text-lg md:text-xl max-w-2xl mx-auto mb-10 leading-relaxed font-normal">
            A premium collection of high-res 4K, AMOLED, and aesthetic wallpapers.
            Zero login required to browse, preview in realistic phone frames, or download.
          </p>

          {/* Search bar inside Hero */}
          <div className="max-w-2xl mx-auto mb-8">
            <div className="relative flex items-center rounded-2xl bg-[var(--color-surface)] border border-[var(--color-border)] p-2 shadow-2xl focus-within:border-[var(--color-primary)] transition-all">
              <svg
                className="w-5 h-5 ml-3 text-[var(--color-text-muted)]"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth="2"
                  d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
                />
              </svg>
              <input
                type="text"
                placeholder="Search by keyword, mood, category (e.g. AMOLED dark, Neon Cyberpunk)..."
                className="w-full bg-transparent px-4 py-2 text-sm text-[var(--color-text)] placeholder-[var(--color-text-muted)] focus:outline-none"
              />
              <button className="btn-primary text-sm py-2 px-6 rounded-xl flex items-center gap-1.5 shrink-0">
                Explore
              </button>
            </div>
          </div>

          {/* Category Chips Scroll */}
          <div className="flex items-center justify-center gap-2 overflow-x-auto py-2 no-scrollbar">
            {CATEGORIES.map((cat, idx) => (
              <button
                key={cat}
                className={
                  idx === 0
                    ? "chip-pill-active"
                    : "chip-pill hover:border-[var(--color-primary)]/50"
                }
              >
                {cat}
              </button>
            ))}
          </div>
        </div>
      </section>

      {/* Masonry Wallpaper Feed */}
      <section className="py-12 px-6 max-w-7xl mx-auto">
        <div className="flex items-center justify-between mb-8">
          <div>
            <h2 className="font-heading text-2xl md:text-3xl font-bold">
              Trending <span className="gradient-text">Right Now</span>
            </h2>
            <p className="text-sm text-[var(--color-text-muted)] mt-1">
              Handpicked 4K originals curated from top creators
            </p>
          </div>
          <Link
            href="/explore"
            className="text-sm font-semibold text-[var(--color-primary)] hover:underline flex items-center gap-1"
          >
            View all →
          </Link>
        </div>

        {/* Masonry Columns Grid */}
        <div className="masonry-grid">
          {SAMPLE_WALLPAPERS.map((wall) => (
            <div key={wall.id} className="masonry-item mb-5 group">
              <div
                className={`relative rounded-2xl overflow-hidden bg-gradient-to-b ${wall.gradient} ${wall.aspect} border border-[var(--color-border)] shadow-lg transition-transform duration-300 group-hover:-translate-y-1.5`}
              >
                {/* Top Badge */}
                <div className="absolute top-3 left-3 z-10">
                  <span
                    className={`text-[10px] font-heading font-bold px-2 py-0.5 rounded-full shadow-md ${
                      wall.badge === "4K"
                        ? "bg-[var(--color-primary)] text-white"
                        : wall.badge === "AMOLED"
                        ? "bg-black text-[var(--color-primary)] border border-[var(--color-primary)]/40"
                        : "bg-[var(--color-accent)] text-white"
                    }`}
                  >
                    {wall.badge}
                  </span>
                </div>

                {/* Hover overlay with download & favorite buttons */}
                <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent opacity-0 group-hover:opacity-100 transition-opacity p-4 flex flex-col justify-end">
                  <span className="font-heading font-semibold text-white text-sm">
                    {wall.title}
                  </span>
                  <div className="flex items-center justify-between mt-2">
                    <span className="text-xs text-white/70">
                      by {wall.creator}
                    </span>
                    <button className="p-2 rounded-full bg-white/20 hover:bg-white/30 backdrop-blur-md text-white transition-colors">
                      <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
                      </svg>
                    </button>
                  </div>
                </div>

                {/* Subtle bottom info for non-hover state */}
                <div className="absolute bottom-3 left-3 right-3 flex items-center justify-between text-xs text-white/80 group-hover:opacity-0 transition-opacity">
                  <span className="font-medium truncate">{wall.title}</span>
                  <span className="text-[10px] text-white/60 shrink-0">
                    {wall.downloads}
                  </span>
                </div>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* Standout Features Grid */}
      <section className="py-24 px-6 border-t border-[var(--color-border)] bg-[var(--color-surface)]/50">
        <div className="max-w-6xl mx-auto">
          <div className="text-center max-w-2xl mx-auto mb-16">
            <h2 className="font-heading text-3xl md:text-4xl font-extrabold mb-4">
              Designed for <span className="gradient-text">Wallpaper Lovers</span>
            </h2>
            <p className="text-[var(--color-text-muted)] text-base">
              Built with uncompromising attention to visual fidelity, speed, and creator empowerment.
            </p>
          </div>

          <div className="grid md:grid-cols-3 gap-6">
            {[
              {
                icon: "📱",
                title: "Phone Preview Mode",
                desc: "Preview wallpapers in realistic lock and home screen mockups before downloading. No more guessing how clock widgets look.",
              },
              {
                icon: "✨",
                title: "Strict 4K Standard",
                desc: "Every wallpaper must pass our 3840×2160 resolution audit. Crisp, pin-sharp details on AMOLED, Retina, and folding screens.",
              },
              {
                icon: "⚡",
                title: "Zero Friction Browsing",
                desc: "No accounts, no paywalls, no login forced upon you. Just open, admire, and save.",
              },
              {
                icon: "🎨",
                title: "Color-Driven Discovery",
                desc: "Match your setup with our color palette search and dedicated pure-black AMOLED category.",
              },
              {
                icon: "💎",
                title: "Fair Creator Revenue",
                desc: "70% of platform earnings distributed to creators based on transparent engagement score metrics.",
              },
              {
                icon: "🛡️",
                title: "Original & Verified",
                desc: "Human-in-the-loop review queue to filter out duplicates, stolen art, and low-res noise.",
              },
            ].map((f) => (
              <div
                key={f.title}
                className="p-7 rounded-2xl bg-[var(--color-surface-2)] border border-[var(--color-border)] hover:border-[var(--color-primary)]/40 transition-all hover:shadow-xl hover:shadow-[var(--color-primary)]/5"
              >
                <div className="text-3xl mb-4">{f.icon}</div>
                <h3 className="font-heading font-bold text-lg mb-2 text-white">
                  {f.title}
                </h3>
                <p className="text-[var(--color-text-muted)] text-sm leading-relaxed">
                  {f.desc}
                </p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Become a Creator CTA Banner */}
      <section className="py-24 px-6">
        <div className="max-w-5xl mx-auto rounded-3xl p-10 md:p-14 text-center relative overflow-hidden bg-gradient-to-br from-[var(--color-surface-2)] to-[var(--color-surface)] border border-[var(--color-border)] shadow-2xl">
          <div
            className="absolute -top-24 -left-24 w-80 h-80 rounded-full blur-3xl opacity-20 pointer-events-none"
            style={{ background: "radial-gradient(circle, var(--color-primary), transparent 70%)" }}
          />
          <div
            className="absolute -bottom-24 -right-24 w-80 h-80 rounded-full blur-3xl opacity-20 pointer-events-none"
            style={{ background: "radial-gradient(circle, var(--color-accent), transparent 70%)" }}
          />

          <div className="relative z-10">
            <span className="inline-block text-xs uppercase tracking-widest font-bold text-[var(--color-accent)] mb-3">
              Creator Community
            </span>
            <h2 className="font-heading text-3xl md:text-5xl font-extrabold mb-5 text-white">
              Turn your digital art into <br className="hidden sm:inline" />
              <span className="gradient-text">daily wallpaper stories</span>
            </h2>
            <p className="text-[var(--color-text-muted)] text-base md:text-lg max-w-xl mx-auto mb-9">
              Join Wall My Paper as an approved creator. Showcase your high-res wallpapers to millions, build a fan following, and earn monthly payouts.
            </p>
            <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
              <Link
                href="/become-creator"
                className="btn-primary text-base px-8 py-3.5"
              >
                Apply to Become a Creator →
              </Link>
              <Link
                href="/studio"
                className="btn-secondary text-base px-8 py-3.5"
              >
                Open Creator Studio
              </Link>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="border-t border-[var(--color-border)] py-14 px-6 bg-[var(--color-bg)]">
        <div className="max-w-6xl mx-auto flex flex-col md:flex-row items-center justify-between gap-8">
          <div className="flex items-center gap-3">
            <div className="w-8 h-8 rounded-xl bg-gradient-to-tr from-[var(--color-primary)] to-[var(--color-accent)] flex items-center justify-center">
              <svg className="w-4 h-4 text-white" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                <path d="m8 3 4 8 5-5 5 15H2L8 3z" />
              </svg>
            </div>
            <span className="font-heading font-bold text-lg text-white">
              Wall My Paper
            </span>
          </div>

          <div className="flex flex-wrap items-center justify-center gap-6 text-sm text-[var(--color-text-muted)]">
            <Link href="/explore" className="hover:text-white transition-colors">Explore</Link>
            <Link href="/categories" className="hover:text-white transition-colors">Categories</Link>
            <Link href="/become-creator" className="hover:text-white transition-colors">Creators</Link>
            <Link href="/privacy" className="hover:text-white transition-colors">Privacy Policy</Link>
            <Link href="/terms" className="hover:text-white transition-colors">Terms of Service</Link>
            <Link href="/dmca" className="hover:text-white transition-colors">DMCA</Link>
            <a href="mailto:support@wallmypaper.app" className="hover:text-white transition-colors">
              Contact
            </a>
          </div>

          <p className="text-xs text-[var(--color-text-muted)]">
            © 2026 Wall My Paper. All rights reserved.
          </p>
        </div>
      </footer>
    </main>
  );
}
