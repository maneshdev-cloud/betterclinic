"use client";

import { createContext, useContext, useEffect, useState, useTransition, useCallback, useRef } from "react";
import { usePathname, useSearchParams } from "next/navigation";

interface NavigationContextType {
  pendingHref: string | null;
  setPendingHref: (href: string | null) => void;
  isNavigating: boolean;
  startNavigation: (href?: string) => void;
  stopNavigation: () => void;
}

const NavigationContext = createContext<NavigationContextType>({
  pendingHref: null,
  setPendingHref: () => {},
  isNavigating: false,
  startNavigation: () => {},
  stopNavigation: () => {},
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

  const t1Ref = useRef<NodeJS.Timeout | null>(null);
  const t2Ref = useRef<NodeJS.Timeout | null>(null);
  const safetyTimerRef = useRef<NodeJS.Timeout | null>(null);

  const clearTimers = useCallback(() => {
    if (t1Ref.current) clearTimeout(t1Ref.current);
    if (t2Ref.current) clearTimeout(t2Ref.current);
    if (safetyTimerRef.current) clearTimeout(safetyTimerRef.current);
  }, []);

  const startNavigation = useCallback(
    (href?: string) => {
      clearTimers();
      if (href) setPendingHref(href);
      setVisible(true);
      setProgress(30);

      t1Ref.current = setTimeout(() => setProgress(65), 120);
      t2Ref.current = setTimeout(() => setProgress(85), 350);

      // Safety timeout: prevent perpetual loading if navigation aborts
      safetyTimerRef.current = setTimeout(() => {
        setVisible(false);
        setProgress(0);
        setPendingHref(null);
      }, 10000);
    },
    [clearTimers]
  );

  const stopNavigation = useCallback(() => {
    clearTimers();
    setProgress(100);
    setTimeout(() => {
      setVisible(false);
      setProgress(0);
      setPendingHref(null);
    }, 200);
  }, [clearTimers]);

  // Clear pending state when the route actually changes
  useEffect(() => {
    if (visible || pendingHref) {
      clearTimers();
      setProgress(100);
      const timer = setTimeout(() => {
        setVisible(false);
        setProgress(0);
        setPendingHref(null);
      }, 250);
      return () => clearTimeout(timer);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [pathname, searchParams, clearTimers]);

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

      startNavigation(href);
    }

    document.addEventListener("click", handleClick, { capture: true });
    return () => {
      document.removeEventListener("click", handleClick, { capture: true });
      clearTimers();
    };
  }, [startNavigation, clearTimers]);

  return (
    <NavigationContext.Provider
      value={{
        pendingHref,
        setPendingHref,
        isNavigating: visible,
        startNavigation,
        stopNavigation,
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
            className="h-full bg-gradient-to-r from-primary via-teal-400 to-primary transition-all duration-200 ease-out shadow-[0_0_12px_rgba(20,184,166,0.65)]"
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
