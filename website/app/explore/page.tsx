"use client";

import { useState, useMemo } from "react";
import Link from "next/link";

interface WallpaperItem {
  id: string;
  title: string;
  category: string;
  badge: string;
  creator: string;
  downloads: string;
  imageUrl: string;
}

const EXPLORE_WALLPAPERS: WallpaperItem[] = [
  {
    id: "e1",
    title: "Cyberpunk Rain in Shinjuku",
    category: "Cyberpunk",
    badge: "4K",
    creator: "NeoPixel",
    downloads: "24.8K",
    imageUrl: "https://images.unsplash.com/photo-1514565131-fce0801e5785?auto=format&fit=crop&w=800&q=80",
  },
  {
    id: "e2",
    title: "Misty Alpine Dawn Peaks",
    category: "Nature",
    badge: "4K",
    creator: "Elena Vance",
    downloads: "19.2K",
    imageUrl: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=800&q=80",
  },
  {
    id: "e3",
    title: "Midnight Void Curves",
    category: "AMOLED",
    badge: "AMOLED",
    creator: "OnyxStudio",
    downloads: "32.1K",
    imageUrl: "https://images.unsplash.com/photo-1550684848-fac1c5b4e853?auto=format&fit=crop&w=800&q=80",
  },
  {
    id: "e4",
    title: "Kyoto Sakura Evening",
    category: "Anime",
    badge: "TRENDING",
    creator: "Kenji Sato",
    downloads: "16.4K",
    imageUrl: "https://images.unsplash.com/photo-1528164344705-475426879c0d?auto=format&fit=crop&w=800&q=80",
  },
  {
    id: "e5",
    title: "Deep Space Cosmic Nebula",
    category: "Space",
    badge: "4K",
    creator: "CosmoLens",
    downloads: "28.9K",
    imageUrl: "https://images.unsplash.com/photo-1506703719100-a0f3a48c0f86?auto=format&fit=crop&w=800&q=80",
  },
  {
    id: "e6",
    title: "Minimal Golden Dunes",
    category: "Minimal",
    badge: "4K",
    creator: "SoraDesign",
    downloads: "14.7K",
    imageUrl: "https://images.unsplash.com/photo-1509316975850-ff9c5deb0cd9?auto=format&fit=crop&w=800&q=80",
  },
  {
    id: "e7",
    title: "Tropical Cascade Stream",
    category: "Nature",
    badge: "NEW",
    creator: "WildEarth",
    downloads: "11.2K",
    imageUrl: "https://images.unsplash.com/photo-1432405972618-c60b0225b8f9?auto=format&fit=crop&w=800&q=80",
  },
  {
    id: "e8",
    title: "Retro Synthwave Sunset",
    category: "Cyberpunk",
    badge: "4K",
    creator: "AetherVibe",
    downloads: "22.5K",
    imageUrl: "https://images.unsplash.com/photo-1508739773434-c26b3d09e071?auto=format&fit=crop&w=800&q=80",
  },
  {
    id: "e9",
    title: "Nordic Glacial Waters",
    category: "Nature",
    badge: "4K",
    creator: "NordicViews",
    downloads: "17.8K",
    imageUrl: "https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?auto=format&fit=crop&w=800&q=80",
  },
  {
    id: "e10",
    title: "Liquid Iridescent Form",
    category: "Abstract",
    badge: "TRENDING",
    creator: "PrismFlow",
    downloads: "29.4K",
    imageUrl: "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&w=800&q=80",
  },
  {
    id: "e11",
    title: "Midnight Supercar Blur",
    category: "Cars",
    badge: "4K",
    creator: "ApexDrive",
    downloads: "35.2K",
    imageUrl: "https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=800&q=80",
  },
  {
    id: "e12",
    title: "Celestial Green Aurora",
    category: "Space",
    badge: "AMOLED",
    creator: "PolarisArt",
    downloads: "26.3K",
    imageUrl: "https://images.unsplash.com/photo-1531366936337-7c912a4589a7?auto=format&fit=crop&w=800&q=80",
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

export default function ExplorePage() {
  const [selectedCategory, setSelectedCategory] = useState("All");
  const [search, setSearch] = useState("");

  const filtered = useMemo(() => {
    return EXPLORE_WALLPAPERS.filter((item) => {
      const matchCat =
        selectedCategory === "All" || item.category.toLowerCase() === selectedCategory.toLowerCase();
      const matchSearch =
        search.trim() === "" ||
        item.title.toLowerCase().includes(search.toLowerCase()) ||
        item.category.toLowerCase().includes(search.toLowerCase());
      return matchCat && matchSearch;
    });
  }, [selectedCategory, search]);

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
          <Link href="/categories" className="hover:text-indigo-600 transition-colors">
            Categories
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

      {/* Main Section */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 py-12">
        <div className="text-center max-w-3xl mx-auto mb-10">
          <div className="inline-flex items-center gap-2 text-xs font-bold uppercase tracking-wider text-indigo-600 mb-2">
            <span>●</span> Discover Wallpapers
          </div>
          <h1 className="font-heading text-4xl sm:text-5xl font-extrabold text-slate-900 mb-4 tracking-tight">
            Explore 4K & AMOLED <span className="gradient-text">Wallpapers</span>
          </h1>
          <p className="text-slate-600 text-base max-w-xl mx-auto">
            Browse our handpicked sample gallery below, or download the PixelPin app on Google Play for unlimited access to over 50,000+ wallpapers.
          </p>

          {/* Search bar */}
          <div className="mt-8 max-w-xl mx-auto">
            <input
              type="text"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Filter by keyword or category (e.g. AMOLED, Anime, Nature)..."
              className="input-field py-3 px-4 shadow-sm"
            />
          </div>

          {/* Category Chips */}
          <div className="flex items-center justify-start sm:justify-center gap-2 overflow-x-auto py-4 px-2 no-scrollbar mt-3">
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

        {/* Gallery Grid */}
        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-5">
          {filtered.map((item) => (
            <div
              key={item.id}
              className="wallpaper-card relative aspect-[9/16] overflow-hidden group shadow-sm bg-white"
            >
              <img
                src={item.imageUrl}
                alt={item.title}
                loading="lazy"
                className="w-full h-full object-cover transition-transform duration-500 ease-out group-hover:scale-105"
              />
              <div className="absolute top-3 left-3">
                <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-indigo-600 text-white shadow-sm">
                  {item.badge}
                </span>
              </div>
              <div className="absolute inset-0 bg-gradient-to-t from-slate-950/85 via-slate-950/20 to-transparent opacity-0 group-hover:opacity-100 transition-opacity p-4 flex flex-col justify-end text-white">
                <h4 className="font-heading font-bold text-sm">{item.title}</h4>
                <p className="text-xs text-slate-300">by {item.creator}</p>
                <a
                  href={GOOGLE_PLAY_URL}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="mt-3 btn-primary text-xs py-1.5 px-3 w-full text-center"
                >
                  Download on Google Play
                </a>
              </div>
              <div className="absolute bottom-2.5 left-2.5 right-2.5 bg-black/40 backdrop-blur-sm px-2.5 py-1 rounded-xl text-white text-[11px] font-medium flex justify-between items-center group-hover:opacity-0 transition-opacity">
                <span className="truncate">{item.title}</span>
                <span className="text-[10px] text-slate-300">{item.downloads}</span>
              </div>
            </div>
          ))}
        </div>

        {/* ── GOOGLE PLAY CALL TO ACTION ── */}
        <div className="mt-16 rounded-3xl p-8 sm:p-12 bg-white border border-slate-200 text-center shadow-lg relative overflow-hidden">
          <div className="max-w-2xl mx-auto flex flex-col items-center">
            <span className="text-xs font-bold uppercase tracking-wider text-indigo-600 mb-2">
              Unlock the Full Experience
            </span>
            <h3 className="font-heading text-3xl sm:text-4xl font-extrabold text-slate-900 mb-4">
              Explore 50,000+ Wallpapers in <span className="gradient-text">PixelPin</span>
            </h3>
            <p className="text-slate-600 text-sm sm:text-base mb-8 max-w-lg">
              Get automatic daily wallpaper rotation, AMOLED true-black battery saver, custom lock screen mockups, and thousands of community submissions on Android.
            </p>
            <a
              href={GOOGLE_PLAY_URL}
              target="_blank"
              rel="noopener noreferrer"
              className="btn-googleplay transform hover:scale-105 transition-all"
            >
              <svg className="w-7 h-7 fill-white" viewBox="0 0 24 24">
                <path d="M3 20.5v-17c0-.83 1.01-1.3 1.6-.73L21.3 11.5a1 1 0 010 1l-16.7 8.73C3.01 21.8 3 21.33 3 20.5z" />
              </svg>
              <div className="flex flex-col text-left">
                <span className="text-[9px] tracking-widest uppercase font-semibold text-slate-300">
                  GET IT ON
                </span>
                <span className="text-lg sm:text-xl font-bold font-heading leading-none text-white">
                  Google Play
                </span>
              </div>
            </a>
          </div>
        </div>
      </div>

      {/* Footer */}
      <footer className="border-t border-slate-200 py-10 px-4 text-center text-xs text-slate-500 bg-white">
        <p>© 2026 PixelPin. All rights reserved.</p>
      </footer>
    </main>
  );
}
