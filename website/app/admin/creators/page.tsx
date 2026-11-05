"use client";

import { useEffect, useState } from "react";
import { db } from "@/lib/firebase/client";
import {
  collection,
  query,
  orderBy,
  getDocs,
  doc,
  updateDoc,
  serverTimestamp,
  setDoc,
} from "firebase/firestore";
import toast from "react-hot-toast";

interface CreatorApp {
  id: string;
  userId: string;
  displayName: string;
  email: string;
  portfolioUrl: string;
  bio: string;
  artStyle: string;
  status: "pending" | "approved" | "rejected";
  appliedAt?: any;
  rejectionReason?: string;
}

export default function AdminCreatorsPage() {
  const [applications, setApplications] = useState<CreatorApp[]>([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState<"all" | "pending" | "approved" | "rejected">("pending");
  const [processingId, setProcessingId] = useState<string | null>(null);
  const [rejectReason, setRejectReason] = useState<Record<string, string>>({});
  const [manualUserId, setManualUserId] = useState("");
  const [manualEmail, setManualEmail] = useState("");
  const [dbError, setDbError] = useState<string | null>(null);

  const fetchApplications = async () => {
    setLoading(true);
    try {
      const q = query(collection(db, "creator_applications"), orderBy("appliedAt", "desc"));
      const snap = await getDocs(q);
      const list: CreatorApp[] = [];
      snap.forEach((d) => {
        list.push({ id: d.id, ...d.data() } as CreatorApp);
      });
      setApplications(list);
      setDbError(null);
    } catch (err: any) {
      console.warn("Error fetching applications:", err);
      // Fallback query without orderBy if index not created
      try {
        const snap = await getDocs(collection(db, "creator_applications"));
        const list: CreatorApp[] = [];
        snap.forEach((d) => {
          list.push({ id: d.id, ...d.data() } as CreatorApp);
        });
        setApplications(list);
        setDbError(null);
      } catch (e: any) {
        console.error(e);
        const errMsg = e?.message || e?.code || String(e);
        if (
          errMsg.includes("disabled") ||
          errMsg.includes("SERVICE_DISABLED") ||
          errMsg.includes("unavailable") ||
          errMsg.includes("permission-denied") ||
          errMsg.includes("PERMISSION_DENIED")
        ) {
          setDbError(
            "Cloud Firestore database is not enabled yet in project 'pixelpin-92db0'. Please click 'Create database' under Firestore Database in the Firebase Console."
          );
        }
      }
    } finally {
      setLoading(false);
    }
  };

  const handleCreateSample = async () => {
    const sampleId = "sample_" + Date.now();
    const sampleData: CreatorApp = {
      id: sampleId,
      userId: sampleId,
      displayName: "Elena Vance (Sample Artist)",
      email: "elena.art@pixelpin.app",
      portfolioUrl: "https://instagram.com/elena_wallpapers",
      bio: "Digital 3D landscape and minimalist dark AMOLED creator with 4+ years of experience.",
      artStyle: "AMOLED & Minimal",
      status: "pending",
      appliedAt: new Date(),
    };

    try {
      await setDoc(doc(db, "creator_applications", sampleId), {
        ...sampleData,
        appliedAt: serverTimestamp(),
      });
      toast.success("Sample creator application saved to Firestore!");
      fetchApplications();
    } catch (err) {
      // If Firestore is not enabled yet in Firebase console, render in local state for instant review UI testing
      setApplications((prev) => [sampleData, ...prev]);
      toast.success("Sample application loaded locally for review workflow testing!");
    }
  };

  useEffect(() => {
    fetchApplications();
  }, []);

  const handleApprove = async (app: CreatorApp) => {
    setProcessingId(app.id);
    try {
      // 1. Update creator application
      await updateDoc(doc(db, "creator_applications", app.id), {
        status: "approved",
        reviewedAt: serverTimestamp(),
      });

      // 2. Update user profile to creator role
      if (app.userId) {
        await setDoc(
          doc(db, "users", app.userId),
          {
            role: "creator",
            creatorApplicationStatus: "approved",
            approvedAt: serverTimestamp(),
          },
          { merge: true }
        );
      }

      setApplications((prev) =>
        prev.map((a) => (a.id === app.id ? { ...a, status: "approved" } : a))
      );
      toast.success(`${app.displayName} approved as Creator! Status updated in mobile app.`);
    } catch (err) {
      console.error(err);
      toast.error("Failed to approve creator application");
    } finally {
      setProcessingId(null);
    }
  };

  const handleReject = async (app: CreatorApp) => {
    const reason = rejectReason[app.id]?.trim() || "Portfolio did not meet current resolution criteria.";
    setProcessingId(app.id);
    try {
      await updateDoc(doc(db, "creator_applications", app.id), {
        status: "rejected",
        rejectionReason: reason,
        reviewedAt: serverTimestamp(),
      });

      if (app.userId) {
        await setDoc(
          doc(db, "users", app.userId),
          {
            creatorApplicationStatus: "rejected",
          },
          { merge: true }
        );
      }

      setApplications((prev) =>
        prev.map((a) => (a.id === app.id ? { ...a, status: "rejected", rejectionReason: reason } : a))
      );
      toast.success("Application marked as rejected with feedback.");
    } catch (err) {
      console.error(err);
      toast.error("Failed to reject application");
    } finally {
      setProcessingId(null);
    }
  };

  const handleRevoke = async (app: CreatorApp) => {
    if (!confirm(`Are you sure you want to revoke creator status for ${app.displayName}?`)) return;
    setProcessingId(app.id);
    try {
      await updateDoc(doc(db, "creator_applications", app.id), {
        status: "rejected",
        rejectionReason: "Creator status revoked by administrator.",
        reviewedAt: serverTimestamp(),
      });

      if (app.userId) {
        await updateDoc(doc(db, "users", app.userId), {
          role: "viewer",
          creatorApplicationStatus: "none",
        });
      }

      setApplications((prev) =>
        prev.map((a) => (a.id === app.id ? { ...a, status: "rejected" } : a))
      );
      toast.success("Creator privileges revoked.");
    } catch (err) {
      toast.error("Failed to revoke privileges");
    } finally {
      setProcessingId(null);
    }
  };

  const handleManualGrant = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!manualUserId.trim()) {
      toast.error("Please provide a user ID");
      return;
    }

    try {
      await setDoc(
        doc(db, "users", manualUserId.trim()),
        {
          role: "creator",
          creatorApplicationStatus: "approved",
          email: manualEmail.trim() || undefined,
          updatedAt: serverTimestamp(),
        },
        { merge: true }
      );

      await setDoc(
        doc(db, "creator_applications", manualUserId.trim()),
        {
          userId: manualUserId.trim(),
          displayName: manualEmail.split("@")[0] || "Direct Creator",
          email: manualEmail.trim() || "direct@pixelpin.app",
          portfolioUrl: "Admin Granted",
          bio: "Granted directly by admin console",
          artStyle: "All Categories",
          status: "approved",
          appliedAt: serverTimestamp(),
        },
        { merge: true }
      );

      toast.success("Creator role granted to user!");
      setManualUserId("");
      setManualEmail("");
      fetchApplications();
    } catch (err) {
      toast.error("Error granting role");
    }
  };

  const filtered = applications.filter((app) => {
    if (filter === "all") return true;
    return app.status === filter;
  });

  return (
    <div className="space-y-8 max-w-7xl mx-auto">
      {/* Top Banner */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div>
          <h1 className="font-heading text-2xl sm:text-3xl font-extrabold text-slate-900 tracking-tight">
            Creator Applications & Artists
          </h1>
          <p className="text-slate-500 text-sm mt-1">
            Review artist submissions from the PixelPin mobile app. Approved creators can publish live 4K wallpapers.
          </p>
        </div>

        <div className="flex items-center gap-3">
          <button
            onClick={handleCreateSample}
            className="btn-secondary text-xs py-2 px-3.5 bg-indigo-50 text-indigo-700 border-indigo-200 hover:bg-indigo-100 flex items-center gap-1.5"
            title="Generate a sample mobile creator application for instant testing"
          >
            <span>+</span>
            <span>Create Test Application</span>
          </button>
          <button
            onClick={fetchApplications}
            className="btn-secondary text-xs py-2 px-4 shadow-sm"
          >
            Refresh List
          </button>
        </div>
      </div>

      {/* Firestore Setup Guidance Alert */}
      {dbError && (
        <div className="rounded-2xl p-5 bg-amber-50 border border-amber-200 text-amber-900 shadow-sm flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
          <div className="flex items-start gap-3">
            <span className="text-2xl mt-0.5">⚠️</span>
            <div>
              <h4 className="font-heading font-bold text-sm text-amber-950">
                Cloud Firestore Database is not enabled in Firebase Console
              </h4>
              <p className="text-xs text-amber-800 mt-1 max-w-2xl leading-relaxed">
                Google Cloud reported that the Cloud Firestore API has not been activated for project <strong>pixelpin-92db0</strong>.
                To receive live creator applications from the mobile app, go to your Firebase Console and click <strong>Create database</strong>.
              </p>
            </div>
          </div>
          <a
            href="https://console.firebase.google.com/project/pixelpin-92db0/firestore"
            target="_blank"
            rel="noopener noreferrer"
            className="btn-primary bg-amber-600 hover:bg-amber-700 text-white text-xs py-2.5 px-4 rounded-xl shrink-0"
          >
            Open Firestore Console ↗
          </a>
        </div>
      )}

      {/* Filter Tabs */}
      <div className="flex items-center gap-2 border-b border-slate-200 pb-3 overflow-x-auto">
        {(["pending", "approved", "rejected", "all"] as const).map((tab) => {
          const count = applications.filter((a) => (tab === "all" ? true : a.status === tab)).length;
          const isActive = filter === tab;
          return (
            <button
              key={tab}
              onClick={() => setFilter(tab)}
              className={`px-4 py-2 rounded-xl text-xs font-bold capitalize transition-all flex items-center gap-2 ${
                isActive
                  ? "bg-indigo-600 text-white shadow-sm"
                  : "bg-white text-slate-600 border border-slate-200 hover:bg-slate-50"
              }`}
            >
              <span>{tab === "all" ? "All Applications" : tab}</span>
              <span
                className={`text-[10px] px-1.5 py-0.2 rounded-full ${
                  isActive ? "bg-white/20 text-white" : "bg-slate-100 text-slate-600"
                }`}
              >
                {count}
              </span>
            </button>
          );
        })}
      </div>

      {/* Applications Grid */}
      {loading ? (
        <div className="grid md:grid-cols-2 gap-6">
          {[...Array(4)].map((_, i) => (
            <div key={i} className="card-clean p-6 bg-white border border-slate-200 shimmer h-48" />
          ))}
        </div>
      ) : filtered.length === 0 ? (
        <div className="card-clean bg-white border border-slate-200 p-12 text-center max-w-lg mx-auto">
          <div className="text-4xl mb-3">📬</div>
          <h3 className="font-heading font-bold text-base text-slate-900">
            No {filter} applications found
          </h3>
          <p className="text-xs text-slate-500 mt-1">
            When users tap &quot;Apply to Become a Creator&quot; in the mobile app, their applications appear here.
          </p>
          <button
            onClick={handleCreateSample}
            className="mt-5 btn-primary text-xs py-2 px-4 shadow-sm"
          >
            + Generate Test Application
          </button>
        </div>
      ) : (
        <div className="grid md:grid-cols-2 gap-6">
          {filtered.map((app) => (
            <div
              key={app.id}
              className="card-clean bg-white border border-slate-200 p-6 shadow-sm rounded-2xl flex flex-col justify-between"
            >
              <div>
                {/* Header */}
                <div className="flex items-start justify-between gap-4">
                  <div className="flex items-center gap-3">
                    <div className="w-12 h-12 rounded-full bg-gradient-to-tr from-indigo-500 to-pink-500 text-white flex items-center justify-center font-bold text-lg">
                      {app.displayName?.[0]?.toUpperCase() || "A"}
                    </div>
                    <div>
                      <h3 className="font-heading font-bold text-base text-slate-900">
                        {app.displayName}
                      </h3>
                      <p className="text-xs text-slate-500">{app.email}</p>
                    </div>
                  </div>

                  <span
                    className={`text-[11px] font-bold px-2.5 py-0.5 rounded-full uppercase tracking-wider ${
                      app.status === "approved"
                        ? "bg-emerald-50 text-emerald-700 border border-emerald-200"
                        : app.status === "rejected"
                        ? "bg-rose-50 text-rose-700 border border-rose-200"
                        : "bg-amber-50 text-amber-700 border border-amber-200"
                    }`}
                  >
                    {app.status}
                  </span>
                </div>

                {/* Details */}
                <div className="mt-4 space-y-2 text-xs">
                  <div className="flex items-center justify-between py-1 border-b border-slate-100">
                    <span className="text-slate-400 font-medium">Art Style</span>
                    <span className="font-semibold text-slate-800">{app.artStyle || "General"}</span>
                  </div>

                  <div className="flex items-center justify-between py-1 border-b border-slate-100">
                    <span className="text-slate-400 font-medium">Portfolio Link</span>
                    {app.portfolioUrl ? (
                      <a
                        href={app.portfolioUrl.startsWith("http") ? app.portfolioUrl : `https://${app.portfolioUrl}`}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="font-semibold text-indigo-600 hover:underline max-w-[200px] truncate"
                      >
                        {app.portfolioUrl} ↗
                      </a>
                    ) : (
                      <span className="text-slate-400">None</span>
                    )}
                  </div>

                  {app.bio && (
                    <div className="pt-2">
                      <span className="text-slate-400 font-medium block mb-1">Artist Bio</span>
                      <p className="text-slate-600 italic bg-slate-50 p-2.5 rounded-xl border border-slate-100">
                        &quot;{app.bio}&quot;
                      </p>
                    </div>
                  )}

                  {app.rejectionReason && (
                    <div className="pt-2 text-rose-600 font-medium">
                      Rejection feedback: &quot;{app.rejectionReason}&quot;
                    </div>
                  )}
                </div>
              </div>

              {/* Action Buttons */}
              <div className="mt-6 pt-4 border-t border-slate-100">
                {app.status === "pending" && (
                  <div className="space-y-2">
                    <input
                      type="text"
                      placeholder="Optional feedback / rejection reason..."
                      className="input-field text-xs py-1.5 bg-slate-50"
                      value={rejectReason[app.id] || ""}
                      onChange={(e) => setRejectReason({ ...rejectReason, [app.id]: e.target.value })}
                    />
                    <div className="flex items-center gap-3">
                      <button
                        onClick={() => handleApprove(app)}
                        disabled={processingId === app.id}
                        className="btn-primary flex-1 py-2 text-xs justify-center shadow-sm disabled:opacity-50"
                      >
                        ✓ Approve Application
                      </button>
                      <button
                        onClick={() => handleReject(app)}
                        disabled={processingId === app.id}
                        className="btn-danger flex-1 py-2 text-xs justify-center disabled:opacity-50"
                      >
                        ✕ Reject
                      </button>
                    </div>
                  </div>
                )}

                {app.status === "approved" && (
                  <div className="flex items-center justify-between">
                    <span className="text-xs text-emerald-600 font-semibold flex items-center gap-1.5">
                      <span className="w-2 h-2 rounded-full bg-emerald-500" />
                      Approved & Active on Mobile App
                    </span>
                    <button
                      onClick={() => handleRevoke(app)}
                      disabled={processingId === app.id}
                      className="text-xs font-semibold text-rose-600 hover:underline"
                    >
                      Revoke Status
                    </button>
                  </div>
                )}

                {app.status === "rejected" && (
                  <button
                    onClick={() => handleApprove(app)}
                    disabled={processingId === app.id}
                    className="btn-secondary w-full py-1.5 text-xs text-indigo-600 font-semibold"
                  >
                    Re-evaluate & Approve
                  </button>
                )}
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Manual Grant Creator Card */}
      <div className="card-clean bg-white border border-slate-200 p-6 rounded-2xl shadow-sm">
        <h3 className="font-heading font-bold text-base text-slate-900 mb-1">
          Direct Creator Role Grant
        </h3>
        <p className="text-xs text-slate-500 mb-4">
          Directly promote any user to Creator status by their Firebase User ID.
        </p>

        <form onSubmit={handleManualGrant} className="grid grid-cols-1 sm:grid-cols-3 gap-3">
          <input
            type="text"
            placeholder="User UID (from Firebase Auth / Firestore)"
            value={manualUserId}
            onChange={(e) => setManualUserId(e.target.value)}
            className="input-field text-xs py-2"
            required
          />
          <input
            type="email"
            placeholder="Artist Email (optional)"
            value={manualEmail}
            onChange={(e) => setManualEmail(e.target.value)}
            className="input-field text-xs py-2"
          />
          <button type="submit" className="btn-primary text-xs py-2 justify-center shadow-sm">
            Grant Creator Role
          </button>
        </form>
      </div>
    </div>
  );
}

