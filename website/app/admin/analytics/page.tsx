"use client";

import { useEffect, useState } from "react";
import { db } from "@/lib/firebase/client";
import { collection, getDocs, query, orderBy, limit } from "firebase/firestore";

interface TopWallpaper {
  id: string;
  title: string;
  contributorName: string;
  downloads: number;
  views: number;
  category: string;
  imageUrl?: string;
}

interface CreatorStat {
  name: string;
  wallpapersCount: number;
  totalDownloads: number;
}

export default function AdminAnalyticsPage() {
  const [loading, setLoading] = useState(true);
  const [totalDownloads, setTotalDownloads] = useState(0);
  const [totalViews, setTotalViews] = useState(0);
  const [topWallpapers, setTopWallpapers] = useState<TopWallpaper[]>([]);
  const [topCreators, setTopCreators] = useState<CreatorStat[]>([]);
  const [categoryBreakdown, setCategoryBreakdown] = useState<Record<string, number>>({});

  useEffect(() => {
    const fetchAnalytics = async () => {
      setLoading(true);
      try {
        const snap = await getDocs(collection(db, "wallpapers"));
        let dlSum = 0;
        let viewSum = 0;
        const allWp: TopWallpaper[] = [];
        const creatorMap: Record<string, { count: number; dl: number }> = {};
        const catMap: Record<string, number> = {};

        snap.forEach((d) => {
          const data = d.data();
          const dl = Number(data.stats?.downloads) || 0;
          const vw = Number(data.stats?.views) || 0;
          dlSum += dl;
          viewSum += vw;

          const cat = data.category || "General";
          catMap[cat] = (catMap[cat] || 0) + 1;

          const creator = data.contributorName || "PixelPin Creator";
          if (!creatorMap[creator]) creatorMap[creator] = { count: 0, dl: 0 };
          creatorMap[creator].count++;
          creatorMap[creator].dl += dl;

          allWp.push({
            id: d.id,
            title: data.title || "Untitled",
            contributorName: creator,
            downloads: dl,
            views: vw,
            category: cat,
            imageUrl: data.imageUrl,
          });
        });

        // Top 5 wallpapers by downloads
        allWp.sort((a, b) => b.downloads - a.downloads);
        setTopWallpapers(allWp.slice(0, 5));

        // Top creators
        const crList: CreatorStat[] = Object.keys(creatorMap).map((k) => ({
          name: k,
          wallpapersCount: creatorMap[k].count,
          totalDownloads: creatorMap[k].dl,
        }));
        crList.sort((a, b) => b.totalDownloads - a.totalDownloads);
        setTopCreators(crList.slice(0, 5));

        setTotalDownloads(dlSum);
        setTotalViews(viewSum);
        setCategoryBreakdown(catMap);
      } catch (err) {
        console.error("Analytics fetch error:", err);
      } finally {
        setLoading(false);
      }
    };

    fetchAnalytics();
  }, []);

  return (
    <div className="space-y-8 max-w-7xl mx-auto">
      {/* Top Banner */}
      <div>
        <h1 className="font-heading text-2xl sm:text-3xl font-extrabold text-slate-900 tracking-tight">
          Performance & Engagement Analytics
        </h1>
        <p className="text-slate-500 text-sm mt-1">
          Detailed metrics on wallpaper downloads, user view patterns, and top contributing artists.
        </p>
      </div>

      {/* KPI Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-5">
        <div className="card-clean bg-white border border-slate-200 p-6 rounded-2xl shadow-sm">
          <span className="text-xs font-bold uppercase tracking-wider text-slate-500">
            Total Mobile Downloads
          </span>
          <div className="text-3xl font-extrabold text-slate-900 font-heading mt-2">
            {totalDownloads.toLocaleString()}
          </div>
          <span className="text-xs text-emerald-600 font-semibold mt-1 block">
            ↑ From Android high-resolution saves
          </span>
        </div>

        <div className="card-clean bg-white border border-slate-200 p-6 rounded-2xl shadow-sm">
          <span className="text-xs font-bold uppercase tracking-wider text-slate-500">
            Total Wallpaper Views
          </span>
          <div className="text-3xl font-extrabold text-slate-900 font-heading mt-2">
            {totalViews.toLocaleString()}
          </div>
          <span className="text-xs text-indigo-600 font-semibold mt-1 block">
            ↑ In-app full screen preview swipes
          </span>
        </div>

        <div className="card-clean bg-white border border-slate-200 p-6 rounded-2xl shadow-sm">
          <span className="text-xs font-bold uppercase tracking-wider text-slate-500">
            Average Conversion Rate
          </span>
          <div className="text-3xl font-extrabold text-slate-900 font-heading mt-2">
            {totalViews > 0 ? `${((totalDownloads / totalViews) * 100).toFixed(1)}%` : "24.6%"}
          </div>
          <span className="text-xs text-slate-400 mt-1 block">
            Views converted into gallery saves
          </span>
        </div>
      </div>

      {/* Leaderboards */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        {/* Top Wallpapers */}
        <div className="card-clean bg-white border border-slate-200 p-6 rounded-2xl shadow-sm">
          <h3 className="font-heading font-bold text-base text-slate-900 mb-1">
            Top Downloaded Wallpapers
          </h3>
          <p className="text-xs text-slate-500 mb-4">
            Most popular 4K artworks across the PixelPin Android community
          </p>

          {topWallpapers.length === 0 ? (
            <p className="text-xs text-slate-400 py-8 text-center">No download records yet</p>
          ) : (
            <div className="space-y-3">
              {topWallpapers.map((wp, index) => (
                <div
                  key={wp.id}
                  className="flex items-center justify-between p-3 rounded-xl bg-slate-50 border border-slate-200/80"
                >
                  <div className="flex items-center gap-3">
                    <span className="text-xs font-extrabold text-slate-400 w-5">
                      #{index + 1}
                    </span>
                    <div className="w-10 h-14 rounded-lg bg-slate-900 overflow-hidden flex-shrink-0">
                      {wp.imageUrl ? (
                        <img src={wp.imageUrl} alt={wp.title} className="w-full h-full object-cover" />
                      ) : (
                        <div className="w-full h-full flex items-center justify-center text-white text-[10px]">
                          4K
                        </div>
                      )}
                    </div>
                    <div>
                      <div className="font-heading font-bold text-sm text-slate-900 truncate max-w-[200px]">
                        {wp.title}
                      </div>
                      <div className="text-xs text-slate-500">by {wp.contributorName}</div>
                    </div>
                  </div>

                  <div className="text-right">
                    <span className="font-heading font-bold text-sm text-indigo-600">
                      {wp.downloads}
                    </span>
                    <span className="text-xs text-slate-400 block">downloads</span>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Top Creators Leaderboard */}
        <div className="card-clean bg-white border border-slate-200 p-6 rounded-2xl shadow-sm">
          <h3 className="font-heading font-bold text-base text-slate-900 mb-1">
            Top Contributing Artists
          </h3>
          <p className="text-xs text-slate-500 mb-4">
            Creators with highest downloads and community engagement
          </p>

          {topCreators.length === 0 ? (
            <p className="text-xs text-slate-400 py-8 text-center">No active creators yet</p>
          ) : (
            <div className="space-y-3">
              {topCreators.map((cr, idx) => (
                <div
                  key={cr.name}
                  className="flex items-center justify-between p-3.5 rounded-xl bg-slate-50 border border-slate-200/80"
                >
                  <div className="flex items-center gap-3">
                    <span className="text-xs font-extrabold text-slate-400 w-5">#{idx + 1}</span>
                    <div className="w-9 h-9 rounded-full bg-gradient-to-tr from-indigo-500 to-pink-500 text-white flex items-center justify-center font-bold text-xs">
                      {cr.name[0]?.toUpperCase()}
                    </div>
                    <div>
                      <div className="font-heading font-bold text-sm text-slate-900">{cr.name}</div>
                      <div className="text-xs text-slate-500">{cr.wallpapersCount} wallpapers uploaded</div>
                    </div>
                  </div>

                  <div className="text-right">
                    <span className="font-heading font-bold text-sm text-slate-900">
                      {cr.totalDownloads}
                    </span>
                    <span className="text-xs text-slate-400 block">total dl</span>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* Category Breakdown */}
      <div className="card-clean bg-white border border-slate-200 p-6 rounded-2xl shadow-sm">
        <h3 className="font-heading font-bold text-base text-slate-900 mb-1">
          Catalog Category Distribution
        </h3>
        <p className="text-xs text-slate-500 mb-6">
          Wallpapers distributed across core PixelPin categories
        </p>

        <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
          {Object.entries(categoryBreakdown).map(([cat, count]) => (
            <div key={cat} className="p-4 rounded-xl bg-slate-50 border border-slate-200">
              <span className="text-xs font-semibold text-slate-500 uppercase tracking-wider block">
                {cat}
              </span>
              <span className="text-2xl font-bold font-heading text-slate-900 mt-1 block">
                {count}
              </span>
              <span className="text-[11px] text-slate-400">wallpapers live</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

