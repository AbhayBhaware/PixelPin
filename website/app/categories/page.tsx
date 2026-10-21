"use client";

import Link from "next/link";

interface CategoryCard {
  name: string;
  tagline: string;
  count: string;
  coverImage: string;
  badge?: string;
}

const CATEGORIES_DATA: CategoryCard[] = [
  {
    name: "AMOLED",
    tagline: "Pure #000000 blacks designed to save battery on OLED screens",
    count: "12,400+ wallpapers",
    coverImage: "https://images.unsplash.com/photo-1550684848-fac1c5b4e853?auto=format&fit=crop&w=800&q=80",
    badge: "Battery Saver",
  },
  {
    name: "Nature & Landscapes",
    tagline: "Majestic alpine mountains, misty dawns, and serene glacial lakes",
    count: "18,200+ wallpapers",
    coverImage: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=800&q=80",
  },
  {
    name: "Cyberpunk & Neon",
    tagline: "Futuristic rainy streets, holographic cityscapes, and synthwave vibes",
    count: "9,600+ wallpapers",
    coverImage: "https://images.unsplash.com/photo-1514565131-fce0801e5785?auto=format&fit=crop&w=800&q=80",
    badge: "Trending",
  },
  {
    name: "Anime & Digital Art",
    tagline: "Aesthetic anime scenes, peaceful Kyoto evenings, and fantasy artwork",
    count: "14,800+ wallpapers",
    coverImage: "https://images.unsplash.com/photo-1528164344705-475426879c0d?auto=format&fit=crop&w=800&q=80",
  },
  {
    name: "Space & Galaxies",
    tagline: "Deep cosmos nebulae, glowing celestial auroras, and distant stars",
    count: "8,900+ wallpapers",
    coverImage: "https://images.unsplash.com/photo-1506703719100-a0f3a48c0f86?auto=format&fit=crop&w=800&q=80",
  },
  {
    name: "Minimalist",
    tagline: "Subtle geometric gradients, quiet dunes, and calm uncluttered aesthetics",
    count: "11,500+ wallpapers",
    coverImage: "https://images.unsplash.com/photo-1509316975850-ff9c5deb0cd9?auto=format&fit=crop&w=800&q=80",
  },
  {
    name: "Supercars & Automotive",
    tagline: "Precision engineered hypercars, track curves, and night velocity",
    count: "7,300+ wallpapers",
    coverImage: "https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=800&q=80",
  },
  {
    name: "Abstract & 3D Fluid",
    tagline: "Hypnotic iridescent liquid chrome, geometric ripples, and vibrant flows",
    count: "10,200+ wallpapers",
    coverImage: "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&w=800&q=80",
  },
];

const GOOGLE_PLAY_URL = "https://play.google.com/store/apps/details?id=com.pixelpin.pixelpin";

export default function CategoriesPage() {
  return (
    <main className="min-h-screen bg-slate-50 text-slate-900 selection:bg-indigo-500 selection:text-white">
      {/* Header */}
      <header className="glass sticky top-0 z-40 px-4 sm:px-8 py-3.5 flex items-center justify-between border-b border-slate-200">
        <Link href="/" className="flex items-center gap-3">
          <div className="w-9 h-9 rounded-xl bg-gradient-to-tr from-indigo-500 to-pink-500 flex items-center justify-center shadow-sm">
            <svg className="w-4 h-4 text-white" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4">
              <path d="m8 3 4 8 5-5 5 15H2L8 3z" />
            </svg>
          </div>
          <span className="font-heading font-extrabold text-lg text-slate-900">
            PixelPin
          </span>
        </Link>

        <nav className="hidden md:flex items-center gap-6 text-sm font-semibold text-slate-600">
          <Link href="/" className="hover:text-indigo-600 transition-colors">
            Home
          </Link>
          <Link href="/explore" className="hover:text-indigo-600 transition-colors">
            Explore
          </Link>
          <Link href="/become-creator" className="hover:text-indigo-600 transition-colors">
            Creators
          </Link>
          <Link href="/upload" className="hover:text-indigo-600 transition-colors">
            Upload
          </Link>
        </nav>

        <a
          href={GOOGLE_PLAY_URL}
          target="_blank"
          rel="noopener noreferrer"
          className="btn-primary text-xs sm:text-sm py-2 px-4"
        >
          Get on Google Play
        </a>
      </header>

      {/* Main Container */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 py-12">
        <div className="text-center max-w-3xl mx-auto mb-12">
          <div className="inline-flex items-center gap-2 text-xs font-bold uppercase tracking-wider text-indigo-600 mb-2">
            <span>●</span> Wallpaper Collections
          </div>
          <h1 className="font-heading text-4xl sm:text-5xl font-extrabold text-slate-900 mb-4 tracking-tight">
            Browse by <span className="gradient-text">Category</span>
          </h1>
          <p className="text-slate-600 text-base max-w-xl mx-auto">
            From pure-black battery saving AMOLED walls to vibrant Cyberpunk aesthetics, explore the exact mood for your Android device.
          </p>
        </div>

        {/* Category Cards Grid */}
        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
          {CATEGORIES_DATA.map((cat) => (
            <div
              key={cat.name}
              className="card-clean rounded-3xl overflow-hidden bg-white border border-slate-200 group flex flex-col justify-between hover:border-indigo-300 transition-all shadow-sm"
            >
              <div className="relative aspect-[16/10] overflow-hidden bg-slate-900">
                <img
                  src={cat.coverImage}
                  alt={cat.name}
                  className="w-full h-full object-cover transition-transform duration-500 ease-out group-hover:scale-105"
                />
                {cat.badge && (
                  <div className="absolute top-3 left-3 px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-indigo-600 text-white shadow-sm">
                    {cat.badge}
                  </div>
                )}
                <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent" />
                <span className="absolute bottom-3 left-3 text-white text-xs font-semibold">
                  {cat.count}
                </span>
              </div>

              <div className="p-5 flex-1 flex flex-col justify-between">
                <div>
                  <h3 className="font-heading font-bold text-lg text-slate-900 mb-1">
                    {cat.name}
                  </h3>
                  <p className="text-xs text-slate-500 leading-relaxed mb-4">
                    {cat.tagline}
                  </p>
                </div>

                <a
                  href={GOOGLE_PLAY_URL}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="btn-secondary text-xs py-2 w-full text-indigo-600 hover:text-indigo-700 font-semibold flex items-center justify-center gap-1.5"
                >
                  <span>Explore on Google Play</span>
                  <span>→</span>
                </a>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Footer */}
      <footer className="border-t border-slate-200 py-10 px-4 text-center text-xs text-slate-500 bg-white">
        <p>© 2026 PixelPin. All rights reserved.</p>
      </footer>
    </main>
  );
}
