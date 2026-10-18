"use client";

import { useEffect, useState } from "react";
import { db } from "@/lib/firebase/client";
import {
  collection, query, where, orderBy, getDocs,
  doc, updateDoc, serverTimestamp, limit,
} from "firebase/firestore";
import { getThumbUrl } from "@/lib/cloudinary";
import toast from "react-hot-toast";

interface Wallpaper {
  id: string;
  title: string;
  contributorName: string;
  cloudinaryPublicId: string;
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
    const q = query(
      collection(db, "wallpapers"),
      where("status", "==", "pending"),
      orderBy("createdAt", "asc"),
      limit(50)
    );
    const snap = await getDocs(q);
    setWallpapers(snap.docs.map((d) => ({ id: d.id, ...d.data() } as Wallpaper)));
    setLoading(false);
  };

  useEffect(() => { fetchQueue(); }, []);

  const approve = async (id: string) => {
    setProcessing(id);
    try {
      await updateDoc(doc(db, "wallpapers", id), {
        status: "approved",
        reviewedAt: serverTimestamp(),
        publishedAt: serverTimestamp(),
      });
      setWallpapers((p) => p.filter((w) => w.id !== id));
      toast.success("Wallpaper approved ✅");
    } catch (err) {
      toast.error("Failed to approve");
    } finally {
      setProcessing(null);
    }
  };

  const reject = async (id: string) => {
    const reason = rejectReason[id]?.trim();
    if (!reason) { toast.error("Please enter a rejection reason"); return; }
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
      toast.error("Failed to reject");
    } finally {
      setProcessing(null);
    }
  };

  return (
    <div className="p-6 max-w-7xl mx-auto">
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-2xl font-bold">Review Queue</h1>
          <p className="text-[#9A95B8] text-sm mt-1">
            {wallpapers.length} wallpaper{wallpapers.length !== 1 ? "s" : ""} pending review
          </p>
        </div>
        <button onClick={fetchQueue} className="btn-secondary text-sm">
          Refresh
        </button>
      </div>

      {loading ? (
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
          {[...Array(6)].map((_, i) => (
            <div key={i} className="rounded-2xl overflow-hidden shimmer" style={{ height: "400px" }} />
          ))}
        </div>
      ) : wallpapers.length === 0 ? (
        <div className="text-center py-20">
          <div className="text-5xl mb-4">🎉</div>
          <h2 className="text-xl font-semibold">Queue is empty!</h2>
          <p className="text-[#9A95B8] mt-2">All wallpapers have been reviewed.</p>
        </div>
      ) : (
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
          {wallpapers.map((w) => (
            <div
              key={w.id}
              className="rounded-2xl overflow-hidden"
              style={{ background: "#1A1A26", border: "1px solid #22223A" }}
            >
              {/* Thumb */}
              <div className="relative" style={{ aspectRatio: "9/16", maxHeight: "320px" }}>
                <img
                  src={getThumbUrl(w.cloudinaryPublicId, 400)}
                  alt={w.title}
                  className="w-full h-full object-cover"
                />
                <div
                  className="absolute top-3 left-3 px-2 py-1 rounded-lg text-xs font-semibold"
                  style={{ background: "rgba(0,0,0,0.7)", color: "#FFC107" }}
                >
                  Pending
                </div>
                <div
                  className="absolute top-3 right-3 px-2 py-1 rounded-lg text-xs"
                  style={{ background: "rgba(0,0,0,0.7)", color: "#9A95B8" }}
                >
                  {w.width}×{w.height}
                </div>
              </div>

              {/* Info */}
              <div className="p-4">
                <h3 className="font-semibold">{w.title}</h3>
                <p className="text-[#9A95B8] text-sm">by {w.contributorName}</p>
                <div className="flex flex-wrap gap-1.5 mt-2">
                  <span className="text-xs px-2 py-0.5 rounded-full"
                    style={{ background: "rgba(124,77,255,0.15)", color: "#B39DDB" }}>
                    {w.category}
                  </span>
                  {w.tags?.slice(0, 3).map((t) => (
                    <span key={t} className="text-xs px-2 py-0.5 rounded-full"
                      style={{ background: "#22223A", color: "#5C5878" }}>
                      #{t}
                    </span>
                  ))}
                </div>

                {/* Reject reason input */}
                <input
                  type="text"
                  placeholder="Rejection reason (required to reject)"
                  className="input-field mt-3 text-xs py-2"
                  value={rejectReason[w.id] || ""}
                  onChange={(e) =>
                    setRejectReason((p) => ({ ...p, [w.id]: e.target.value }))
                  }
                />

                {/* Actions */}
                <div className="flex gap-3 mt-3">
                  <button
                    onClick={() => approve(w.id)}
                    disabled={processing === w.id}
                    className="flex-1 btn-primary text-sm py-2 justify-center disabled:opacity-50"
                  >
                    ✅ Approve
                  </button>
                  <button
                    onClick={() => reject(w.id)}
                    disabled={processing === w.id}
                    className="flex-1 text-sm py-2 rounded-xl font-semibold transition-all disabled:opacity-50"
                    style={{
                      background: "rgba(255,82,82,0.1)",
                      color: "#FF5252",
                      border: "1px solid rgba(255,82,82,0.3)",
                    }}
                  >
                    ❌ Reject
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
