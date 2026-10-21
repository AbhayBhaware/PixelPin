"use client";

import { useState, useMemo } from "react";
import Link from "next/link";

interface WallpaperItem {
  id: string;
  title: string;
  category: string;
  badge: "4K" | "AMOLED" | "NEW" | "TRENDING";
  creator: string;
  downloads: string;
  likes: string;
  imageUrl: string;
  aspect: string;
}

const CURATED_WALLPAPERS: WallpaperItem[] = [
  {
    id: "w1",
    title: "Cyberpunk Neon Horizon",
    category: "Cyberpunk",
    badge: "4K",
    creator: "NeoPixel",
    downloads: "24.8K",
    likes: "3.4K",
    imageUrl: "https://images.unsplash.com/photo-1514565131-fce0801e5785?auto=format&fit=crop&w=800&q=80",
    aspect: "aspect-[9/16]",
  },
  {
    id: "w2",
    title: "Misty Alpine Dawn",
    category: "Nature",
    badge: "4K",
    creator: "Elena Vance",
    downloads: "19.2K",
    likes: "2.8K",
    imageUrl: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=800&q=80",
    aspect: "aspect-[9/15]",
  },
  {
    id: "w3",
    title: "Midnight Void Curves",
    category: "AMOLED",
    badge: "AMOLED",
    creator: "OnyxStudio",
    downloads: "32.1K",
    likes: "5.1K",
    imageUrl: "https://images.unsplash.com/photo-1550684848-fac1c5b4e853?auto=format&fit=crop&w=800&q=80",
    aspect: "aspect-[9/16]",
  },
  {
    id: "w4",
    title: "Kyoto Sakura Evening",
    category: "Anime",
    badge: "TRENDING",
    creator: "Kenji Sato",
    downloads: "16.4K",
    likes: "2.1K",
    imageUrl: "https://images.unsplash.com/photo-1528164344705-475426879c0d?auto=format&fit=crop&w=800&q=80",
    aspect: "aspect-[9/15]",
  },
  {
    id: "w5",
    title: "Deep Galactic Nebula",
    category: "Space",
    badge: "4K",
    creator: "CosmoLens",
    downloads: "28.9K",
    likes: "4.3K",
    imageUrl: "https://images.unsplash.com/photo-1506703719100-a0f3a48c0f86?auto=format&fit=crop&w=800&q=80",
    aspect: "aspect-[9/16]",
  },
  {
    id: "w6",
    title: "Minimal Sahara Dunes",
    category: "Minimal",
    badge: "4K",
    creator: "SoraDesign",
    downloads: "14.7K",
    likes: "1.9K",
    imageUrl: "https://images.unsplash.com/photo-1509316975850-ff9c5deb0cd9?auto=format&fit=crop&w=800&q=80",
    aspect: "aspect-[9/15]",
  },
  {
    id: "w7",
    title: "Emerald Forest Cascades",
    category: "Nature",
    badge: "NEW",
    creator: "WildEarth",
    downloads: "11.2K",
    likes: "1.6K",
    imageUrl: "https://images.unsplash.com/photo-1432405972618-c60b0225b8f9?auto=format&fit=crop&w=800&q=80",
    aspect: "aspect-[9/16]",
  },
  {
    id: "w8",
    title: "Synthwave Sunset Drive",
    category: "Cyberpunk",
    badge: "4K",
    creator: "AetherVibe",
    downloads: "22.5K",
    likes: "3.7K",
    imageUrl: "https://images.unsplash.com/photo-1508739773434-c26b3d09e071?auto=format&fit=crop&w=800&q=80",
    aspect: "aspect-[9/15]",
  },
  {
    id: "w9",
    title: "Nordic Fjord Serenity",
    category: "Nature",
    badge: "4K",
    creator: "NordicViews",
    downloads: "17.8K",
    likes: "2.4K",
    imageUrl: "https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?auto=format&fit=crop&w=800&q=80",
    aspect: "aspect-[9/16]",
  },
  {
    id: "w10",
    title: "Liquid Iridescent 3D",
    category: "Abstract",
    badge: "TRENDING",
    creator: "PrismFlow",
    downloads: "29.4K",
    likes: "4.9K",
    imageUrl: "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&w=800&q=80",
    aspect: "aspect-[9/15]",
  },
  {
    id: "w11",
    title: "Midnight Supercar Stance",
    category: "Cars",
    badge: "4K",
    creator: "ApexDrive",
    downloads: "35.2K",
    likes: "6.2K",
    imageUrl: "https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=800&q=80",
    aspect: "aspect-[9/16]",
  },
  {
    id: "w12",
    title: "Celestial Green Aurora",
    category: "Space",
    badge: "AMOLED",
    creator: "PolarisArt",
    downloads: "26.3K",
    likes: "4.0K",
    imageUrl: "https://images.unsplash.com/photo-1531366936337-7c912a4589a7?auto=format&fit=crop&w=800&q=80",
    aspect: "aspect-[9/15]",
  },
  {
    id: "w13",
    title: "Golden Autumn Foliage",
    category: "Nature",
    badge: "4K",
    creator: "SylvanLens",
    downloads: "13.6K",
    likes: "1.8K",
    imageUrl: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=800&q=80",
    aspect: "aspect-[9/16]",
  },
  {
    id: "w14",
    title: "Minimalist Modern Arches",
    category: "Minimal",
    badge: "NEW",
    creator: "KansoStudio",
    downloads: "9.7K",
    likes: "1.4K",
    imageUrl: "https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=800&q=80",
    aspect: "aspect-[9/15]",
  },
];

const CATEGORIES = [
  "All",
  "AMOLED",
  "Nature",
  "Cyberpunk",
  "Anime",
  "Space",
  "Minimal",
  "Cars",
  "Abstract",
];

const GOOGLE_PLAY_URL = "https://play.google.com/store/apps/details?id=com.pixelpin.pixelpin";

export default function HomePage() {
  const [selectedCategory, setSelectedCategory] = useState("All");
  const [searchQuery, setSearchQuery] = useState("");
  const [previewWallpaper, setPreviewWallpaper] = useState<WallpaperItem | null>(null);

  const filteredWallpapers = useMemo(() => {
    return CURATED_WALLPAPERS.filter((item) => {
      const matchCat =
        selectedCategory === "All" || item.category.toLowerCase() === selectedCategory.toLowerCase();
      const matchSearch =
        searchQuery.trim() === "" ||
        item.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
        item.category.toLowerCase().includes(searchQuery.toLowerCase()) ||
        item.creator.toLowerCase().includes(searchQuery.toLowerCase());
      return matchCat && matchSearch;
    });
  }, [selectedCategory, searchQuery]);

  return (
    <main className="min-h-screen bg-white text-slate-900 selection:bg-indigo-500 selection:text-white">
      {/* Navigation Header */}
      <header className="glass fixed top-0 left-0 right-0 z-50 px-4 sm:px-8 py-3.5 flex items-center justify-between border-b border-slate-200/80">
        <Link href="/" className="flex items-center gap-3 group">
          <div className="w-10 h-10 rounded-2xl bg-gradient-to-tr from-indigo-500 via-purple-500 to-pink-500 p-[2px] shadow-md shadow-indigo-500/20 transition-transform group-hover:scale-105">
            <div className="w-full h-full bg-white rounded-[14px] flex items-center justify-center">
              <svg
                className="w-5 h-5 text-indigo-600"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="2.4"
                strokeLinecap="round"
                strokeLinejoin="round"
              >
                <path d="m8 3 4 8 5-5 5 15H2L8 3z" />
              </svg>
            </div>
          </div>
          <div className="flex flex-col">
            <span className="font-heading font-extrabold text-xl tracking-tight text-slate-900 flex items-center gap-2">
              PixelPin
              <span className="text-[10px] font-bold tracking-wider px-2 py-0.5 rounded-full bg-indigo-50 text-indigo-600 border border-indigo-200">
                4K UHD
              </span>
            </span>
          </div>
        </Link>

        {/* Center links */}
        <nav className="hidden md:flex items-center gap-8 text-sm font-semibold text-slate-600">
          <Link href="/explore" className="hover:text-indigo-600 transition-colors">
            Explore
          </Link>
          <Link href="/categories" className="hover:text-indigo-600 transition-colors">
            Categories
          </Link>
          <Link href="/become-creator" className="hover:text-indigo-600 transition-colors flex items-center gap-1.5">
            <span className="text-pink-500">★</span> Creators
          </Link>
          <Link href="/upload" className="hover:text-indigo-600 transition-colors">
            Upload
          </Link>
        </nav>

        {/* Right CTA */}
        <div className="flex items-center gap-3">
          <Link
            href="/upload"
            className="btn-secondary hidden sm:inline-flex text-xs py-2 px-3.5 text-slate-700"
          >
            Creator Studio
          </Link>
          <a
            href={GOOGLE_PLAY_URL}
            target="_blank"
            rel="noopener noreferrer"
            className="btn-primary text-xs sm:text-sm py-2 px-4 sm:px-5 flex items-center gap-2"
          >
            <svg className="w-4 h-4 fill-current" viewBox="0 0 24 24">
              <path d="M3 20.5v-17c0-.83 1.01-1.3 1.6-.73L21.3 11.5a1 1 0 010 1l-16.7 8.73C3.01 21.8 3 21.33 3 20.5z" />
            </svg>
            <span>Get on Google Play</span>
          </a>
        </div>
      </header>

      {/* Hero Section */}
      <section className="relative pt-32 pb-16 px-4 sm:px-6 overflow-hidden bg-gradient-to-b from-indigo-50/40 via-white to-white">
        {/* Soft background ambient blurs */}
        <div
          className="absolute -top-10 left-1/4 w-[480px] h-[480px] rounded-full blur-[140px] opacity-40 pointer-events-none"
          style={{ background: "radial-gradient(circle, #818CF8, transparent 70%)" }}
        />
        <div
          className="absolute top-36 right-1/4 w-[400px] h-[400px] rounded-full blur-[130px] opacity-35 pointer-events-none"
          style={{ background: "radial-gradient(circle, #F472B6, transparent 70%)" }}
        />

        <div className="relative z-10 max-w-4xl mx-auto text-center">
          {/* Tagline Pill */}
          <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full text-xs font-semibold tracking-wide mb-6 bg-white border border-slate-200 text-slate-700 shadow-sm">
            <span className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse" />
            Next-Gen 4K Wallpapers for Android
          </div>

          <h1 className="font-heading text-4xl sm:text-6xl md:text-7xl font-extrabold tracking-tight leading-[1.1] mb-5 text-slate-900">
            Walls worth{" "}
            <span className="gradient-text">looking at.</span>
          </h1>

          <p className="text-slate-600 text-base sm:text-lg md:text-xl max-w-2xl mx-auto mb-8 leading-relaxed font-normal">
            A handpicked preview of ultra-crisp 4K, AMOLED, and digital art wallpapers.
            Clean, ad-free aesthetic designed specifically for modern high-resolution screens.
          </p>

          {/* Search bar inside Hero */}
          <div className="max-w-2xl mx-auto mb-8">
            <div className="relative flex items-center rounded-2xl bg-white border border-slate-200/90 p-2 shadow-lg shadow-slate-200/50 focus-within:border-indigo-500 focus-within:ring-4 focus-within:ring-indigo-100 transition-all">
              <svg
                className="w-5 h-5 ml-3 text-slate-400"
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
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Search by mood, category (e.g. AMOLED, Cyberpunk, Nature, Minimal)..."
                className="w-full bg-transparent px-3 py-2 text-sm text-slate-900 placeholder-slate-400 focus:outline-none"
              />
              {searchQuery && (
                <button
                  onClick={() => setSearchQuery("")}
                  className="p-1.5 text-slate-400 hover:text-slate-600 mr-1"
                >
                  ✕
                </button>
              )}
              <a
                href={GOOGLE_PLAY_URL}
                target="_blank"
                rel="noopener noreferrer"
                className="btn-primary text-xs sm:text-sm py-2 px-5 rounded-xl shrink-0"
              >
                Explore App
              </a>
            </div>
          </div>

          {/* Category Chips Scroll */}
          <div className="flex items-center justify-start sm:justify-center gap-2 overflow-x-auto py-2 px-2 no-scrollbar">
            {CATEGORIES.map((cat) => (
              <button
                key={cat}
                onClick={() => setSelectedCategory(cat)}
                className={
                  selectedCategory === cat ? "chip-pill-active" : "chip-pill cursor-pointer"
                }
              >
                {cat}
              </button>
            ))}
          </div>
        </div>
      </section>

      {/* Curated Wallpaper Showcase (10–20 Items Limit) */}
      <section className="py-10 px-4 sm:px-6 max-w-7xl mx-auto">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 mb-8">
          <div>
            <div className="inline-flex items-center gap-2 text-xs font-bold uppercase tracking-wider text-indigo-600 mb-1">
              <span>●</span> Featured Web Preview
            </div>
            <h2 className="font-heading text-2xl sm:text-3xl font-extrabold text-slate-900">
              Curated <span className="gradient-text">Showcase</span>
            </h2>
            <p className="text-sm text-slate-500 mt-1">
              Showing {filteredWallpapers.length} handpicked originals. Unlock 50,000+ more inside the app.
            </p>
          </div>

          <a
            href={GOOGLE_PLAY_URL}
            target="_blank"
            rel="noopener noreferrer"
            className="btn-secondary text-xs sm:text-sm py-2 px-4 text-indigo-600 hover:text-indigo-700 flex items-center gap-1.5"
          >
            <span>Explore 50,000+ on Google Play</span>
            <span>→</span>
          </a>
        </div>

        {/* Wallpaper Masonry Grid */}
        <div className="masonry-grid">
          {filteredWallpapers.map((wall) => (
            <div
              key={wall.id}
              className="masonry-item group cursor-pointer"
              onClick={() => setPreviewWallpaper(wall)}
            >
              <div
                className={`wallpaper-card relative ${wall.aspect} overflow-hidden shadow-sm`}
              >
                {/* Image */}
                <img
                  src={wall.imageUrl}
                  alt={wall.title}
                  loading="lazy"
                  className="w-full h-full object-cover transition-transform duration-500 ease-out group-hover:scale-105"
                />

                {/* Badge top-left */}
                <div className="absolute top-3 left-3 z-10">
                  <span
                    className={`text-[10px] font-heading font-bold px-2.5 py-1 rounded-full shadow-md backdrop-blur-md ${
                      wall.badge === "4K"
                        ? "bg-indigo-600 text-white"
                        : wall.badge === "AMOLED"
                        ? "bg-slate-950 text-indigo-300 border border-indigo-400/30"
                        : wall.badge === "TRENDING"
                        ? "bg-pink-600 text-white"
                        : "bg-amber-500 text-white"
                    }`}
                  >
                    {wall.badge}
                  </span>
                </div>

                {/* Quick Category pill top-right */}
                <div className="absolute top-3 right-3 z-10">
                  <span className="text-[10px] font-medium px-2 py-0.5 rounded-full bg-black/40 text-white backdrop-blur-md border border-white/20">
                    {wall.category}
                  </span>
                </div>

                {/* Hover overlay with download & details */}
                <div className="absolute inset-0 bg-gradient-to-t from-slate-950/90 via-slate-950/30 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-200 p-4 flex flex-col justify-end">
                  <span className="font-heading font-bold text-white text-base drop-shadow-sm">
                    {wall.title}
                  </span>
                  <div className="flex items-center justify-between mt-2 pt-2 border-t border-white/10">
                    <span className="text-xs text-slate-300 font-medium">
                      by {wall.creator}
                    </span>
                    <div className="flex items-center gap-2">
                      <span className="text-xs text-white/80 flex items-center gap-1">
                        ♥ {wall.likes}
                      </span>
                      <button
                        onClick={(e) => {
                          e.stopPropagation();
                          setPreviewWallpaper(wall);
                        }}
                        className="p-1.5 rounded-lg bg-white/20 hover:bg-white text-white hover:text-slate-900 backdrop-blur-md transition-colors"
                        title="Preview"
                      >
                        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                        </svg>
                      </button>
                    </div>
                  </div>
                </div>

                {/* Subtle bottom label on normal state */}
                <div className="absolute bottom-3 left-3 right-3 flex items-center justify-between text-xs text-white group-hover:opacity-0 transition-opacity bg-black/40 backdrop-blur-sm px-3 py-1.5 rounded-xl border border-white/10">
                  <span className="font-medium truncate mr-2">{wall.title}</span>
                  <span className="text-[10px] text-slate-300 shrink-0 font-medium">
                    {wall.downloads} dl
                  </span>
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* ── MANDATORY "EXPLORE MORE ON GOOGLE PLAY" CTA BANNER ── */}
        <div className="mt-14 rounded-3xl p-8 sm:p-12 bg-gradient-to-br from-indigo-900 via-indigo-950 to-slate-950 text-white relative overflow-hidden shadow-2xl border border-indigo-500/20">
          {/* Atmospheric background glows */}
          <div
            className="absolute -top-24 -right-24 w-96 h-96 rounded-full blur-3xl opacity-30 pointer-events-none"
            style={{ background: "radial-gradient(circle, #818CF8, transparent 70%)" }}
          />
          <div
            className="absolute -bottom-24 -left-24 w-96 h-96 rounded-full blur-3xl opacity-20 pointer-events-none"
            style={{ background: "radial-gradient(circle, #EC4899, transparent 70%)" }}
          />

          <div className="relative z-10 max-w-3xl mx-auto text-center flex flex-col items-center">
            {/* Pill */}
            <div className="inline-flex items-center gap-2 px-3.5 py-1 rounded-full text-xs font-bold uppercase tracking-wider bg-indigo-500/20 text-indigo-300 border border-indigo-400/30 mb-5">
              <span>🚀</span> Google Play Exclusive
            </div>

            <h3 className="font-heading text-3xl sm:text-4xl md:text-5xl font-extrabold mb-4 tracking-tight leading-tight">
              Want to explore <span className="gradient-text">50,000+ more</span> wallpapers?
            </h3>

            <p className="text-slate-300 text-base sm:text-lg mb-8 max-w-xl leading-relaxed">
              We keep the website light with just 14 showcase items. Download the official PixelPin app on Google Play to browse thousands of fresh 4K wallpapers, automated wallpaper changer, and AMOLED dark mode.
            </p>

            {/* Google Play Big Button */}
            <a
              href={GOOGLE_PLAY_URL}
              target="_blank"
              rel="noopener noreferrer"
              className="btn-googleplay group transform hover:scale-105 transition-all mb-6"
            >
              <svg className="w-8 h-8 fill-white shrink-0" viewBox="0 0 24 24">
                <path d="M3 20.5v-17c0-.83 1.01-1.3 1.6-.73L21.3 11.5a1 1 0 010 1l-16.7 8.73C3.01 21.8 3 21.33 3 20.5z" />
              </svg>
              <div className="flex flex-col text-left">
                <span className="text-[10px] tracking-widest uppercase font-semibold text-slate-300">
                  GET IT ON
                </span>
                <span className="text-xl sm:text-2xl font-bold font-heading tracking-tight leading-none text-white">
                  Google Play
                </span>
              </div>
            </a>

            {/* Stats row */}
            <div className="flex flex-wrap items-center justify-center gap-6 sm:gap-10 text-xs sm:text-sm text-slate-300 font-medium">
              <div className="flex items-center gap-1.5">
                <span className="text-amber-400">★★★★★</span>
                <span>4.8 Rating</span>
              </div>
              <div className="flex items-center gap-1.5">
                <span className="text-emerald-400">✓</span>
                <span>100% Free Downloads</span>
              </div>
              <div className="flex items-center gap-1.5">
                <span className="text-indigo-400">⚡</span>
                <span>No Login Required</span>
              </div>
              <div className="flex items-center gap-1.5">
                <span className="text-pink-400">📱</span>
                <span>Auto Wallpaper Changer</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* App Features Section */}
      <section className="py-20 px-4 sm:px-6 bg-slate-50 border-t border-slate-200">
        <div className="max-w-6xl mx-auto">
          <div className="text-center max-w-2xl mx-auto mb-16">
            <span className="text-xs font-bold uppercase tracking-wider text-indigo-600 mb-2 block">
              Why Choose PixelPin
            </span>
            <h2 className="font-heading text-3xl sm:text-4xl font-extrabold text-slate-900 mb-4">
              Designed for <span className="gradient-text">Wallpaper Lovers</span>
            </h2>
            <p className="text-slate-600 text-base">
              Built with uncompromising attention to visual fidelity, speed, and creator empowerment.
            </p>
          </div>

          <div className="grid md:grid-cols-3 gap-6">
            {[
              {
                icon: "📱",
                title: "Live Phone Preview",
                desc: "Preview wallpapers in realistic lock and home screen mockups before applying them to your phone.",
              },
              {
                icon: "✨",
                title: "Strict 4K Ultra HD",
                desc: "Every wallpaper passes our strict resolution standard. Pin-sharp details on AMOLED, Retina, and folding screens.",
              },
              {
                icon: "⚡",
                title: "Zero-Friction Browsing",
                desc: "No forced accounts, no paywalls. Open the app, find your favorite aesthetic, and apply it in one tap.",
              },
              {
                icon: "🔄",
                title: "Auto Wallpaper Changer",
                desc: "Automatically rotate wallpapers on your home or lock screen every hour, day, or whenever you unlock.",
              },
              {
                icon: "🌙",
                title: "True AMOLED Black",
                desc: "Pure #000000 backgrounds optimized for OLED and AMOLED screens to conserve your phone's battery life.",
              },
              {
                icon: "🎨",
                title: "Creator Community",
                desc: "Digital artists and photographers can upload directly through our web studio and share wallpapers worldwide.",
              },
            ].map((f) => (
              <div
                key={f.title}
                className="card-clean p-7 bg-white hover:border-indigo-200 transition-all"
              >
                <div className="text-3xl mb-4 p-3 w-fit rounded-2xl bg-indigo-50 border border-indigo-100">
                  {f.icon}
                </div>
                <h3 className="font-heading font-bold text-lg mb-2 text-slate-900">
                  {f.title}
                </h3>
                <p className="text-slate-600 text-sm leading-relaxed">
                  {f.desc}
                </p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Become a Creator Section */}
      <section className="py-20 px-4 sm:px-6 bg-white border-t border-slate-200">
        <div className="max-w-5xl mx-auto rounded-3xl p-8 sm:p-14 text-center bg-gradient-to-br from-indigo-50 via-purple-50/50 to-pink-50 border border-indigo-100 shadow-xl relative overflow-hidden">
          <div className="relative z-10">
            <span className="inline-block text-xs uppercase tracking-widest font-bold text-indigo-600 mb-3 bg-white px-3 py-1 rounded-full border border-indigo-100">
              For Artists & Photographers
            </span>
            <h2 className="font-heading text-3xl sm:text-5xl font-extrabold mb-5 text-slate-900">
              Share your digital art with <br className="hidden sm:inline" />
              <span className="gradient-text">thousands of mobile users</span>
            </h2>
            <p className="text-slate-600 text-base sm:text-lg max-w-xl mx-auto mb-8">
              Join the PixelPin creator network. Upload your original 4K wallpapers, build your portfolio, and reach wallpaper enthusiasts across the globe.
            </p>
            <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
              <Link
                href="/upload"
                className="btn-primary text-base px-8 py-3.5"
              >
                Submit Wallpaper to Queue →
              </Link>
              <Link
                href="/become-creator"
                className="btn-secondary text-base px-8 py-3.5 text-slate-700"
              >
                Creator Guidelines & FAQ
              </Link>
            </div>
          </div>
        </div>
      </section>

      {/* Quick Wallpaper Preview Modal */}
      {previewWallpaper && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/70 backdrop-blur-md animate-in fade-in"
          onClick={() => setPreviewWallpaper(null)}
        >
          <div
            className="bg-white rounded-3xl max-w-lg w-full overflow-hidden shadow-2xl border border-slate-200"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="relative aspect-[9/16] max-h-[65vh] w-full bg-slate-900">
              <img
                src={previewWallpaper.imageUrl}
                alt={previewWallpaper.title}
                className="w-full h-full object-cover"
              />
              <button
                onClick={() => setPreviewWallpaper(null)}
                className="absolute top-4 right-4 w-9 h-9 rounded-full bg-black/60 text-white flex items-center justify-center hover:bg-black/80 transition-colors"
              >
                ✕
              </button>
            </div>
            <div className="p-6">
              <div className="flex items-center justify-between mb-2">
                <span className="text-xs font-semibold px-2.5 py-1 rounded-full bg-indigo-50 text-indigo-600 border border-indigo-200">
                  {previewWallpaper.category}
                </span>
                <span className="text-xs font-medium text-slate-500">
                  {previewWallpaper.downloads} downloads
                </span>
              </div>
              <h3 className="font-heading text-xl font-bold text-slate-900 mb-1">
                {previewWallpaper.title}
              </h3>
              <p className="text-sm text-slate-500 mb-6">
                Created by {previewWallpaper.creator}
              </p>

              <div className="flex gap-3">
                <a
                  href={GOOGLE_PLAY_URL}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="btn-primary flex-1 py-3 text-sm"
                >
                  Download in App (4K)
                </a>
                <a
                  href={previewWallpaper.imageUrl}
                  target="_blank"
                  download
                  rel="noopener noreferrer"
                  className="btn-secondary py-3 px-4 text-sm text-slate-700"
                >
                  Direct Link
                </a>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Footer */}
      <footer className="border-t border-slate-200 py-14 px-4 sm:px-6 bg-slate-50 text-slate-600">
        <div className="max-w-6xl mx-auto flex flex-col md:flex-row items-center justify-between gap-8">
          <div className="flex items-center gap-3">
            <div className="w-8 h-8 rounded-xl bg-gradient-to-tr from-indigo-500 to-pink-500 flex items-center justify-center">
              <svg className="w-4 h-4 text-white" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                <path d="m8 3 4 8 5-5 5 15H2L8 3z" />
              </svg>
            </div>
            <span className="font-heading font-bold text-lg text-slate-900">
              PixelPin
            </span>
          </div>

          <div className="flex flex-wrap items-center justify-center gap-6 text-sm font-medium">
            <Link href="/explore" className="hover:text-indigo-600 transition-colors">
              Explore
            </Link>
            <Link href="/categories" className="hover:text-indigo-600 transition-colors">
              Categories
            </Link>
            <Link href="/become-creator" className="hover:text-indigo-600 transition-colors">
              Creators
            </Link>
            <Link href="/upload" className="hover:text-indigo-600 transition-colors">
              Upload
            </Link>
            <Link href="/admin/queue" className="hover:text-indigo-600 transition-colors">
              Review Queue
            </Link>
            <Link href="/privacy" className="hover:text-indigo-600 transition-colors">
              Privacy Policy
            </Link>
            <Link href="/terms" className="hover:text-indigo-600 transition-colors">
              Terms of Service
            </Link>
            <Link href="/dmca" className="hover:text-indigo-600 transition-colors">
              DMCA
            </Link>
          </div>

          <p className="text-xs text-slate-400">
            © 2026 PixelPin. All rights reserved.
          </p>
        </div>
      </footer>
    </main>
  );
}
