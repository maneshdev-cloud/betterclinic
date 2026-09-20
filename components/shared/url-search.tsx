"use client";

import { useRouter } from "next/navigation";
import { useTransition } from "react";
import { SearchInput } from "@/components/shared/search-input";
import { buildQueryString } from "@/lib/search-params";

/**
 * Debounced search input that syncs `q` to the URL (resets to page 1).
 * For use inside server components, which cannot pass callbacks to
 * client components directly. Pass `extraParams` to keep other URL
 * params (e.g. the active tab) alive while searching.
 */
export function UrlSearch({
  basePath,
  value,
  placeholder,
  ariaLabel,
  className,
  extraParams,
}: {
  basePath: string;
  value: string;
  placeholder?: string;
  ariaLabel?: string;
  className?: string;
  extraParams?: Record<string, string | undefined>;
}) {
  const router = useRouter();
  const [isPending, startTransition] = useTransition();

  return (
    <div className={className ?? "w-full sm:max-w-sm"} aria-busy={isPending}>
      <SearchInput
        value={value}
        onChange={(q) =>
          startTransition(() => {
            router.push(
              `${basePath}${buildQueryString({ ...(extraParams ?? {}), q: q || undefined })}`,
              { scroll: false }
            );
          })
        }
        placeholder={placeholder}
        ariaLabel={ariaLabel}
      />
    </div>
  );
}
