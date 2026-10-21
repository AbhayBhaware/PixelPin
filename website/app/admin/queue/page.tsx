"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { db } from "@/lib/firebase/client";
import {
  collection,
  query,
  where,
  orderBy,
  getDocs,
  doc,
  updateDoc,
  serverTimestamp,
  limit,
} from "firebase/firestore";
import { getThumbUrl } from "@/lib/cloudinary";
import toast from "react-hot-toast";

interface Wallpaper {
  id: string;
  title: string;
  contributorName: string;
  cloudinaryPublicId: string;
  imageUrl?: string;
  category: string;
  status: string;
  createdAt: any;
  width: number;
  height: number;
  tags: string[];
}

export default function AdminQueuePage() {
  const [wallpapers, setWallpapers] = useState<Wallpaper[]>([]);
  const [loading, setLoading] = useState(true);
  const [rejectReason, setRejectReason] = useState<Record<string, string>>({});
  const [processing, setProcessing] = useState<string | null>(null);

  const fetchQueue = async () => {
    setLoading(true);
    try {
      const q = query(
        collection(db, "wallpapers"),
        where("status", "==", "pending"),
        orderBy("createdAt", "asc"),
        limit(50)
      );
      const snap = await getDocs(q);
      setWallpapers(snap.docs.map((d) => ({ id: d.id, ...d.data() } as Wallpaper)));
    } catch (err: any) {
      console.warn("Queue fetch error:", err);
      // If Firestore is empty or index not created yet, show empty queue
      setWallpapers([]);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchQueue();
  }, []);

  const approve = async (id: string) => {
    setProcessing(id);
    try {
      await updateDoc(doc(db, "wallpapers", id), {
        status: "approved",
        reviewedAt: serverTimestamp(),
        publishedAt: serverTimestamp(),
      });
      setWallpapers((p) => p.filter((w) => w.id !== id));
      toast.success("Wallpaper approved! Now visible in PixelPin mobile app ✅");
    } catch (err) {
      toast.error("Failed to approve wallpaper");
    } finally {
      setProcessing(null);
    }
  };

  const reject = async (id: string) => {
    const reason = rejectReason[id]?.trim();
    if (!reason) {
      toast.error("Please enter a rejection reason");
      return;
    }
    setProcessing(id);
    try {
      await updateDoc(doc(db, "wallpapers", id), {
        status: "rejected",
        rejectReason: reason,
        reviewedAt: serverTimestamp(),
      });
      setWallpapers((p) => p.filter((w) => w.id !== id));
      toast.success("Wallpaper rejected");
    } catch (err) {
      toast.error("Failed to reject wallpaper");
    } finally {
      setProcessing(null);
    }
  };

  return (
    <main className="min-h-screen bg-slate-50 text-slate-900 selection:bg-indigo-500 selection:text-white">
      {/* Admin Header */}
      <header className="glass sticky top-0 z-40 px-4 sm:px-8 py-3.5 flex items-center justify-between border-b border-slate-200">
        <div className="flex items-center gap-3">
          <Link href="/" className="flex items-center gap-3">
            <div className="w-9 h-9 rounded-xl bg-gradient-to-tr from-indigo-500 to-pink-500 flex items-center justify-center shadow-sm">
              <svg className="w-4 h-4 text-white" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4">
                <path d="m8 3 4 8 5-5 5 15H2L8 3z" />
              </svg>
            </div>
            <span className="font-heading font-extrabold text-lg text-slate-900">
              PixelPin <span className="text-xs font-semibold px-2 py-0.5 rounded-full bg-amber-50 text-amber-700 border border-amber-200 ml-1">Admin Queue</span>
            </span>
          </Link>
        </div>

        <div className="flex items-center gap-3">
          <Link href="/upload" className="btn-secondary text-xs py-1.5 px-3 text-slate-700">
            + Upload New
          </Link>
          <button
            onClick={fetchQueue}
            className="btn-primary text-xs py-1.5 px-3"
          >
            Refresh
          </button>
        </div>
      </header>

      <div className="p-4 sm:p-8 max-w-7xl mx-auto">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 mb-8">
          <div>
            <div className="inline-flex items-center gap-2 text-xs font-bold uppercase tracking-wider text-amber-600 mb-1">
              <span>●</span> Moderation & Curation
            </div>
            <h1 className="font-heading text-3xl font-extrabold text-slate-900">
              Wallpaper Review Queue
            </h1>
            <p className="text-slate-500 text-sm mt-1">
              {wallpapers.length} wallpaper{wallpapers.length !== 1 ? "s" : ""} pending review. Approved wallpapers immediately sync to the Android app.
            </p>
          </div>
        </div>

        {loading ? (
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            {[...Array(6)].map((_, i) => (
              <div
                key={i}
                className="rounded-3xl overflow-hidden shimmer border border-slate-200"
                style={{ height: "420px" }}
              />
            ))}
          </div>
        ) : wallpapers.length === 0 ? (
          <div className="card-clean bg-white text-center py-20 px-6 max-w-2xl mx-auto border border-slate-200">
            <div className="text-6xl mb-4">🎉</div>
            <h2 className="font-heading text-2xl font-bold text-slate-900">Review Queue is Empty!</h2>
            <p className="text-slate-500 text-sm mt-2 max-w-md mx-auto">
              All submitted wallpapers have been reviewed. When creators upload new wallpapers, they will appear here for verification.
            </p>
            <div className="mt-6 flex items-center justify-center gap-3">
              <Link href="/upload" className="btn-primary text-sm py-2 px-5">
                Submit a Wallpaper
              </Link>
              <Link href="/" className="btn-secondary text-sm py-2 px-4 text-slate-700">
                Back to Home
              </Link>
            </div>
          </div>
        ) : (
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            {wallpapers.map((w) => {
              const displayImage =
                w.imageUrl ||
                (w.cloudinaryPublicId
                  ? getThumbUrl(w.cloudinaryPublicId, 600)
                  : "https://images.unsplash.com/photo-1514565131-fce0801e5785?auto=format&fit=crop&w=800&q=80");

              return (
                <div
                  key={w.id}
                  className="card-clean rounded-3xl overflow-hidden bg-white border border-slate-200 shadow-sm flex flex-col"
                >
                  {/* Thumb Preview */}
                  <div className="relative aspect-[9/14] max-h-[340px] bg-slate-900 overflow-hidden">
                    <img
                      src={displayImage}
                      alt={w.title}
                      className="w-full h-full object-cover"
                    />
                    <div className="absolute top-3 left-3 px-2.5 py-1 rounded-full text-xs font-bold bg-amber-500 text-white shadow-sm">
                      Pending Review
                    </div>
                    <div className="absolute top-3 right-3 px-2.5 py-1 rounded-full text-xs font-semibold bg-black/60 text-white backdrop-blur-sm">
                      {w.width} × {w.height} px
                    </div>
                  </div>

                  {/* Info */}
                  <div className="p-5 flex-1 flex flex-col justify-between">
                    <div>
                      <h3 className="font-heading font-bold text-base text-slate-900">
                        {w.title}
                      </h3>
                      <p className="text-slate-500 text-xs mt-0.5">
                        by <span className="font-medium text-slate-700">{w.contributorName}</span>
                      </p>

                      <div className="flex flex-wrap gap-1.5 mt-3">
                        <span className="text-xs px-2.5 py-0.5 rounded-full bg-indigo-50 text-indigo-600 font-semibold border border-indigo-100">
                          {w.category}
                        </span>
                        {w.tags?.slice(0, 3).map((t) => (
                          <span
                            key={t}
                            className="text-xs px-2 py-0.5 rounded-full bg-slate-100 text-slate-600 font-medium"
                          >
                            #{t}
                          </span>
                        ))}
                      </div>

                      {/* Reject reason input */}
                      <input
                        type="text"
                        placeholder="Rejection reason (required if rejecting)..."
                        className="input-field mt-3 text-xs py-2 bg-slate-50"
                        value={rejectReason[w.id] || ""}
                        onChange={(e) =>
                          setRejectReason((p) => ({ ...p, [w.id]: e.target.value }))
                        }
                      />
                    </div>

                    {/* Actions */}
                    <div className="flex gap-2.5 mt-4 pt-3 border-t border-slate-100">
                      <button
                        onClick={() => approve(w.id)}
                        disabled={processing === w.id}
                        className="flex-1 btn-primary text-xs py-2.5 justify-center shadow-sm disabled:opacity-50"
                      >
                        ✓ Approve (Go Live)
                      </button>
                      <button
                        onClick={() => reject(w.id)}
                        disabled={processing === w.id}
                        className="flex-1 btn-danger text-xs py-2.5 justify-center disabled:opacity-50"
                      >
                        ✕ Reject
                      </button>
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>
    </main>
  );
}
