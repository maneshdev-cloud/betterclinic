import type { Metadata } from "next";
import { cookies } from "next/headers";
import { Toaster } from "@/components/ui/sonner";
import { BfcacheHandler } from "@/components/shared/bfcache-handler";
import "./globals.css";

export const metadata: Metadata = {
  title: {
    default: "Better Clinic — Smart Digital Healthcare",
    template: "%s · Better Clinic",
  },
  description:
    "Find doctors, book appointments, join live queues and manage your health records — one connected clinic platform.",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  const cookieStore = cookies();
  const theme = cookieStore.get("bc_theme")?.value ?? "system";
  const initialClass = theme === "dark" ? "dark" : "";

  return (
    <html lang="en" className={initialClass} suppressHydrationWarning>
      <head>
        <script
          dangerouslySetInnerHTML={{
            __html: `
              try {
                const cookie = document.cookie.split('; ').find(r => r.startsWith('bc_theme='));
                const theme = cookie ? cookie.split('=')[1] : 'system';
                const isDark = theme === 'dark' || (theme === 'system' && window.matchMedia('(prefers-color-scheme: dark)').matches);
                if (isDark) document.documentElement.classList.add('dark');
                else document.documentElement.classList.remove('dark');
              } catch (_) {}
            `,
          }}
        />
      </head>
      <body className="min-h-screen">
        <BfcacheHandler />
        {children}
        <Toaster />
      </body>
    </html>
  );
}
