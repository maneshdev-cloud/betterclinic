"use client";

import React, { useState } from "react";
import { CreditCard, Sparkles } from "lucide-react";
import { Button } from "@/components/ui/button";
import { IDCardLanyard } from "@/components/ui/id-card-lanyard";

export interface DoctorIdBadgeModalProps {
  name: string;
  role: string;
  brand?: string;
  brandTagline?: string;
  idNumber?: string;
  location?: string;
  validThru?: string;
  pillars?: [string, string, string];
  avatarUrl?: string | null;
  site?: string;
  variant?: "button" | "header" | "pill" | "card" | "all";
  buttonText?: string;
  className?: string;
}

export function DoctorIdBadgeModal({
  name,
  role,
  brand = "BETTER CLINIC",
  brandTagline = "Certified Medical Specialist",
  idNumber = "DOC-4921",
  location = "Mumbai Medical Wing",
  validThru = "12/2028",
  pillars = ["Clinical", "Verified", "Excellence"],
  avatarUrl,
  site = "betterclinic.health/verify",
  variant = "button",
  buttonText,
  className = "",
}: DoctorIdBadgeModalProps) {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <>
      {/* Header compact variant (for top navigation bar) */}
      {variant === "header" && (
        <Button
          type="button"
          variant="outline"
          size="sm"
          onClick={() => setIsOpen(true)}
          className={`h-8 px-3 gap-1.5 border-teal-500/40 bg-teal-50/70 hover:bg-teal-100 dark:bg-teal-950/30 dark:border-teal-500/30 dark:hover:bg-teal-950/50 text-teal-900 dark:text-teal-200 font-semibold text-xs rounded-full shadow-2xs transition-all hover:scale-105 active:scale-95 ${className}`}
          title="Click to view interactive 3D Doctor ID Card Lanyard"
        >
          <Sparkles className="h-3.5 w-3.5 text-teal-600 dark:text-teal-400 animate-pulse" />
          <span>{buttonText ?? "View ID Card"}</span>
          <span className="hidden sm:inline-block rounded bg-teal-200/60 dark:bg-teal-800/60 px-1 py-0.2 text-[9px] uppercase font-bold text-teal-950 dark:text-teal-200">
            3D
          </span>
        </Button>
      )}

      {/* Card compact variant (for doctor directory listing cards) */}
      {variant === "card" && (
        <Button
          type="button"
          variant="outline"
          size="sm"
          onClick={() => setIsOpen(true)}
          className={`h-8 gap-1.5 border-teal-500/30 bg-teal-50/50 hover:bg-teal-100/70 dark:bg-teal-950/20 dark:border-teal-500/30 dark:hover:bg-teal-950/40 text-teal-800 dark:text-teal-300 text-xs font-medium ${className}`}
          title="Click to view doctor's official ID Card Lanyard"
        >
          <CreditCard className="h-3.5 w-3.5 text-teal-600 dark:text-teal-400" />
          <span>{buttonText ?? "View ID Card"}</span>
        </Button>
      )}

      {/* Primary standard button variant */}
      {(variant === "button" || variant === "all") && (
        <Button
          type="button"
          variant="outline"
          size="sm"
          onClick={() => setIsOpen(true)}
          className={`group relative inline-flex items-center gap-2 border-teal-500/30 bg-teal-50/50 hover:bg-teal-100/70 dark:bg-teal-950/20 dark:border-teal-500/30 dark:hover:bg-teal-950/40 text-teal-800 dark:text-teal-300 font-medium transition-all shadow-sm hover:shadow ${className}`}
          title="View doctor's interactive 3D digital credential & lanyard badge"
        >
          <span className="relative flex h-2 w-2">
            <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-teal-400 opacity-75" />
            <span className="relative inline-flex rounded-full h-2 w-2 bg-teal-500" />
          </span>
          <CreditCard className="h-4 w-4 text-teal-600 dark:text-teal-400 transition-transform group-hover:rotate-6" />
          <span>{buttonText ?? "View ID Card Badge"}</span>
          <span className="rounded bg-teal-200/60 dark:bg-teal-800/60 px-1.5 py-0.5 text-[10px] uppercase font-semibold text-teal-900 dark:text-teal-200 tracking-wide">
            Interactive
          </span>
        </Button>
      )}

      {/* Floating pill variant */}
      {(variant === "pill" || variant === "all") && (
        <div className="fixed bottom-6 right-6 z-40 hidden sm:block">
          <button
            type="button"
            onClick={() => setIsOpen(true)}
            className="group flex items-center gap-2.5 rounded-full bg-slate-900/90 hover:bg-slate-900 text-white dark:bg-white dark:text-slate-950 px-4 py-2.5 shadow-2xl backdrop-blur-md border border-slate-700/50 transition-all hover:scale-105 active:scale-95 cursor-pointer"
            title="Open Doctor ID Card Lanyard"
          >
            <Sparkles className="h-4 w-4 text-teal-400 dark:text-teal-600 animate-pulse" />
            <span className="text-xs font-semibold">Doctor ID Badge</span>
          </button>
        </div>
      )}

      {/* 3D Physics Lanyard Modal — only visible when clicked */}
      {isOpen && (
        <IDCardLanyard
          name={name}
          role={role}
          brand={brand}
          brandTagline={brandTagline}
          idNumber={idNumber}
          location={location}
          validThru={validThru}
          pillars={pillars}
          avatarUrl={avatarUrl}
          site={site}
          anchorX="50%"
          anchorY={12}
          zIndex={9999}
          onClose={() => setIsOpen(false)}
        />
      )}
    </>
  );
}
