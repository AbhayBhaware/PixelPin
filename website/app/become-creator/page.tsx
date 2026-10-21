"use client";

import Link from "next/link";

const GOOGLE_PLAY_URL = "https://play.google.com/store/apps/details?id=com.pixelpin.pixelpin";

export default function BecomeCreatorPage() {
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
            PixelPin
          </span>
        </Link>

        <nav className="hidden md:flex items-center gap-6 text-sm font-semibold text-slate-600">
          <Link href="/" className="hover:text-indigo-600 transition-colors">
            Home
          </Link>
          <Link href="/explore" className="hover:text-indigo-600 transition-colors">
            Explore
          </Link>
          <Link href="/categories" className="hover:text-indigo-600 transition-colors">
            Categories
          </Link>
          <Link href="/upload" className="hover:text-indigo-600 transition-colors">
            Upload
          </Link>
        </nav>

        <a
          href={GOOGLE_PLAY_URL}
          target="_blank"
          rel="noopener noreferrer"
          className="btn-primary text-xs sm:text-sm py-2 px-4"
        >
          Get on Google Play
        </a>
      </header>

      {/* Main Container */}
      <div className="max-w-4xl mx-auto px-4 sm:px-6 py-14">
        {/* Hero */}
        <div className="text-center max-w-2xl mx-auto mb-14">
          <span className="text-xs font-bold uppercase tracking-wider text-pink-600 mb-2 block">
            ★ Creator Program
          </span>
          <h1 className="font-heading text-4xl sm:text-5xl font-extrabold text-slate-900 mb-5 tracking-tight">
            Share Your Art with <br />
            <span className="gradient-text">Thousands of Mobile Screens</span>
          </h1>
          <p className="text-slate-600 text-base sm:text-lg leading-relaxed">
            Whether you are a digital 3D artist, landscape photographer, or minimalist designer, PixelPin gives your wallpapers the global audience they deserve.
          </p>

          <div className="mt-8 flex flex-col sm:flex-row items-center justify-center gap-4">
            <Link href="/upload" className="btn-primary text-base px-8 py-3.5 shadow-md">
              Upload Wallpaper Now →
            </Link>
            <a
              href={GOOGLE_PLAY_URL}
              target="_blank"
              rel="noopener noreferrer"
              className="btn-secondary text-base px-7 py-3.5 text-slate-700"
            >
              See App on Google Play
            </a>
          </div>
        </div>

        {/* Benefits Grid */}
        <div className="grid md:grid-cols-3 gap-6 mb-16">
          <div className="card-clean p-6 bg-white border border-slate-200">
            <div className="text-3xl mb-3">🌍</div>
            <h3 className="font-heading font-bold text-lg text-slate-900 mb-2">
              Global Exposure
            </h3>
            <p className="text-slate-600 text-sm leading-relaxed">
              Your wallpaper is showcased directly inside the PixelPin Android app to users looking for fresh home and lock screens every day.
            </p>
          </div>

          <div className="card-clean p-6 bg-white border border-slate-200">
            <div className="text-3xl mb-3">⚡</div>
            <h3 className="font-heading font-bold text-lg text-slate-900 mb-2">
              Fast Review Queue
            </h3>
            <p className="text-slate-600 text-sm leading-relaxed">
              Our moderation queue verifies wallpaper quality quickly. Once approved, your artwork goes live in real time via our cloud sync.
            </p>
          </div>

          <div className="card-clean p-6 bg-white border border-slate-200">
            <div className="text-3xl mb-3">🎨</div>
            <h3 className="font-heading font-bold text-lg text-slate-900 mb-2">
              Full Artist Credit
            </h3>
            <p className="text-slate-600 text-sm leading-relaxed">
              Your name and handle are proudly displayed on every wallpaper card and detail sheet, helping you grow your social following.
            </p>
          </div>
        </div>

        {/* Guidelines & Resolution Requirements */}
        <div className="card-clean p-8 bg-white border border-slate-200 mb-14">
          <h2 className="font-heading text-2xl font-bold text-slate-900 mb-4">
            Submission Guidelines & Quality Standards
          </h2>
          <div className="space-y-4 text-sm text-slate-600">
            <div className="flex items-start gap-3">
              <span className="w-6 h-6 rounded-full bg-indigo-50 text-indigo-600 flex items-center justify-center shrink-0 font-bold text-xs mt-0.5">
                1
              </span>
              <div>
                <strong className="text-slate-900">High Resolution Only:</strong> We require at least 1080×1920 pixels, with 4K UHD (2160×3840) strongly preferred for crisp rendering on high-DPI displays.
              </div>
            </div>

            <div className="flex items-start gap-3">
              <span className="w-6 h-6 rounded-full bg-indigo-50 text-indigo-600 flex items-center justify-center shrink-0 font-bold text-xs mt-0.5">
                2
              </span>
              <div>
                <strong className="text-slate-900">Original or Licensed Content:</strong> Only submit wallpapers that you have created or have explicit legal rights to distribute. Stolen or infringed art is immediately purged.
              </div>
            </div>

            <div className="flex items-start gap-3">
              <span className="w-6 h-6 rounded-full bg-indigo-50 text-indigo-600 flex items-center justify-center shrink-0 font-bold text-xs mt-0.5">
                3
              </span>
              <div>
                <strong className="text-slate-900">Clean Aesthetic:</strong> Avoid large intrusive watermarks, brand logos, or text plastered across the middle of the artwork.
              </div>
            </div>

            <div className="flex items-start gap-3">
              <span className="w-6 h-6 rounded-full bg-indigo-50 text-indigo-600 flex items-center justify-center shrink-0 font-bold text-xs mt-0.5">
                4
              </span>
              <div>
                <strong className="text-slate-900">Safe for All Audiences:</strong> PixelPin does not allow explicit, adult, or offensive imagery.
              </div>
            </div>
          </div>
        </div>

        {/* Call to action */}
        <div className="text-center bg-gradient-to-br from-indigo-500 to-purple-600 rounded-3xl p-10 text-white shadow-xl">
          <h3 className="font-heading text-2xl sm:text-3xl font-extrabold mb-3">
            Ready to submit your first wallpaper?
          </h3>
          <p className="text-indigo-100 text-sm sm:text-base max-w-lg mx-auto mb-6">
            Upload takes less than 30 seconds. No complicated registration forms required.
          </p>
          <Link
            href="/upload"
            className="btn-secondary bg-white text-indigo-600 hover:bg-slate-100 border-none font-bold py-3 px-8 text-sm inline-block"
          >
            Go to Upload Studio →
          </Link>
        </div>
      </div>

      {/* Footer */}
      <footer className="border-t border-slate-200 py-10 px-4 text-center text-xs text-slate-500 bg-white">
        <p>© 2026 PixelPin. All rights reserved.</p>
      </footer>
    </main>
  );
}
