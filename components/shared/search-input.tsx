"use client";

import { useEffect, useRef, useState } from "react";
import { Search, X } from "lucide-react";
import { Input } from "@/components/ui/input";
import { cn } from "@/lib/utils";

interface SearchInputProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  className?: string;
  /** Debounce in ms (default 300). */
  debounceMs?: number;
  disabled?: boolean;
  ariaLabel?: string;
}

/**
 * Debounced search input. Typing updates the visible field immediately
 * but only notifies the parent after the user pauses, keeping queries
 * cheap. Clearing via the "X" button or Escape key fires immediately (0ms).
 */
export function SearchInput({
  value,
  onChange,
  placeholder = "Search…",
  className,
  debounceMs = 300,
  disabled,
  ariaLabel,
}: SearchInputProps) {
  const [internal, setInternal] = useState(value);
  const timer = useRef<ReturnType<typeof setTimeout>>();
  const inputRef = useRef<HTMLInputElement>(null);

  // Keep the field in sync when the URL/filters are reset externally.
  useEffect(() => {
    setInternal(value);
  }, [value]);

  useEffect(() => {
    return () => clearTimeout(timer.current);
  }, []);

  const handleChange = (next: string) => {
    setInternal(next);
    clearTimeout(timer.current);
    timer.current = setTimeout(() => onChange(next), debounceMs);
  };

  const handleClear = () => {
    setInternal("");
    clearTimeout(timer.current);
    onChange("");
    inputRef.current?.focus();
  };

  return (
    <div className={cn("relative", className)}>
      <Search className="pointer-events-none absolute left-2.5 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" aria-hidden />
      <Input
        ref={inputRef}
        type="search"
        value={internal}
        onChange={(event) => handleChange(event.target.value)}
        onKeyDown={(event) => {
          if (event.key === "Escape" && internal) {
            handleClear();
            event.preventDefault();
          }
        }}
        placeholder={placeholder}
        disabled={disabled}
        aria-label={ariaLabel ?? placeholder}
        className="pl-8 pr-8"
      />
      {internal ? (
        <button
          type="button"
          onClick={handleClear}
          className="absolute right-2.5 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring rounded-sm p-0.5"
          aria-label="Clear search"
        >
          <X className="h-4 w-4" aria-hidden />
        </button>
      ) : null}
    </div>
  );
}
