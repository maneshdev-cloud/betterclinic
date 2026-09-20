"use client";

import { useRouter } from "next/navigation";
import { SearchInput } from "@/components/shared/search-input";
import { buildQueryString } from "@/lib/search-params";

/** Staff appointment search — pushes q to the URL (debounced). */
export function StaffSearch({ value, currentTab }: { value: string; currentTab: string }) {
  const router = useRouter();

  return (
    <div className="w-full sm:max-w-sm">
      <SearchInput
        value={value}
        onChange={(q) =>
          router.push(
            `/staff/appointments${buildQueryString({ q: q || undefined, view: currentTab === "today" ? undefined : currentTab })}`,
            { scroll: false }
          )
        }
        placeholder="Search patient name…"
        ariaLabel="Search appointments by patient name"
      />
    </div>
  );
}
