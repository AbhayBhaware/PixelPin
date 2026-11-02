"use client";

import { useEffect, useState } from "react";
import { db } from "@/lib/firebase/client";
import { doc, getDoc, setDoc, serverTimestamp } from "firebase/firestore";
import toast from "react-hot-toast";

interface AppConfig {
  appName: string;
  appVersion: string;
  googlePlayUrl: string;
  enablePixabayFallback: boolean;
  enableCreatorApplications: boolean;
  announcementTitle: string;
  announcementMessage: string;
  announcementActive: boolean;
}

const DEFAULT_CONFIG: AppConfig = {
  appName: "PixelPin",
  appVersion: "1.0.0",
  googlePlayUrl: "https://play.google.com/store/apps/details?id=com.pixelpin.pixelpin",
  enablePixabayFallback: true,
  enableCreatorApplications: true,
  announcementTitle: "Welcome to PixelPin 4K!",
  announcementMessage: "Discover thousands of fresh AMOLED wallpapers updated daily.",
  announcementActive: true,
};

export default function AdminSettingsPage() {
  const [config, setConfig] = useState<AppConfig>(DEFAULT_CONFIG);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    const fetchSettings = async () => {
      setLoading(true);
      try {
        const snap = await getDoc(doc(db, "settings", "app_config"));
        if (snap.exists()) {
          setConfig({ ...DEFAULT_CONFIG, ...(snap.data() as Partial<AppConfig>) });
        }
      } catch (err) {
        console.warn("Settings fetch fallback:", err);
      } finally {
        setLoading(false);
      }
    };

    fetchSettings();
  }, []);

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);
    try {
      await setDoc(
        doc(db, "settings", "app_config"),
        {
          ...config,
          updatedAt: serverTimestamp(),
        },
        { merge: true }
      );
      toast.success("Platform settings saved & synced to mobile app! 🚀");
    } catch (err) {
      toast.error("Failed to save settings");
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="space-y-8 max-w-4xl mx-auto">
      {/* Top Banner */}
      <div>
        <h1 className="font-heading text-2xl sm:text-3xl font-extrabold text-slate-900 tracking-tight">
          Platform & Mobile App Settings
        </h1>
        <p className="text-slate-500 text-sm mt-1">
          Configure global mobile app flags, Pixabay image API fallback, and community announcements.
        </p>
      </div>

      <form onSubmit={handleSave} className="space-y-6">
        {/* Mobile App Metadata */}
        <div className="card-clean bg-white border border-slate-200 p-6 rounded-2xl shadow-sm space-y-4">
          <h3 className="font-heading font-bold text-base text-slate-900">
            Android Application Details
          </h3>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label className="block text-xs font-semibold text-slate-600 mb-1">
                Application Name
              </label>
              <input
                type="text"
                value={config.appName}
                onChange={(e) => setConfig({ ...config, appName: e.target.value })}
                className="input-field text-xs py-2.5"
                required
              />
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-600 mb-1">
                Release Version
              </label>
              <input
                type="text"
                value={config.appVersion}
                onChange={(e) => setConfig({ ...config, appVersion: e.target.value })}
                className="input-field text-xs py-2.5"
                required
              />
            </div>
          </div>

          <div>
            <label className="block text-xs font-semibold text-slate-600 mb-1">
              Google Play Store URL
            </label>
            <input
              type="url"
              value={config.googlePlayUrl}
              onChange={(e) => setConfig({ ...config, googlePlayUrl: e.target.value })}
              className="input-field text-xs py-2.5"
              required
            />
          </div>
        </div>

        {/* Feature Flags */}
        <div className="card-clean bg-white border border-slate-200 p-6 rounded-2xl shadow-sm space-y-5">
          <h3 className="font-heading font-bold text-base text-slate-900">
            Feature Toggles & APIs
          </h3>

          <div className="flex items-center justify-between py-2 border-b border-slate-100">
            <div>
              <div className="font-heading font-bold text-sm text-slate-900">
                Pixabay API Image Fallback
              </div>
              <p className="text-xs text-slate-500">
                Automatically fetches high-res wallpaper previews from Pixabay when user searches broad terms
              </p>
            </div>
            <input
              type="checkbox"
              checked={config.enablePixabayFallback}
              onChange={(e) => setConfig({ ...config, enablePixabayFallback: e.target.checked })}
              className="w-5 h-5 text-indigo-600 rounded cursor-pointer"
            />
          </div>

          <div className="flex items-center justify-between py-2">
            <div>
              <div className="font-heading font-bold text-sm text-slate-900">
                Mobile Creator Applications
              </div>
              <p className="text-xs text-slate-500">
                Allows mobile users to apply for Creator status directly from their Profile screen
              </p>
            </div>
            <input
              type="checkbox"
              checked={config.enableCreatorApplications}
              onChange={(e) => setConfig({ ...config, enableCreatorApplications: e.target.checked })}
              className="w-5 h-5 text-indigo-600 rounded cursor-pointer"
            />
          </div>
        </div>

        {/* Global In-App Announcement */}
        <div className="card-clean bg-white border border-slate-200 p-6 rounded-2xl shadow-sm space-y-4">
          <div className="flex items-center justify-between">
            <div>
              <h3 className="font-heading font-bold text-base text-slate-900">
                In-App Announcement Banner
              </h3>
              <p className="text-xs text-slate-500">
                Pushes a banner announcement to all Android users on app open
              </p>
            </div>
            <label className="flex items-center gap-2 cursor-pointer text-xs font-semibold text-slate-700">
              <input
                type="checkbox"
                checked={config.announcementActive}
                onChange={(e) => setConfig({ ...config, announcementActive: e.target.checked })}
                className="w-4 h-4 text-indigo-600 rounded"
              />
              <span>Active</span>
            </label>
          </div>

          <div>
            <label className="block text-xs font-semibold text-slate-600 mb-1">
              Banner Title
            </label>
            <input
              type="text"
              value={config.announcementTitle}
              onChange={(e) => setConfig({ ...config, announcementTitle: e.target.value })}
              className="input-field text-xs py-2.5"
            />
          </div>

          <div>
            <label className="block text-xs font-semibold text-slate-600 mb-1">
              Message Content
            </label>
            <textarea
              rows={2}
              value={config.announcementMessage}
              onChange={(e) => setConfig({ ...config, announcementMessage: e.target.value })}
              className="input-field text-xs py-2.5 resize-none"
            />
          </div>
        </div>

        {/* Save button */}
        <button
          type="submit"
          disabled={saving}
          className="btn-primary w-full py-3 text-sm font-bold shadow-md disabled:opacity-50"
        >
          {saving ? "Saving Changes..." : "Save Platform Settings"}
        </button>
      </form>
    </div>
  );
}
