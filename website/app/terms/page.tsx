import Link from "next/link";
import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Terms of Service | PixelPin",
  description: "PixelPin Terms of Service — Rules and conditions for users and creators.",
};

export default function TermsPage() {
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
        <Link href="/" className="btn-secondary text-xs py-1.5 px-3 text-slate-700">
          Back to Home
        </Link>
      </header>

      <div className="max-w-3xl mx-auto px-4 sm:px-6 py-12">
        <div className="card-clean bg-white p-8 sm:p-12 border border-slate-200">
          <span className="text-xs font-bold uppercase tracking-wider text-indigo-600 mb-2 block">
            Terms & Conditions
          </span>
          <h1 className="font-heading text-3xl sm:text-4xl font-extrabold text-slate-900 mb-2">
            Terms of Service
          </h1>
          <p className="text-xs text-slate-400 mb-8">
            Last Updated: October 2026
          </p>

          <div className="space-y-6 text-sm text-slate-600 leading-relaxed">
            <section>
              <h2 className="font-heading font-bold text-lg text-slate-900 mb-2">
                1. Acceptance of Terms
              </h2>
              <p>
                By using the PixelPin website or mobile application, you agree to be bound by these Terms of Service. If you do not agree, please do not use our services.
              </p>
            </section>

            <section>
              <h2 className="font-heading font-bold text-lg text-slate-900 mb-2">
                2. License to Use Wallpapers
              </h2>
              <p>
                Wallpapers downloaded from PixelPin are provided for personal, non-commercial use as home screen or lock screen backgrounds on personal mobile devices. You may not sell, redistribute, or license wallpaper files as standalone digital assets.
              </p>
            </section>

            <section>
              <h2 className="font-heading font-bold text-lg text-slate-900 mb-2">
                3. Creator Submissions & Copyright
              </h2>
              <p>
                When submitting artwork to PixelPin, you affirm that you own or have obtained all necessary intellectual property rights. By uploading, you grant PixelPin a non-exclusive license to display, host, and distribute the wallpaper to users via the app and web showcase.
              </p>
            </section>

            <section>
              <h2 className="font-heading font-bold text-lg text-slate-900 mb-2">
                4. Content Moderation
              </h2>
              <p>
                PixelPin reserves the right to review, reject, or remove any wallpaper submission at its sole discretion if it violates quality guidelines, infringes copyright, or contains harmful content.
              </p>
            </section>

            <section>
              <h2 className="font-heading font-bold text-lg text-slate-900 mb-2">
                5. Disclaimer & Limitation of Liability
              </h2>
              <p>
                Our services are provided on an &quot;AS IS&quot; and &quot;AS AVAILABLE&quot; basis without warranties of any kind. PixelPin shall not be liable for any indirect, incidental, or consequential damages resulting from the use of the platform.
              </p>
            </section>

            <section>
              <h2 className="font-heading font-bold text-lg text-slate-900 mb-2">
                6. Contact
              </h2>
              <p>
                For questions regarding these Terms, contact us at <a href="mailto:legal@pixelpin.app" className="text-indigo-600 font-semibold hover:underline">legal@pixelpin.app</a>.
              </p>
            </section>
          </div>
        </div>
      </div>

      <footer className="border-t border-slate-200 py-10 px-4 text-center text-xs text-slate-500 bg-white">
        <p>© 2026 PixelPin. All rights reserved.</p>
      </footer>
    </main>
  );
}
