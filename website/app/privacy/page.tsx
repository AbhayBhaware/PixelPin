import Link from "next/link";
import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Privacy Policy | PixelPin",
  description: "PixelPin Privacy Policy — How we handle data, permissions, and user privacy.",
};

export default function PrivacyPolicyPage() {
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
            Legal & Compliance
          </span>
          <h1 className="font-heading text-3xl sm:text-4xl font-extrabold text-slate-900 mb-2">
            Privacy Policy
          </h1>
          <p className="text-xs text-slate-400 mb-8">
            Last Updated: October 2026 · Effective Date: October 2026
          </p>

          <div className="space-y-6 text-sm text-slate-600 leading-relaxed">
            <section>
              <h2 className="font-heading font-bold text-lg text-slate-900 mb-2">
                1. Overview & Commitment
              </h2>
              <p>
                PixelPin (&quot;we&quot;, &quot;our&quot;, or &quot;us&quot;) is committed to protecting your privacy. This Privacy Policy explains our practices regarding the collection, use, and disclosure of information through our website and the PixelPin Android application.
              </p>
            </section>

            <section>
              <h2 className="font-heading font-bold text-lg text-slate-900 mb-2">
                2. Information We Collect
              </h2>
              <ul className="list-disc list-inside space-y-1.5 ml-1">
                <li>
                  <strong className="text-slate-800">No Account Required to Browse:</strong> You can explore and download wallpapers without registering an account.
                </li>
                <li>
                  <strong className="text-slate-800">Creator Account Information:</strong> If you choose to authenticate via Google Sign-In as a creator, we receive your name, email address, and profile picture to identify your submissions.
                </li>
                <li>
                  <strong className="text-slate-800">App Usage & Diagnostics:</strong> Non-personally identifiable diagnostic information (such as crash reports and device model) may be collected via Firebase Crashlytics to improve app reliability.
                </li>
              </ul>
            </section>

            <section>
              <h2 className="font-heading font-bold text-lg text-slate-900 mb-2">
                3. Device Permissions (Android App)
              </h2>
              <p className="mb-2">
                The PixelPin Android application requests only the minimum permissions necessary to function:
              </p>
              <ul className="list-disc list-inside space-y-1.5 ml-1">
                <li>
                  <strong className="text-slate-800">SET_WALLPAPER:</strong> Allows the app to apply your chosen wallpaper directly to your home screen or lock screen.
                </li>
                <li>
                  <strong className="text-slate-800">INTERNET & ACCESS_NETWORK_STATE:</strong> Enables fetching 4K wallpapers from our cloud servers and third-party APIs (Pixabay API).
                </li>
                <li>
                  <strong className="text-slate-800">STORAGE / MEDIA (Downloads):</strong> Required only if you tap &quot;Download to Gallery&quot; to save the wallpaper file locally on your device.
                </li>
              </ul>
            </section>

            <section>
              <h2 className="font-heading font-bold text-lg text-slate-900 mb-2">
                4. Third-Party Services
              </h2>
              <p className="mb-2">We utilize the following reputable third-party services:</p>
              <ul className="list-disc list-inside space-y-1.5 ml-1">
                <li><strong className="text-slate-800">Google Firebase:</strong> Authentication, Firestore database, and app analytics.</li>
                <li><strong className="text-slate-800">Pixabay API:</strong> High-resolution curated imagery under the Pixabay API license terms.</li>
                <li><strong className="text-slate-800">Cloudinary:</strong> Image transformation and content delivery network.</li>
              </ul>
            </section>

            <section>
              <h2 className="font-heading font-bold text-lg text-slate-900 mb-2">
                5. Data Retention & Deletion
              </h2>
              <p>
                We do not sell, rent, or trade your personal data. Creators who wish to remove their uploaded wallpapers or delete their contributor accounts can submit a request at any time to our support team.
              </p>
            </section>

            <section>
              <h2 className="font-heading font-bold text-lg text-slate-900 mb-2">
                6. Contact Us
              </h2>
              <p>
                For any privacy inquiries, questions, or data removal requests, please contact us at: <br />
                <a href="mailto:support@pixelpin.app" className="text-indigo-600 font-semibold hover:underline">
                  support@pixelpin.app
                </a>
              </p>
            </section>
          </div>
        </div>
      </div>

      {/* Footer */}
      <footer className="border-t border-slate-200 py-10 px-4 text-center text-xs text-slate-500 bg-white">
        <p>© 2026 PixelPin. All rights reserved.</p>
      </footer>
    </main>
  );
}
