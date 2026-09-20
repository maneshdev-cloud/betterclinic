"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";

/**
 * BfcacheHandler:
 *  - Listens for window 'pageshow' events where event.persisted is true.
 *    When a browser restores a page from the back/forward cache (bfcache),
 *    this forces an immediate hard reload from the server, ensuring
 *    middleware runs and re-verifies session state.
 *  - Listens for window 'popstate' events and refreshes the Next.js router
 *    so stale in-memory router cache entries re-validate against the server.
 */
export function BfcacheHandler() {
  const router = useRouter();

  useEffect(() => {
    function onPageShow(event: PageTransitionEvent) {
      if (event.persisted) {
        // The page was restored from bfcache — force a fresh server request
        window.location.reload();
      }
    }

    function onPopState() {
      // Re-verify current route with the server on browser back/forward navigation
      router.refresh();
    }

    window.addEventListener("pageshow", onPageShow);
    window.addEventListener("popstate", onPopState);

    return () => {
      window.removeEventListener("pageshow", onPageShow);
      window.removeEventListener("popstate", onPopState);
    };
  }, [router]);

  return null;
}
