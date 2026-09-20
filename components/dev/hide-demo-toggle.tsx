"use client";

import { useState, useTransition } from "react";
import { Eye, EyeOff, Loader2 } from "lucide-react";
import { toggleHideDemoAction } from "@/lib/demo-actions";
import { useRouter } from "next/navigation";

interface HideDemoToggleProps {
  initialHideDemo: boolean;
}

export function HideDemoToggle({ initialHideDemo }: HideDemoToggleProps) {
  const [hideDemo, setHideDemo] = useState(initialHideDemo);
  const [isPending, startTransition] = useTransition();
  const router = useRouter();

  const handleToggle = (checked: boolean) => {
    setHideDemo(checked);
    startTransition(async () => {
      await toggleHideDemoAction(checked);
      router.refresh();
    });
  };

  return (
    <div className="flex flex-col sm:flex-row sm:items-center justify-between p-4 rounded-xl bg-slate-900 border border-slate-800 gap-4">
      <div className="flex items-start sm:items-center space-x-3">
        <div
          className={`p-2.5 rounded-lg border ${
            hideDemo
              ? "bg-amber-500/10 border-amber-500/30 text-amber-400"
              : "bg-cyan-500/10 border-cyan-500/30 text-cyan-400"
          }`}
        >
          {hideDemo ? <EyeOff className="h-5 w-5" /> : <Eye className="h-5 w-5" />}
        </div>
        <div>
          <div className="flex items-center space-x-2">
            <span className="font-semibold text-sm text-white">Hide Demo Data (App-wide)</span>
            <span
              className={`text-xs px-2 py-0.5 rounded-full font-medium ${
                hideDemo
                  ? "bg-amber-950 text-amber-400 border border-amber-800/60"
                  : "bg-slate-800 text-slate-400 border border-slate-700"
              }`}
            >
              {hideDemo ? "Active (Real Users Only)" : "Inactive (Demo + Real Visible)"}
            </span>
          </div>
          <p className="text-xs text-slate-400 mt-0.5">
            When enabled, all queries across the entire app exclude rows where{" "}
            <code className="text-cyan-400 font-mono text-[11px]">is_synthetic = true</code>.
            Reversible instantly with zero data loss.
          </p>
        </div>
      </div>

      <div className="flex items-center space-x-3 self-end sm:self-auto">
        {isPending && <Loader2 className="h-4 w-4 animate-spin text-cyan-400" />}
        <label className="relative inline-flex items-center cursor-pointer">
          <input
            type="checkbox"
            checked={hideDemo}
            disabled={isPending}
            onChange={(e) => handleToggle(e.target.checked)}
            className="sr-only peer"
          />
          <div className="w-11 h-6 bg-slate-800 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-amber-500"></div>
        </label>
      </div>
    </div>
  );
}
