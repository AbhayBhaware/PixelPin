"use client";

import { useEffect, useState } from "react";
import { db } from "@/lib/firebase/client";
import {
  collection,
  getDocs,
  setDoc,
  doc,
  deleteDoc,
  serverTimestamp,
} from "firebase/firestore";
import toast from "react-hot-toast";

interface Category {
  id: string;
  name: string;
  tagline?: string;
  coverImage?: string;
  wallpaperCount?: number;
  featured?: boolean;
}

const DEFAULT_CATEGORIES: Category[] = [
  { id: "amoled", name: "AMOLED", tagline: "Pure #000000 black OLED wallpapers", wallpaperCount: 1420, featured: true },
  { id: "nature", name: "Nature", tagline: "Alpine peaks, lakes, and forests", wallpaperCount: 1840, featured: true },
  { id: "cyberpunk", name: "Cyberpunk", tagline: "Neon future cityscapes and synthwave", wallpaperCount: 960, featured: true },
  { id: "anime", name: "Anime", tagline: "Japanese aesthetic and digital illustrations", wallpaperCount: 1480, featured: true },
  { id: "space", name: "Space", tagline: "Deep cosmos, auroras, and nebulae", wallpaperCount: 890, featured: false },
  { id: "minimal", name: "Minimal", tagline: "Subtle dunes, calm gradients, and clean curves", wallpaperCount: 1150, featured: false },
  { id: "cars", name: "Cars", tagline: "Hypercars, tracks, and midnight velocity", wallpaperCount: 730, featured: false },
  { id: "abstract", name: "Abstract", tagline: "Iridescent 3D liquid fluid and shapes", wallpaperCount: 1020, featured: false },
  { id: "city", name: "City", tagline: "Urban architecture and skyline dusk", wallpaperCount: 650, featured: false },
  { id: "animals", name: "Animals", tagline: "Wildlife, birds, and ocean creatures", wallpaperCount: 540, featured: false },
];

export default function AdminCategoriesPage() {
  const [categories, setCategories] = useState<Category[]>([]);
  const [loading, setLoading] = useState(true);
  const [newName, setNewName] = useState("");
  const [newTagline, setNewTagline] = useState("");
  const [newCover, setNewCover] = useState("");
  const [saving, setSaving] = useState(false);

  const fetchCategories = async () => {
    setLoading(true);
    try {
      const snap = await getDocs(collection(db, "categories"));
      if (snap.empty) {
        setCategories(DEFAULT_CATEGORIES);
      } else {
        const list: Category[] = [];
        snap.forEach((d) => list.push({ id: d.id, ...d.data() } as Category));
        setCategories(list);
      }
    } catch (err) {
      console.warn("Categories fetch fallback:", err);
      setCategories(DEFAULT_CATEGORIES);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchCategories();
  }, []);

  const handleAddCategory = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newName.trim()) return;

    setSaving(true);
    const id = newName.toLowerCase().replace(/[^a-z0-9]/g, "-");
    const newCat: Category = {
      id,
      name: newName.trim(),
      tagline: newTagline.trim() || `${newName} wallpapers`,
      coverImage: newCover.trim() || "https://images.unsplash.com/photo-1514565131-fce0801e5785?auto=format&fit=crop&w=800&q=80",
      wallpaperCount: 0,
      featured: false,
    };

    try {
      await setDoc(doc(db, "categories", id), {
        ...newCat,
        createdAt: serverTimestamp(),
      });
      setCategories((prev) => [...prev, newCat]);
      setNewName("");
      setNewTagline("");
      setNewCover("");
      toast.success(`Category "${newCat.name}" added to database!`);
    } catch (err) {
      toast.error("Failed to add category");
    } finally {
      setSaving(false);
    }
  };

  const handleToggleFeatured = async (cat: Category) => {
    const updated = !cat.featured;
    try {
      await setDoc(doc(db, "categories", cat.id), { featured: updated }, { merge: true });
      setCategories((prev) =>
        prev.map((c) => (c.id === cat.id ? { ...c, featured: updated } : c))
      );
      toast.success(updated ? `"${cat.name}" featured in app!` : `"${cat.name}" unfeatured.`);
    } catch (err) {
      toast.error("Failed to update category");
    }
  };

  const handleDeleteCategory = async (id: string, name: string) => {
    if (!confirm(`Delete category "${name}"?`)) return;
    try {
      await deleteDoc(doc(db, "categories", id));
      setCategories((prev) => prev.filter((c) => c.id !== id));
      toast.success("Category deleted");
    } catch (err) {
      toast.error("Failed to delete category");
    }
  };

  return (
    <div className="space-y-8 max-w-7xl mx-auto">
      {/* Top Banner */}
      <div>
        <h1 className="font-heading text-2xl sm:text-3xl font-extrabold text-slate-900 tracking-tight">
          Category & Tag Management
        </h1>
        <p className="text-slate-500 text-sm mt-1">
          Organize wallpaper genres, featured pills on the Android app home screen, and catalog tags.
        </p>
      </div>

      {/* Add Category Form */}
      <div className="card-clean bg-white border border-slate-200 p-6 rounded-2xl shadow-sm">
        <h3 className="font-heading font-bold text-base text-slate-900 mb-1">
          Add New Wallpaper Category
        </h3>
        <p className="text-xs text-slate-500 mb-4">
          New categories sync immediately to the mobile app and web explore filters.
        </p>

        <form onSubmit={handleAddCategory} className="grid grid-cols-1 sm:grid-cols-4 gap-3">
          <input
            type="text"
            placeholder="Category Name (e.g. Vintage)"
            value={newName}
            onChange={(e) => setNewName(e.target.value)}
            className="input-field text-xs py-2"
            required
          />
          <input
            type="text"
            placeholder="Short Tagline (e.g. Retro aesthetics)"
            value={newTagline}
            onChange={(e) => setNewTagline(e.target.value)}
            className="input-field text-xs py-2"
          />
          <input
            type="url"
            placeholder="Cover Image URL (optional)"
            value={newCover}
            onChange={(e) => setNewCover(e.target.value)}
            className="input-field text-xs py-2"
          />
          <button
            type="submit"
            disabled={saving}
            className="btn-primary text-xs py-2 justify-center shadow-sm disabled:opacity-50"
          >
            {saving ? "Adding..." : "+ Create Category"}
          </button>
        </form>
      </div>

      {/* Categories Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
        {categories.map((cat) => (
          <div
            key={cat.id}
            className="card-clean bg-white border border-slate-200 rounded-2xl p-5 shadow-sm flex flex-col justify-between"
          >
            <div>
              <div className="flex items-start justify-between">
                <div>
                  <h3 className="font-heading font-bold text-base text-slate-900">{cat.name}</h3>
                  <p className="text-xs text-slate-500 mt-0.5">{cat.tagline}</p>
                </div>
                {cat.featured && (
                  <span className="text-[10px] font-extrabold px-2 py-0.5 rounded-full bg-amber-50 text-amber-700 border border-amber-200">
                    ★ Featured
                  </span>
                )}
              </div>
            </div>

            <div className="mt-5 pt-3 border-t border-slate-100 flex items-center justify-between">
              <span className="text-xs font-semibold text-slate-400">
                {cat.wallpaperCount || 0} wallpapers
              </span>

              <div className="flex items-center gap-2">
                <button
                  onClick={() => handleToggleFeatured(cat)}
                  className={`text-xs font-semibold px-2.5 py-1 rounded-lg border transition-all ${
                    cat.featured
                      ? "bg-amber-50 text-amber-700 border-amber-300"
                      : "bg-slate-50 text-slate-600 border-slate-200 hover:bg-slate-100"
                  }`}
                >
                  {cat.featured ? "Featured" : "Make Featured"}
                </button>
                <button
                  onClick={() => handleDeleteCategory(cat.id, cat.name)}
                  className="text-xs text-rose-500 hover:text-rose-700 font-bold p-1"
                  title="Delete category"
                >
                  ✕
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

