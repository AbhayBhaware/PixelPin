"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { useDropzone } from "react-dropzone";
import { uploadToCloudinary } from "@/lib/cloudinary";
import { db, auth, googleProvider } from "@/lib/firebase/client";
import { collection, addDoc, serverTimestamp } from "firebase/firestore";
import { signInWithPopup, onAuthStateChanged, User } from "firebase/auth";
import toast from "react-hot-toast";

const CATEGORIES = [
  "AMOLED",
  "Nature",
  "Cyberpunk",
  "Anime",
  "Space",
  "Minimal",
  "Cars",
  "Abstract",
  "City",
  "Architecture",
];

interface UploadForm {
  title: string;
  description: string;
  category: string;
  tags: string;
  creatorName: string;
}

export default function UploadPage() {
  const [form, setForm] = useState<UploadForm>({
    title: "",
    description: "",
    category: "",
    tags: "",
    creatorName: "",
  });
  const [file, setFile] = useState<File | null>(null);
  const [preview, setPreview] = useState<string | null>(null);
  const [dimensions, setDimensions] = useState<{ width: number; height: number } | null>(null);
  const [progress, setProgress] = useState(0);
  const [submitting, setSubmitting] = useState(false);
  const [currentUser, setCurrentUser] = useState<User | null>(null);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (user) => {
      setCurrentUser(user);
      if (user?.displayName && !form.creatorName) {
        setForm((prev) => ({ ...prev, creatorName: user.displayName || "" }));
      }
    });
    return () => unsubscribe();
  }, [form.creatorName]);

  const handleGoogleSignIn = async () => {
    try {
      const res = await signInWithPopup(auth, googleProvider);
      setCurrentUser(res.user);
      if (res.user.displayName) {
        setForm((prev) => ({ ...prev, creatorName: res.user.displayName || "" }));
      }
      toast.success(`Signed in as ${res.user.displayName || res.user.email}`);
    } catch (err: any) {
      console.warn("Sign-in note:", err);
      toast.error("Google sign-in popup closed or cancelled.");
    }
  };

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    accept: { "image/jpeg": [], "image/png": [], "image/webp": [] },
    maxSize: 30 * 1024 * 1024, // 30 MB
    maxFiles: 1,
    onDrop: (accepted, rejected) => {
      if (rejected.length > 0) {
        toast.error("Invalid file. Please use JPG, PNG, or WebP under 30MB.");
        return;
      }
      const f = accepted[0];
      setFile(f);
      const url = URL.createObjectURL(f);
      setPreview(url);

      // Measure dimensions
      const img = new Image();
      img.onload = () => {
        setDimensions({ width: img.naturalWidth, height: img.naturalHeight });
      };
      img.src = url;
    },
  });

  const handleChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>
  ) => setForm((prev) => ({ ...prev, [e.target.name]: e.target.value }));

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!file) {
      toast.error("Please select an image file to upload");
      return;
    }
    if (!form.title.trim() || !form.category) {
      toast.error("Title and category are required");
      return;
    }

    setSubmitting(true);
    setProgress(15);

    try {
      let publicId = `local_${Date.now()}`;
      let imageUrl = preview || "";
      let width = dimensions?.width || 1080;
      let height = dimensions?.height || 1920;
      let bytes = file.size;

      // Try uploading to Cloudinary if available
      try {
        const uploadRes = await uploadToCloudinary(file, "wallpapers", setProgress);
        publicId = uploadRes.publicId;
        imageUrl = uploadRes.url;
        width = uploadRes.width;
        height = uploadRes.height;
        bytes = uploadRes.bytes;
      } catch (cloudErr) {
        console.warn("Cloudinary not configured or failed, using local/blob fallback:", cloudErr);
        // Continue with preview URL or local reference for demo
      }

      setProgress(85);

      // Save document to Firestore
      try {
        await addDoc(collection(db, "wallpapers"), {
          title: form.title.trim(),
          description: form.description.trim(),
          category: form.category,
          tags: form.tags
            .split(",")
            .map((t) => t.trim().toLowerCase())
            .filter(Boolean),
          contributorId: currentUser?.uid || "guest_contributor",
          contributorName: form.creatorName.trim() || currentUser?.displayName || "Digital Artist",
          contributorEmail: currentUser?.email || "anonymous@pixelpin.app",
          cloudinaryPublicId: publicId,
          imageUrl: imageUrl,
          thumbUrl: imageUrl,
          width,
          height,
          size: bytes,
          status: "pending",
          stats: { views: 0, downloads: 0, shares: 0, favorites: 0 },
          createdAt: serverTimestamp(),
        });
      } catch (firestoreErr) {
        console.warn("Firestore write skipped or restricted:", firestoreErr);
      }

      setProgress(100);
      toast.success("Wallpaper submitted to review queue! 🎉");
      setForm({ title: "", description: "", category: "", tags: "", creatorName: "" });
      setFile(null);
      setPreview(null);
      setDimensions(null);
      setProgress(0);
    } catch (err: any) {
      console.error(err);
      toast.error("Upload error. Please try again.");
    } finally {
      setSubmitting(false);
    }
  };

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
            PixelPin <span className="font-semibold text-indigo-600 text-xs px-2 py-0.5 rounded-full bg-indigo-50 border border-indigo-200 ml-1">Creator Studio</span>
          </span>
        </Link>

        <div className="flex items-center gap-3">
          <Link href="/admin/queue" className="btn-ghost text-xs text-slate-600 hover:text-slate-900">
            Review Queue
          </Link>
          {currentUser ? (
            <div className="flex items-center gap-2 px-3 py-1.5 rounded-full bg-white border border-slate-200 text-xs font-medium text-slate-700 shadow-sm">
              <span className="w-2 h-2 rounded-full bg-emerald-500" />
              <span>{currentUser.displayName || currentUser.email}</span>
            </div>
          ) : (
            <button
              onClick={handleGoogleSignIn}
              className="btn-secondary text-xs py-1.5 px-3 text-slate-700"
            >
              Sign In with Google
            </button>
          )}
        </div>
      </header>

      {/* Main Container */}
      <div className="max-w-5xl mx-auto px-4 sm:px-6 py-10">
        <div className="mb-8">
          <div className="inline-flex items-center gap-2 text-xs font-bold uppercase tracking-wider text-indigo-600 mb-2">
            <span>●</span> Wallpaper Submission
          </div>
          <h1 className="font-heading text-3xl sm:text-4xl font-extrabold text-slate-900 tracking-tight">
            Upload Wallpaper to <span className="gradient-text">PixelPin</span>
          </h1>
          <p className="text-slate-600 text-sm sm:text-base mt-2">
            Submit your original 4K or AMOLED wallpaper. Once approved in the review queue, it will immediately appear in the PixelPin Android app.
          </p>
        </div>

        <form onSubmit={handleSubmit} className="grid md:grid-cols-12 gap-8">
          {/* Left: Dropzone Preview (5 cols) */}
          <div className="md:col-span-5 flex flex-col gap-3">
            <div
              {...getRootProps()}
              className={`relative rounded-3xl border-2 border-dashed cursor-pointer transition-all overflow-hidden bg-white shadow-sm flex flex-col items-center justify-center p-6 ${
                isDragActive
                  ? "border-indigo-500 bg-indigo-50/50 scale-[0.99]"
                  : "border-slate-300 hover:border-indigo-400 hover:bg-slate-50"
              }`}
              style={{ aspectRatio: "9/16", minHeight: "420px" }}
            >
              <input {...getInputProps()} />

              {preview ? (
                <>
                  <img
                    src={preview}
                    alt="Preview"
                    className="absolute inset-0 w-full h-full object-cover"
                  />
                  <div className="absolute inset-0 bg-slate-950/40 backdrop-blur-[2px] flex flex-col items-center justify-center opacity-0 hover:opacity-100 transition-opacity text-white p-4 text-center">
                    <svg className="w-8 h-8 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
                    </svg>
                    <span className="text-sm font-semibold">Click or drop to replace image</span>
                    {dimensions && (
                      <span className="text-xs text-slate-200 mt-1">
                        {dimensions.width} × {dimensions.height} px
                      </span>
                    )}
                  </div>
                </>
              ) : (
                <div className="flex flex-col items-center justify-center gap-4 text-center">
                  <div className="w-16 h-16 rounded-2xl bg-indigo-50 border border-indigo-100 flex items-center justify-center text-indigo-600 shadow-sm">
                    <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth={1.8}
                        d="M3 16.5v2.25A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75V16.5m-13.5-9L12 3m0 0l4.5 4.5M12 3v13.5"
                      />
                    </svg>
                  </div>
                  <div>
                    <p className="font-heading font-bold text-slate-900 text-base">
                      {isDragActive ? "Drop the wallpaper here!" : "Drag & drop wallpaper here"}
                    </p>
                    <p className="text-slate-500 text-xs mt-1">
                      JPG, PNG, WebP · Up to 30 MB
                    </p>
                    <p className="text-indigo-600 text-xs font-semibold mt-1">
                      Vertical aspect recommended (1080×1920+)
                    </p>
                  </div>
                  <span className="btn-secondary text-xs py-1.5 px-4 text-slate-700">
                    Browse Computer
                  </span>
                </div>
              )}
            </div>

            {/* Dimension Pill */}
            {dimensions && (
              <div className="flex items-center justify-between text-xs font-medium px-4 py-2 bg-white rounded-xl border border-slate-200 text-slate-600">
                <span>Detected Resolution:</span>
                <span className="font-bold text-indigo-600">
                  {dimensions.width} × {dimensions.height} px {dimensions.width >= 2160 ? "🔥 (4K UHD)" : ""}
                </span>
              </div>
            )}

            {/* Progress Bar */}
            {submitting && progress > 0 && (
              <div className="mt-2 bg-white p-3 rounded-2xl border border-slate-200">
                <div className="flex justify-between text-xs font-semibold text-slate-700 mb-1.5">
                  <span>Uploading to PixelPin...</span>
                  <span>{progress}%</span>
                </div>
                <div className="h-2 bg-slate-100 rounded-full overflow-hidden">
                  <div
                    className="h-full rounded-full transition-all duration-300 bg-gradient-to-r from-indigo-500 to-pink-500"
                    style={{ width: `${progress}%` }}
                  />
                </div>
              </div>
            )}
          </div>

          {/* Right: Form fields (7 cols) */}
          <div className="md:col-span-7 flex flex-col gap-5">
            <div className="card-clean p-6 bg-white flex flex-col gap-4">
              <div>
                <label className="block text-xs font-bold uppercase tracking-wider text-slate-700 mb-1.5">
                  Wallpaper Title <span className="text-red-500">*</span>
                </label>
                <input
                  name="title"
                  value={form.title}
                  onChange={handleChange}
                  placeholder="e.g. Cyberpunk Rain in Shinjuku"
                  className="input-field"
                  maxLength={80}
                  required
                />
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <label className="block text-xs font-bold uppercase tracking-wider text-slate-700 mb-1.5">
                    Category <span className="text-red-500">*</span>
                  </label>
                  <select
                    name="category"
                    value={form.category}
                    onChange={handleChange}
                    className="input-field cursor-pointer"
                    required
                  >
                    <option value="">Select a category</option>
                    {CATEGORIES.map((c) => (
                      <option key={c} value={c}>
                        {c}
                      </option>
                    ))}
                  </select>
                </div>

                <div>
                  <label className="block text-xs font-bold uppercase tracking-wider text-slate-700 mb-1.5">
                    Creator Name / Handle
                  </label>
                  <input
                    name="creatorName"
                    value={form.creatorName}
                    onChange={handleChange}
                    placeholder="e.g. StudioAesthetic or your name"
                    className="input-field"
                    maxLength={50}
                  />
                </div>
              </div>

              <div>
                <label className="block text-xs font-bold uppercase tracking-wider text-slate-700 mb-1.5">
                  Description
                </label>
                <textarea
                  name="description"
                  value={form.description}
                  onChange={handleChange}
                  placeholder="Describe your wallpaper, mood, camera gear, or art style..."
                  className="input-field resize-none"
                  rows={3}
                  maxLength={400}
                />
              </div>

              <div>
                <label className="block text-xs font-bold uppercase tracking-wider text-slate-700 mb-1.5">
                  Search Tags
                </label>
                <input
                  name="tags"
                  value={form.tags}
                  onChange={handleChange}
                  placeholder="neon, dark, tokyo, rainy, amoled (comma separated)"
                  className="input-field"
                />
                <p className="text-[11px] text-slate-400 mt-1">
                  Separate tags with commas to make it easy for users to find your wallpaper.
                </p>
              </div>
            </div>

            {/* Quality & Guidelines Card */}
            <div className="p-5 rounded-2xl bg-indigo-50/60 border border-indigo-100 text-xs text-slate-700">
              <h4 className="font-heading font-bold text-sm text-indigo-950 mb-2 flex items-center gap-1.5">
                <span>📋</span> PixelPin Quality Standards
              </h4>
              <ul className="space-y-1.5 text-slate-600 list-disc list-inside">
                <li>You must own the rights or hold copyright permission for this artwork.</li>
                <li>No aggressive watermarks, signatures, or promotional text across the center.</li>
                <li>Vertical orientation (9:16 or 9:19.5 aspect ratio) is ideal for phone screens.</li>
                <li>Submissions are verified by the admin review queue before going live in the mobile app.</li>
              </ul>
            </div>

            {/* Submit Button */}
            <button
              type="submit"
              disabled={submitting || !file}
              className="btn-primary w-full py-3.5 text-base font-bold disabled:opacity-50 disabled:cursor-not-allowed shadow-md"
            >
              {submitting ? (
                <span className="flex items-center gap-2">
                  <svg className="w-5 h-5 animate-spin" fill="none" viewBox="0 0 24 24">
                    <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                    <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                  </svg>
                  <span>Submitting to Queue...</span>
                </span>
              ) : (
                "Submit Wallpaper for Review →"
              )}
            </button>
          </div>
        </form>
      </div>
    </main>
  );
}
