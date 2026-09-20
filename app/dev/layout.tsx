import "server-only";
import { notFound } from "next/navigation";
import Link from "next/link";
import { Terminal, Shield, ArrowLeft, ExternalLink } from "lucide-react";
import { createClient } from "@/lib/supabase/server";

export const dynamic = "force-dynamic";

export default async function DevLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const devEmail = process.env.DEVELOPER_EMAIL?.trim().toLowerCase();

  // If DEVELOPER_EMAIL is not set, completely hide route (404)
  if (!devEmail) {
    notFound();
  }

  const supabase = await createClient({ bypassHideDemo: true });
  const {
    data: { user },
  } = await supabase.auth.getUser();

  // If not logged in or email doesn't match allowlist, return standard 404
  if (!user || !user.email || user.email.trim().toLowerCase() !== devEmail) {
    notFound();
  }

  const appEnv = process.env.NEXT_PUBLIC_APP_ENV || "demo";

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100 font-sans selection:bg-cyan-500 selection:text-white">
      {/* Top Console Bar */}
      <header className="border-b border-slate-800/80 bg-slate-900/60 backdrop-blur-md sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <div className="p-2 rounded-lg bg-cyan-500/10 border border-cyan-500/30 text-cyan-400">
              <Terminal className="h-5 w-5" />
            </div>
            <div>
              <div className="flex items-center space-x-2">
                <span className="font-bold text-sm tracking-wider uppercase text-white">
                  Better Clinic
                </span>
                <span className="text-xs px-1.5 py-0.5 rounded bg-cyan-950 text-cyan-400 border border-cyan-800/50 font-mono">
                  DEV_ADMIN
                </span>
              </div>
              <p className="text-xs text-slate-400 font-mono">Platform Infrastructure & Diagnostics</p>
            </div>
          </div>

          <div className="flex items-center space-x-4">
            {/* Environment Badge */}
            <div className="hidden sm:flex items-center space-x-2 text-xs font-mono px-2.5 py-1 rounded-md bg-slate-800 border border-slate-700">
              <span className="text-slate-400">ENV:</span>
              <span
                className={
                  appEnv === "production"
                    ? "text-emerald-400 font-semibold"
                    : "text-amber-400 font-semibold"
                }
              >
                {appEnv.toUpperCase()}
              </span>
            </div>

            {/* Operator Email Badge */}
            <div className="flex items-center space-x-2 text-xs font-mono px-2.5 py-1 rounded-md bg-slate-800/80 border border-slate-700 text-slate-300">
              <Shield className="h-3.5 w-3.5 text-cyan-400" />
              <span className="hidden md:inline">{user.email}</span>
              <span className="md:hidden">Owner</span>
            </div>

            {/* Return to App */}
            <Link
              href="/"
              className="inline-flex items-center space-x-1.5 text-xs font-medium px-3 py-1.5 rounded-lg bg-slate-800 hover:bg-slate-700 text-slate-200 border border-slate-700 transition"
            >
              <ArrowLeft className="h-3.5 w-3.5" />
              <span>Back to App</span>
            </Link>
          </div>
        </div>
      </header>

      {/* Main Content Area */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">{children}</main>
    </div>
  );
}
