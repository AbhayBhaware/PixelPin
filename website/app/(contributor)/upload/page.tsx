"use client";

import { useState } from "react";
import { useDropzone } from "react-dropzone";
import { uploadToCloudinary } from "@/lib/cloudinary";
import { db, auth } from "@/lib/firebase/client";
import { collection, addDoc, serverTimestamp } from "firebase/firestore";
import toast from "react-hot-toast";

const CATEGORIES = [
  "Nature", "Abstract", "Minimal", "Dark", "Anime",
  "Space", "City", "Gradient", "Architecture", "Animals",
];

interface UploadForm {
  title: string;
  description: string;
  category: string;
  tags: string;
}

export default function UploadPage() {
  const [form, setForm] = useState<UploadForm>({
    title: "", description: "", category: "", tags: "",
  });
  const [file, setFile] = useState<File | null>(null);
  const [preview, setPreview] = useState<string | null>(null);
  const [progress, setProgress] = useState(0);
  const [submitting, setSubmitting] = useState(false);

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    accept: { "image/jpeg": [], "image/png": [], "image/webp": [] },
    maxSize: 30 * 1024 * 1024, // 30 MB
    maxFiles: 1,
    onDrop: (accepted, rejected) => {
      if (rejected.length > 0) {
        toast.error("Invalid file. Use JPG/PNG/WebP under 30MB.");
        return;
      }
      const f = accepted[0];
      setFile(f);
      setPreview(URL.createObjectURL(f));
    },
  });

  const handleChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>
  ) => setForm((prev) => ({ ...prev, [e.target.name]: e.target.value }));

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!file) { toast.error("Please select an image"); return; }
    if (!form.title || !form.category) {
      toast.error("Title and category are required"); return;
    }

    const user = auth.currentUser;
    if (!user) { toast.error("Not signed in"); return; }

    setSubmitting(true);
    try {
      // 1. Upload to Cloudinary
      const { publicId, url, width, height, bytes } = await uploadToCloudinary(
        file, "wallpapers", setProgress
      );

      // 2. Create Firestore doc
      await addDoc(collection(db, "wallpapers"), {
        title: form.title.trim(),
        description: form.description.trim(),
        category: form.category,
        tags: form.tags.split(",").map((t) => t.trim().toLowerCase()).filter(Boolean),
        contributorId: user.uid,
        contributorName: user.displayName || "Unknown",
        cloudinaryPublicId: publicId,
        imageUrl: url,
        thumbUrl: url, // Cloudinary URL transforms handle thumb
        width, height,
        size: bytes,
        status: "pending",
        stats: { views: 0, downloads: 0, shares: 0, favorites: 0 },
        createdAt: serverTimestamp(),
      });

      toast.success("Wallpaper submitted for review! 🎉");
      setForm({ title: "", description: "", category: "", tags: "" });
      setFile(null);
      setPreview(null);
      setProgress(0);
    } catch (err) {
      console.error(err);
      toast.error("Upload failed. Please try again.");
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <main className="min-h-screen p-6 max-w-4xl mx-auto">
      <div className="mb-8">
        <h1 className="text-3xl font-bold">Upload Wallpaper</h1>
        <p className="text-[#9A95B8] mt-2">
          Submit your wallpaper for review. Approved wallpapers go live in the app.
        </p>
      </div>

      <form onSubmit={handleSubmit} className="grid md:grid-cols-2 gap-8">
        {/* Left: Dropzone */}
        <div>
          <div
            {...getRootProps()}
            className={`relative rounded-2xl border-2 border-dashed cursor-pointer transition-all overflow-hidden ${
              isDragActive
                ? "border-[#7C4DFF] bg-[rgba(124,77,255,0.08)]"
                : "border-[#22223A] hover:border-[#7C4DFF] hover:bg-[rgba(124,77,255,0.04)]"
            }`}
            style={{ aspectRatio: "9/16", minHeight: "400px" }}
          >
            <input {...getInputProps()} />
            {preview ? (
              <>
                <img
                  src={preview}
                  alt="Preview"
                  className="absolute inset-0 w-full h-full object-cover"
                />
                <div className="absolute inset-0 bg-black/40 flex items-center justify-center opacity-0 hover:opacity-100 transition-opacity">
                  <span className="text-white text-sm font-medium">Change image</span>
                </div>
              </>
            ) : (
              <div className="absolute inset-0 flex flex-col items-center justify-center gap-4 p-6 text-center">
                <div className="w-16 h-16 rounded-2xl flex items-center justify-center"
                  style={{ background: "rgba(124,77,255,0.15)" }}>
                  <svg className="w-8 h-8 text-[#7C4DFF]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5}
                      d="M3 16.5v2.25A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75V16.5m-13.5-9L12 3m0 0l4.5 4.5M12 3v13.5" />
                  </svg>
                </div>
                <div>
                  <p className="font-semibold text-[#F0EEFF]">
                    {isDragActive ? "Drop it here!" : "Drag & drop your wallpaper"}
                  </p>
                  <p className="text-[#5C5878] text-sm mt-1">JPG, PNG, WebP · Max 30MB</p>
                  <p className="text-[#5C5878] text-xs mt-1">Min 1080×1920px recommended</p>
                </div>
              </div>
            )}
          </div>

          {/* Progress bar */}
          {submitting && progress > 0 && (
            <div className="mt-3">
              <div className="flex justify-between text-xs text-[#9A95B8] mb-1">
                <span>Uploading...</span>
                <span>{progress}%</span>
              </div>
              <div className="h-1.5 bg-[#22223A] rounded-full overflow-hidden">
                <div
                  className="h-full rounded-full transition-all"
                  style={{
                    width: `${progress}%`,
                    background: "linear-gradient(90deg, #7C4DFF, #FF6D6D)",
                  }}
                />
              </div>
            </div>
          )}
        </div>

        {/* Right: Form fields */}
        <div className="flex flex-col gap-5">
          <div>
            <label className="block text-sm font-medium text-[#9A95B8] mb-1.5">
              Title <span className="text-[#FF5252]">*</span>
            </label>
            <input
              name="title"
              value={form.title}
              onChange={handleChange}
              placeholder="e.g. Purple Aurora Night"
              className="input-field"
              maxLength={80}
              required
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-[#9A95B8] mb-1.5">
              Description
            </label>
            <textarea
              name="description"
              value={form.description}
              onChange={handleChange}
              placeholder="Tell viewers about this wallpaper..."
              className="input-field resize-none"
              rows={3}
              maxLength={500}
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-[#9A95B8] mb-1.5">
              Category <span className="text-[#FF5252]">*</span>
            </label>
            <select
              name="category"
              value={form.category}
              onChange={handleChange}
              className="input-field"
              required
            >
              <option value="">Select a category</option>
              {CATEGORIES.map((c) => (
                <option key={c} value={c}>{c}</option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-[#9A95B8] mb-1.5">
              Tags
            </label>
            <input
              name="tags"
              value={form.tags}
              onChange={handleChange}
              placeholder="dark, minimal, purple (comma separated)"
              className="input-field"
            />
            <p className="text-xs text-[#5C5878] mt-1">
              Helps viewers find your wallpaper
            </p>
          </div>

          {/* Guidelines */}
          <div className="rounded-xl p-4 text-sm"
            style={{ background: "#1A1A26", border: "1px solid #22223A" }}>
            <p className="font-semibold text-[#9A95B8] mb-2">📋 Guidelines</p>
            <ul className="space-y-1 text-[#5C5878] text-xs list-disc list-inside">
              <li>Must be your original work or licensed content</li>
              <li>No watermarks or logos</li>
              <li>Min resolution: 1080×1920px</li>
              <li>No adult or offensive content</li>
              <li>Review takes 24–48 hours</li>
            </ul>
          </div>

          <button
            type="submit"
            disabled={submitting || !file}
            className="btn-primary justify-center w-full py-3 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {submitting ? (
              <span className="flex items-center gap-2">
                <svg className="w-4 h-4 animate-spin" fill="none" viewBox="0 0 24 24">
                  <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                  <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                </svg>
                {progress < 100 ? `Uploading ${progress}%` : "Saving..."}
              </span>
            ) : (
              "Submit for Review"
            )}
          </button>
        </div>
      </form>
    </main>
  );
}
