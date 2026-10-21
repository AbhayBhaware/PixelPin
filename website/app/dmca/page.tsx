import Link from "next/link";
import { Metadata } from "next";

export const metadata: Metadata = {
  title: "DMCA Copyright Notice | PixelPin",
  description: "PixelPin DMCA Copyright Policy & Takedown Request Procedure.",
};

export default function DmcaPage() {
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
            Intellectual Property
          </span>
          <h1 className="font-heading text-3xl sm:text-4xl font-extrabold text-slate-900 mb-2">
            DMCA & Copyright Policy
          </h1>
          <p className="text-xs text-slate-400 mb-8">
            Digital Millennium Copyright Act Compliance Notice
          </p>

          <div className="space-y-6 text-sm text-slate-600 leading-relaxed">
            <p>
              PixelPin respects the intellectual property rights of artists, creators, and photographers. In accordance with the Digital Millennium Copyright Act (&quot;DMCA&quot;), we respond promptly to notices of alleged copyright infringement.
            </p>

            <section>
              <h2 className="font-heading font-bold text-lg text-slate-900 mb-2">
                Filing a Takedown Request
              </h2>
              <p className="mb-3">
                If you believe your copyrighted work has been uploaded or displayed on PixelPin without proper authorization, please email a notice containing the following information:
              </p>
              <ol className="list-decimal list-inside space-y-2 ml-1">
                <li>Identification of the copyrighted work claimed to have been infringed.</li>
                <li>The specific URL, title, or image identifier of the infringing material on PixelPin.</li>
                <li>Your contact information (name, address, telephone number, and email address).</li>
                <li>A statement that you have a good faith belief that use of the material is not authorized by the copyright owner, its agent, or the law.</li>
                <li>A statement made under penalty of perjury that the information in the notice is accurate and that you are authorized to act on behalf of the owner.</li>
                <li>Your physical or electronic signature.</li>
              </ol>
            </section>

            <section>
              <h2 className="font-heading font-bold text-lg text-slate-900 mb-2">
                Designated Copyright Agent
              </h2>
              <p>
                Send DMCA takedown requests to our designated agent at: <br />
                <a href="mailto:dmca@pixelpin.app" className="text-indigo-600 font-semibold hover:underline">
                  dmca@pixelpin.app
                </a>
              </p>
              <p className="mt-2 text-xs text-slate-500">
                Upon receipt of a valid notice, we act swiftly to investigate and remove the contested content within 24 to 48 hours.
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
