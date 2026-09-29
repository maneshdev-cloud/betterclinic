"use client";

import { createContext, useContext, useEffect, useState, useTransition } from "react";
import { usePathname, useSearchParams } from "next/navigation";

interface NavigationContextType {
  pendingHref: string | null;
  setPendingHref: (href: string | null) => void;
  isNavigating: boolean;
}

const NavigationContext = createContext<NavigationContextType>({
  pendingHref: null,
  setPendingHref: () => {},
  isNavigating: false,
});

export function useNavigationProgress() {
  return useContext(NavigationContext);
}

export function NavigationProvider({ children }: { children: React.ReactNode }) {
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const [pendingHref, setPendingHref] = useState<string | null>(null);
  const [progress, setProgress] = useState(0);
  const [visible, setVisible] = useState(false);

  // Clear pending state when the route actually changes
  useEffect(() => {
    if (visible || pendingHref) {
      setProgress(100);
      const timer = setTimeout(() => {
        setVisible(false);
        setProgress(0);
        setPendingHref(null);
      }, 250);
      return () => clearTimeout(timer);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [pathname, searchParams]);

  // Handle global click interception for any internal <a> tags
  useEffect(() => {
    function handleClick(e: MouseEvent) {
      // Ignore modified clicks or non-primary clicks
      if (e.metaKey || e.ctrlKey || e.shiftKey || e.altKey || e.button !== 0) return;

      const target = (e.target as Element).closest("a");
      if (!target) return;

      const href = target.getAttribute("href");
      if (!href) return;

      // Ignore external, target blank, download, hash, mailto, tel
      if (
        target.target === "_blank" ||
        target.hasAttribute("download") ||
        href.startsWith("http://") ||
        href.startsWith("https://") ||
        href.startsWith("#") ||
        href.startsWith("mailto:") ||
        href.startsWith("tel:")
      ) {
        return;
      }

      // If it's already the current path + search, don't trigger
      const currentFull = window.location.pathname + window.location.search;
      if (href === currentFull) return;

      // Start navigation indicator immediately
      setPendingHref(href);
      setVisible(true);
      setProgress(25);

      const t1 = setTimeout(() => setProgress(65), 120);
      const t2 = setTimeout(() => setProgress(85), 350);

      return () => {
        clearTimeout(t1);
        clearTimeout(t2);
      };
    }

    document.addEventListener("click", handleClick, { capture: true });
    return () => document.removeEventListener("click", handleClick, { capture: true });
  }, []);

  return (
    <NavigationContext.Provider
      value={{
        pendingHref,
        setPendingHref,
        isNavigating: visible,
      }}
    >
      {/* Top glowing progress bar */}
      {visible ? (
        <div
          role="progressbar"
          aria-valuemin={0}
          aria-valuemax={100}
          aria-valuenow={progress}
          aria-label="Page loading"
          className="fixed left-0 top-0 z-[9999] h-[3px] w-full pointer-events-none overflow-hidden bg-transparent"
        >
          <div
            className="h-full bg-gradient-to-r from-primary via-blue-500 to-primary transition-all duration-200 ease-out shadow-[0_0_10px_rgba(59,130,246,0.5)]"
            style={{
              width: `${progress}%`,
              opacity: progress === 100 ? 0 : 1,
              transition: "width 200ms ease-out, opacity 250ms ease-in",
            }}
          />
        </div>
      ) : null}
      {children}
    </NavigationContext.Provider>
  );
}
