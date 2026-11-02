"use client";

import { useEffect, useState, useMemo } from "react";
import Link from "next/link";
import { db } from "@/lib/firebase/client";
import {
  collection,
  getDocs,
  doc,
  updateDoc,
  deleteDoc,
  serverTimestamp,
} from "firebase/firestore";
import toast from "react-hot-toast";

interface Wallpaper {
  id: string;
  title: string;
  contributorName: string;
  category: string;
  status: "approved" | "pending" | "rejected";
  featured?: boolean;
  imageUrl?: string;
  width?: number;
  height?: number;
  stats?: {
    downloads?: number;
    views?: number;
    likes?: number;
  };
  tags?: string[];
  createdAt?: any;
}

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

export default function AdminWallpapersPage() {
  const [wallpapers, setWallpapers] = useState<Wallpaper[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [selectedCategory, setSelectedCategory] = useState("All");
  const [statusFilter, setStatusFilter] = useState<"all" | "approved" | "pending" | "rejected">("all");
  const [processingId, setProcessingId] = useState<string | null>(null);

  const fetchWallpapers = async () => {
    setLoading(true);
    try {
      const snap = await getDocs(collection(db, "wallpapers"));
      const list: Wallpaper[] = [];
      snap.forEach((d) => {
        list.push({ id: d.id, ...d.data() } as Wallpaper);
      });
      setWallpapers(list);
    } catch (err) {
      console.error("Error fetching wallpapers:", err);
      toast.error("Failed to load wallpapers");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchWallpapers();
  }, []);

  const handleToggleFeatured = async (wp: Wallpaper) => {
    setProcessingId(wp.id);
    const newFeatured = !wp.featured;
    try {
      await updateDoc(doc(db, "wallpapers", wp.id), {
        featured: newFeatured,
        featuredAt: newFeatured ? serverTimestamp() : null,
      });

      setWallpapers((prev) =>
        prev.map((w) => (w.id === wp.id ? { ...w, featured: newFeatured } : w))
      );
      toast.success(newFeatured ? "Marked as Featured in app! ⭐" : "Unfeatured from app");
    } catch (err) {
      toast.error("Failed to update featured status");
    } finally {
      setProcessingId(null);
    }
  };

  const handleToggleStatus = async (wp: Wallpaper, newStatus: "approved" | "rejected" | "pending") => {
    setProcessingId(wp.id);
    try {
      await updateDoc(doc(db, "wallpapers", wp.id), {
        status: newStatus,
        reviewedAt: serverTimestamp(),
      });

      setWallpapers((prev) =>
        prev.map((w) => (w.id === wp.id ? { ...w, status: newStatus } : w))
      );
      toast.success(`Wallpaper status set to ${newStatus}`);
    } catch (err) {
      toast.error("Failed to change status");
    } finally {
      setProcessingId(null);
    }
  };

  const handleDelete = async (wp: Wallpaper) => {
    if (!confirm(`Are you sure you want to permanently delete "${wp.title}"?`)) return;
    setProcessingId(wp.id);
    try {
      await deleteDoc(doc(db, "wallpapers", wp.id));
      setWallpapers((prev) => prev.filter((w) => w.id !== wp.id));
      toast.success("Wallpaper deleted from database");
    } catch (err) {
      toast.error("Failed to delete wallpaper");
    } finally {
      setProcessingId(null);
    }
  };

  const filtered = useMemo(() => {
    return wallpapers.filter((w) => {
      const matchSearch =
        search.trim() === "" ||
        w.title?.toLowerCase().includes(search.toLowerCase()) ||
        w.contributorName?.toLowerCase().includes(search.toLowerCase());
      const matchCat =
        selectedCategory === "All" || w.category?.toLowerCase() === selectedCategory.toLowerCase();
      const matchStatus = statusFilter === "all" || w.status === statusFilter;
      return matchSearch && matchCat && matchStatus;
    });
  }, [wallpapers, search, selectedCategory, statusFilter]);

  return (
    <div className="space-y-8 max-w-7xl mx-auto">
      {/* Top Banner */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div>
          <h1 className="font-heading text-2xl sm:text-3xl font-extrabold text-slate-900 tracking-tight">
            Wallpapers Catalog
          </h1>
          <p className="text-slate-500 text-sm mt-1">
            Manage all 4K wallpapers in the database, toggle featured items on the mobile app, and moderate submissions.
          </p>
        </div>

        <div className="flex items-center gap-3">
          <Link href="/upload" className="btn-primary text-xs py-2 px-4 shadow-sm">
            + Upload New Wallpaper
          </Link>
          <button onClick={fetchWallpapers} className="btn-secondary text-xs py-2 px-3">
            Refresh
          </button>
        </div>
      </div>

      {/* Search & Filter Controls */}
      <div className="card-clean bg-white border border-slate-200 p-4 rounded-2xl flex flex-col md:flex-row items-stretch md:items-center justify-between gap-4 shadow-sm">
        {/* Search */}
        <div className="relative flex-1">
          <svg
            className="w-4 h-4 absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
          </svg>
          <input
            type="text"
            placeholder="Search wallpapers by title or creator..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="input-field pl-10 text-xs py-2.5"
          />
        </div>

        {/* Category selector */}
        <select
          value={selectedCategory}
          onChange={(e) => setSelectedCategory(e.target.value)}
          className="input-field md:w-44 text-xs py-2.5 cursor-pointer"
        >
          {CATEGORIES.map((c) => (
            <option key={c} value={c}>
              Category: {c}
            </option>
          ))}
        </select>

        {/* Status filter buttons */}
        <div className="flex items-center gap-1 bg-slate-100 p-1 rounded-xl">
          {(["all", "approved", "pending", "rejected"] as const).map((s) => (
            <button
              key={s}
              onClick={() => setStatusFilter(s)}
              className={`px-3 py-1.5 rounded-lg text-xs font-semibold capitalize transition-all ${
                statusFilter === s ? "bg-white text-slate-900 shadow-sm" : "text-slate-600 hover:text-slate-900"
              }`}
            >
              {s}
            </button>
          ))}
        </div>
      </div>

      {/* Wallpapers Table / Grid */}
      {loading ? (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
          {[...Array(8)].map((_, i) => (
            <div key={i} className="card-clean bg-white border border-slate-200 shimmer h-72 rounded-2xl" />
          ))}
        </div>
      ) : filtered.length === 0 ? (
        <div className="card-clean bg-white border border-slate-200 p-14 text-center max-w-md mx-auto">
          <div className="text-4xl mb-3">🖼️</div>
          <h3 className="font-heading font-bold text-base text-slate-900">No wallpapers found</h3>
          <p className="text-xs text-slate-500 mt-1">
            Try adjusting your search keywords or category filters.
          </p>
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          {filtered.map((wp) => (
            <div
              key={wp.id}
              className="card-clean bg-white border border-slate-200 rounded-2xl overflow-hidden shadow-sm flex flex-col justify-between hover:border-slate-300 transition-all"
            >
              {/* Thumbnail Image */}
              <div className="relative aspect-[9/14] bg-slate-900 overflow-hidden group">
                {wp.imageUrl ? (
                  <img
                    src={wp.imageUrl}
                    alt={wp.title}
                    loading="lazy"
                    className="w-full h-full object-cover transition-transform duration-300 group-hover:scale-105"
                  />
                ) : (
                  <div className="w-full h-full flex items-center justify-center text-white text-xs font-bold">
                    4K Ultra HD
                  </div>
                )}

                {/* Status Badge */}
                <div className="absolute top-2.5 left-2.5">
                  <span
                    className={`text-[10px] font-bold px-2 py-0.5 rounded-full uppercase tracking-wider ${
                      wp.status === "approved"
                        ? "bg-emerald-500 text-white shadow-sm"
                        : wp.status === "rejected"
                        ? "bg-rose-500 text-white"
                        : "bg-amber-500 text-white"
                    }`}
                  >
                    {wp.status}
                  </span>
                </div>

                {/* Featured Badge */}
                {wp.featured && (
                  <div className="absolute top-2.5 right-2.5 bg-amber-400 text-slate-950 text-[10px] font-extrabold px-2 py-0.5 rounded-full shadow-md flex items-center gap-1">
                    <span>★</span> Featured
                  </div>
                )}

                {/* Resolution Pill */}
                {wp.width && wp.height && (
                  <div className="absolute bottom-2.5 right-2.5 bg-black/60 backdrop-blur-sm text-white text-[10px] px-2 py-0.5 rounded-lg">
                    {wp.width}×{wp.height}
                  </div>
                )}
              </div>

              {/* Information */}
              <div className="p-4 flex-1 flex flex-col justify-between">
                <div>
                  <h3 className="font-heading font-bold text-sm text-slate-900 truncate" title={wp.title}>
                    {wp.title || "Untitled Wallpaper"}
                  </h3>
                  <p className="text-xs text-slate-500">by {wp.contributorName || "PixelPin Creator"}</p>

                  <div className="flex items-center justify-between text-xs text-slate-400 mt-3 pt-2 border-t border-slate-100">
                    <span className="font-semibold text-indigo-600 bg-indigo-50 px-2 py-0.5 rounded-full text-[10px]">
                      {wp.category}
                    </span>
                    <span>{wp.stats?.downloads || 0} downloads</span>
                  </div>
                </div>

                {/* Actions */}
                <div className="mt-4 pt-3 border-t border-slate-100 flex items-center justify-between gap-2">
                  <button
                    onClick={() => handleToggleFeatured(wp)}
                    disabled={processingId === wp.id}
                    className={`text-xs font-semibold px-2.5 py-1 rounded-lg border transition-all ${
                      wp.featured
                        ? "bg-amber-50 text-amber-700 border-amber-300"
                        : "bg-slate-50 text-slate-600 border-slate-200 hover:bg-slate-100"
                    }`}
                  >
                    {wp.featured ? "★ Featured" : "☆ Feature"}
                  </button>

                  <div className="flex items-center gap-1.5">
                    {wp.status !== "approved" && (
                      <button
                        onClick={() => handleToggleStatus(wp, "approved")}
                        disabled={processingId === wp.id}
                        className="text-xs font-semibold px-2 py-1 text-emerald-600 hover:bg-emerald-50 rounded-lg"
                        title="Approve & Publish"
                      >
                        ✓
                      </button>
                    )}
                    {wp.status !== "rejected" && (
                      <button
                        onClick={() => handleToggleStatus(wp, "rejected")}
                        disabled={processingId === wp.id}
                        className="text-xs font-semibold px-2 py-1 text-amber-600 hover:bg-amber-50 rounded-lg"
                        title="Reject / Hold"
                      >
                        ✕
                      </button>
                    )}
                    <button
                      onClick={() => handleDelete(wp)}
                      disabled={processingId === wp.id}
                      className="text-xs font-semibold px-2 py-1 text-rose-600 hover:bg-rose-50 rounded-lg"
                      title="Delete permanently"
                    >
                      🗑️
                    </button>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
