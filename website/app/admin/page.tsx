"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { db } from "@/lib/firebase/client";
import {
  collection,
  query,
  where,
  orderBy,
  limit,
  getDocs,
  doc,
  updateDoc,
  serverTimestamp,
} from "firebase/firestore";
import toast from "react-hot-toast";

interface WallpaperItem {
  id: string;
  title: string;
  contributorName: string;
  category: string;
  status: string;
  imageUrl?: string;
  width?: number;
  height?: number;
  createdAt?: any;
}

interface CreatorApplication {
  id: string;
  userId: string;
  displayName: string;
  email: string;
  portfolioUrl: string;
  bio: string;
  artStyle: string;
  status: string;
  appliedAt?: any;
}

export default function AdminDashboardPage() {
  const [loading, setLoading] = useState(true);
  const [stats, setStats] = useState({
    totalWallpapers: 0,
    approvedWallpapers: 0,
    pendingWallpapers: 0,
    rejectedWallpapers: 0,
    pendingCreators: 0,
    approvedCreators: 0,
    totalDownloads: 0,
  });

  const [pendingWallpapers, setPendingWallpapers] = useState<WallpaperItem[]>([]);
  const [pendingCreators, setPendingCreators] = useState<CreatorApplication[]>([]);
  const [processingId, setProcessingId] = useState<string | null>(null);

  const loadDashboardData = async () => {
    setLoading(true);
    try {
      // 1. Fetch Wallpapers
      const wpSnap = await getDocs(collection(db, "wallpapers"));
      let totalWp = 0;
      let approvedWp = 0;
      let pendingWp = 0;
      let rejectedWp = 0;
      let downloads = 0;

      const pendingWpList: WallpaperItem[] = [];

      wpSnap.forEach((d) => {
        totalWp++;
        const data = d.data();
        const s = data.status || "approved";
        if (s === "approved") approvedWp++;
        else if (s === "pending") {
          pendingWp++;
          if (pendingWpList.length < 5) {
            pendingWpList.push({ id: d.id, ...data } as WallpaperItem);
          }
        } else if (s === "rejected") rejectedWp++;

        if (data.stats?.downloads) {
          downloads += Number(data.stats.downloads) || 0;
        }
      });

      // 2. Fetch Creator Applications
      const creatorsSnap = await getDocs(collection(db, "creator_applications"));
      let pendingC = 0;
      let approvedC = 0;
      const pendingCList: CreatorApplication[] = [];

      creatorsSnap.forEach((d) => {
        const data = d.data();
        const s = data.status || "pending";
        if (s === "pending") {
          pendingC++;
          if (pendingCList.length < 5) {
            pendingCList.push({ id: d.id, ...data } as CreatorApplication);
          }
        } else if (s === "approved") {
          approvedC++;
        }
      });

      setStats({
        totalWallpapers: totalWp,
        approvedWallpapers: approvedWp,
        pendingWallpapers: pendingWp,
        rejectedWallpapers: rejectedWp,
        pendingCreators: pendingC,
        approvedCreators: approvedC,
        totalDownloads: downloads,
      });

      setPendingWallpapers(pendingWpList);
      setPendingCreators(pendingCList);
    } catch (err: any) {
      console.warn("Dashboard fetch error:", err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadDashboardData();
  }, []);

  // Quick Action: Approve Wallpaper
  const handleApproveWallpaper = async (id: string) => {
    setProcessingId(id);
    try {
      await updateDoc(doc(db, "wallpapers", id), {
        status: "approved",
        reviewedAt: serverTimestamp(),
        publishedAt: serverTimestamp(),
      });
      setPendingWallpapers((prev) => prev.filter((w) => w.id !== id));
      setStats((prev) => ({
        ...prev,
        pendingWallpapers: Math.max(0, prev.pendingWallpapers - 1),
        approvedWallpapers: prev.approvedWallpapers + 1,
      }));
      toast.success("Wallpaper approved & published to mobile app! ✅");
    } catch (err) {
      toast.error("Failed to approve wallpaper");
    } finally {
      setProcessingId(null);
    }
  };

  // Quick Action: Approve Creator Application from Mobile App
  const handleApproveCreator = async (app: CreatorApplication) => {
    setProcessingId(app.id);
    try {
      // 1. Update creator application
      await updateDoc(doc(db, "creator_applications", app.id), {
        status: "approved",
        reviewedAt: serverTimestamp(),
      });

      // 2. Update user profile to creator role
      if (app.userId) {
        await updateDoc(doc(db, "users", app.userId), {
          role: "creator",
          creatorApplicationStatus: "approved",
          approvedAt: serverTimestamp(),
        });
      }

      setPendingCreators((prev) => prev.filter((c) => c.id !== app.id));
      setStats((prev) => ({
        ...prev,
        pendingCreators: Math.max(0, prev.pendingCreators - 1),
        approvedCreators: prev.approvedCreators + 1,
      }));

      toast.success(`${app.displayName} is now an Approved Creator on mobile app! 🎉`);
    } catch (err) {
      toast.error("Failed to approve creator");
    } finally {
      setProcessingId(null);
    }
  };

  return (
    <div className="space-y-8 max-w-7xl mx-auto">
      {/* Top Banner */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div>
          <h1 className="font-heading text-2xl sm:text-3xl font-extrabold text-slate-900 tracking-tight">
            Admin Operations Dashboard
          </h1>
          <p className="text-slate-500 text-sm mt-1">
            Real-time management for PixelPin Android app, content moderation, and creator ecosystem.
          </p>
        </div>

        <button
          onClick={loadDashboardData}
          disabled={loading}
          className="btn-secondary text-xs py-2 px-4 flex items-center gap-2 shadow-sm"
        >
          <svg className={`w-3.5 h-3.5 ${loading ? "animate-spin" : ""}`} fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
          </svg>
          <span>Refresh Data</span>
        </button>
      </div>

      {/* KPI Stats Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
        {/* Total Wallpapers */}
        <div className="card-clean p-6 bg-white border border-slate-200 shadow-sm flex flex-col justify-between">
          <div className="flex items-center justify-between">
            <span className="text-xs font-bold uppercase tracking-wider text-slate-500">
              Total Wallpapers
            </span>
            <span className="p-2 rounded-xl bg-indigo-50 text-indigo-600">
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
            </span>
          </div>
          <div className="mt-4">
            <div className="text-3xl font-extrabold text-slate-900 font-heading">
              {stats.totalWallpapers}
            </div>
            <div className="flex items-center gap-2 text-xs font-medium mt-2">
              <span className="text-emerald-600 font-semibold">{stats.approvedWallpapers} live</span>
              <span className="text-slate-300">•</span>
              <span className="text-amber-600 font-semibold">{stats.pendingWallpapers} pending</span>
            </div>
          </div>
        </div>

        {/* Wallpaper Review Queue */}
        <div className="card-clean p-6 bg-white border border-slate-200 shadow-sm flex flex-col justify-between">
          <div className="flex items-center justify-between">
            <span className="text-xs font-bold uppercase tracking-wider text-slate-500">
              Review Queue
            </span>
            <span className="p-2 rounded-xl bg-amber-50 text-amber-600">
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </span>
          </div>
          <div className="mt-4">
            <div className="text-3xl font-extrabold text-amber-600 font-heading">
              {stats.pendingWallpapers}
            </div>
            <Link
              href="/admin/queue"
              className="text-xs font-semibold text-indigo-600 hover:text-indigo-700 flex items-center gap-1 mt-2"
            >
              <span>Moderate queue</span>
              <span>→</span>
            </Link>
          </div>
        </div>

        {/* Creator Applications */}
        <div className="card-clean p-6 bg-white border border-slate-200 shadow-sm flex flex-col justify-between">
          <div className="flex items-center justify-between">
            <span className="text-xs font-bold uppercase tracking-wider text-slate-500">
              Mobile Creator Apps
            </span>
            <span className="p-2 rounded-xl bg-purple-50 text-purple-600">
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
              </svg>
            </span>
          </div>
          <div className="mt-4">
            <div className="text-3xl font-extrabold text-slate-900 font-heading">
              {stats.pendingCreators}
            </div>
            <div className="flex items-center gap-2 text-xs font-medium mt-2">
              <span className="text-slate-500">{stats.approvedCreators} approved artists</span>
              <span className="text-slate-300">•</span>
              <Link href="/admin/creators" className="text-indigo-600 font-semibold hover:underline">
                Review
              </Link>
            </div>
          </div>
        </div>

        {/* Total App Downloads */}
        <div className="card-clean p-6 bg-white border border-slate-200 shadow-sm flex flex-col justify-between">
          <div className="flex items-center justify-between">
            <span className="text-xs font-bold uppercase tracking-wider text-slate-500">
              Total App Downloads
            </span>
            <span className="p-2 rounded-xl bg-emerald-50 text-emerald-600">
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M9 19l3 3m0 0l3-3m-3 3V10" />
              </svg>
            </span>
          </div>
          <div className="mt-4">
            <div className="text-3xl font-extrabold text-emerald-600 font-heading">
              {stats.totalDownloads.toLocaleString()}
            </div>
            <p className="text-xs text-slate-400 mt-2">Aggregated from Android users</p>
          </div>
        </div>
      </div>

      {/* Main Grid: Pending Creator Applications + Pending Wallpapers */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        {/* Left: Pending Creator Applications from Mobile App */}
        <div className="card-clean bg-white border border-slate-200 p-6 shadow-sm flex flex-col justify-between">
          <div>
            <div className="flex items-center justify-between mb-4">
              <div>
                <h2 className="font-heading text-lg font-bold text-slate-900 flex items-center gap-2">
                  <span>Creator Applications</span>
                  {pendingCreators.length > 0 && (
                    <span className="text-xs font-extrabold px-2 py-0.5 rounded-full bg-purple-100 text-purple-800">
                      {pendingCreators.length} new
                    </span>
                  )}
                </h2>
                <p className="text-xs text-slate-500">
                  Mobile users requesting Creator status from the PixelPin app
                </p>
              </div>
              <Link href="/admin/creators" className="text-xs font-semibold text-indigo-600 hover:underline">
                View all ({stats.pendingCreators})
              </Link>
            </div>

            {pendingCreators.length === 0 ? (
              <div className="py-12 text-center text-slate-400">
                <div className="text-3xl mb-2">🎉</div>
                <p className="text-sm font-semibold text-slate-700">No pending creator applications</p>
                <p className="text-xs text-slate-400 mt-1">
                  New applications submitted from the mobile app profile will appear here.
                </p>
              </div>
            ) : (
              <div className="space-y-3">
                {pendingCreators.map((app) => (
                  <div
                    key={app.id}
                    className="p-4 rounded-2xl bg-slate-50 border border-slate-200/80 flex flex-col justify-between gap-3"
                  >
                    <div className="flex items-start justify-between gap-3">
                      <div>
                        <div className="font-heading font-bold text-sm text-slate-900">
                          {app.displayName}
                        </div>
                        <div className="text-xs text-slate-500">{app.email}</div>
                        <div className="inline-block mt-1 text-[11px] font-semibold text-indigo-600 bg-indigo-50 px-2 py-0.5 rounded-full border border-indigo-100">
                          {app.artStyle}
                        </div>
                      </div>

                      {app.portfolioUrl && (
                        <a
                          href={app.portfolioUrl.startsWith("http") ? app.portfolioUrl : `https://${app.portfolioUrl}`}
                          target="_blank"
                          rel="noopener noreferrer"
                          className="text-xs font-semibold text-indigo-600 hover:underline flex items-center gap-1 shrink-0"
                        >
                          <span>Portfolio</span>
                          <span>↗</span>
                        </a>
                      )}
                    </div>

                    {app.bio && (
                      <p className="text-xs text-slate-600 italic line-clamp-2">
                        &quot;{app.bio}&quot;
                      </p>
                    )}

                    <div className="flex items-center gap-2 pt-2 border-t border-slate-200/60">
                      <button
                        onClick={() => handleApproveCreator(app)}
                        disabled={processingId === app.id}
                        className="btn-primary flex-1 py-1.5 text-xs justify-center shadow-none disabled:opacity-50"
                      >
                        ✓ Approve as Creator
                      </button>
                      <Link
                        href="/admin/creators"
                        className="btn-secondary py-1.5 px-3 text-xs text-slate-700"
                      >
                        Review
                      </Link>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>

        {/* Right: Wallpaper Review Queue Preview */}
        <div className="card-clean bg-white border border-slate-200 p-6 shadow-sm flex flex-col justify-between">
          <div>
            <div className="flex items-center justify-between mb-4">
              <div>
                <h2 className="font-heading text-lg font-bold text-slate-900 flex items-center gap-2">
                  <span>Wallpapers Awaiting Review</span>
                  {pendingWallpapers.length > 0 && (
                    <span className="text-xs font-extrabold px-2 py-0.5 rounded-full bg-amber-100 text-amber-800">
                      {pendingWallpapers.length} pending
                    </span>
                  )}
                </h2>
                <p className="text-xs text-slate-500">
                  Submitted wallpapers to verify before publishing live in the app
                </p>
              </div>
              <Link href="/admin/queue" className="text-xs font-semibold text-indigo-600 hover:underline">
                Open queue ({stats.pendingWallpapers})
              </Link>
            </div>

            {pendingWallpapers.length === 0 ? (
              <div className="py-12 text-center text-slate-400">
                <div className="text-3xl mb-2">✨</div>
                <p className="text-sm font-semibold text-slate-700">Review queue is empty</p>
                <p className="text-xs text-slate-400 mt-1">
                  All community submissions have been moderated.
                </p>
              </div>
            ) : (
              <div className="space-y-3">
                {pendingWallpapers.map((wp) => (
                  <div
                    key={wp.id}
                    className="p-3 rounded-2xl bg-slate-50 border border-slate-200/80 flex items-center justify-between gap-3"
                  >
                    <div className="flex items-center gap-3 min-w-0">
                      <div className="w-12 h-16 rounded-xl bg-slate-900 overflow-hidden flex-shrink-0">
                        {wp.imageUrl ? (
                          <img src={wp.imageUrl} alt={wp.title} className="w-full h-full object-cover" />
                        ) : (
                          <div className="w-full h-full flex items-center justify-center text-white text-xs">4K</div>
                        )}
                      </div>
                      <div className="min-w-0">
                        <div className="font-heading font-bold text-sm text-slate-900 truncate">
                          {wp.title}
                        </div>
                        <div className="text-xs text-slate-500">by {wp.contributorName}</div>
                        <span className="inline-block mt-1 text-[10px] font-semibold text-indigo-600 bg-indigo-50 px-2 py-0.5 rounded-full border border-indigo-100">
                          {wp.category}
                        </span>
                      </div>
                    </div>

                    <div className="flex items-center gap-2">
                      <button
                        onClick={() => handleApproveWallpaper(wp.id)}
                        disabled={processingId === wp.id}
                        className="btn-primary py-1.5 px-3 text-xs shadow-none disabled:opacity-50"
                      >
                        ✓ Approve
                      </button>
                      <Link
                        href="/admin/queue"
                        className="btn-secondary py-1.5 px-2.5 text-xs text-slate-600 hover:text-slate-900"
                      >
                        Inspect
                      </Link>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}

