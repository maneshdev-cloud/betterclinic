"use client";

import { useState, useTransition } from "react";
import { Trash2, AlertTriangle, CheckCircle2, Loader2, X } from "lucide-react";
import { deleteDemoDataAction } from "@/lib/demo-actions";
import { useRouter } from "next/navigation";

export function DeleteDemoDialog() {
  const [isOpen, setIsOpen] = useState(false);
  const [inputPhrase, setInputPhrase] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [deletionReport, setDeletionReport] = useState<Record<string, number> | null>(null);
  const [isPending, startTransition] = useTransition();
  const router = useRouter();

  const requiredPhrase = "Better Clinic";
  const isMatch = inputPhrase.trim().toLowerCase() === requiredPhrase.toLowerCase();

  const handleOpen = () => {
    setIsOpen(true);
    setInputPhrase("");
    setError(null);
    setDeletionReport(null);
  };

  const handleClose = () => {
    if (isPending) return;
    setIsOpen(false);
    if (deletionReport) {
      router.refresh();
    }
  };

  const handleDelete = () => {
    if (!isMatch) return;
    setError(null);
    startTransition(async () => {
      const res = await deleteDemoDataAction(inputPhrase);
      if (res.success) {
        setDeletionReport(res.report as Record<string, number>);
      } else {
        setError(res.error || "Failed to purge synthetic data.");
      }
    });
  };

  return (
    <>
      <button
        onClick={handleOpen}
        type="button"
        className="inline-flex items-center space-x-2 px-3.5 py-2 rounded-xl bg-rose-500/10 hover:bg-rose-500/20 text-rose-400 border border-rose-500/30 text-xs font-semibold transition"
      >
        <Trash2 className="h-4 w-4" />
        <span>Delete Demo Data</span>
      </button>

      {isOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-sm animate-in fade-in duration-200">
          <div className="w-full max-w-lg rounded-2xl bg-slate-900 border border-slate-800 shadow-2xl p-6 text-slate-100 relative">
            <button
              onClick={handleClose}
              disabled={isPending}
              className="absolute top-4 right-4 text-slate-400 hover:text-white p-1 rounded-lg transition"
            >
              <X className="h-5 w-5" />
            </button>

            {!deletionReport ? (
              <div className="space-y-4">
                <div className="flex items-center space-x-3 text-rose-400">
                  <div className="p-2 rounded-lg bg-rose-500/10 border border-rose-500/30">
                    <AlertTriangle className="h-6 w-6" />
                  </div>
                  <div>
                    <h3 className="font-bold text-base text-white">Delete Synthetic Seed Data</h3>
                    <p className="text-xs text-rose-400/90 font-mono">Irreversible Scoped Purge</p>
                  </div>
                </div>

                <div className="text-xs text-slate-300 space-y-2 leading-relaxed bg-slate-950/60 p-3.5 rounded-xl border border-slate-800">
                  <p>
                    This will run <code className="text-cyan-400 font-mono">public.purge_synthetic_data()</code>,
                    permanently deleting all rows where <code className="text-cyan-400 font-mono">is_synthetic = true</code> across all 33 tables in foreign-key order.
                  </p>
                  <p className="text-emerald-400 font-medium">
                    ✓ All real accounts, real clinics, and real patient records will be completely preserved.
                  </p>
                </div>

                {error && (
                  <div className="text-xs p-3 rounded-lg bg-rose-950/50 border border-rose-800 text-rose-300">
                    {error}
                  </div>
                )}

                <div className="space-y-2 pt-1">
                  <label className="text-xs text-slate-300 block">
                    Type <span className="font-bold text-white tracking-wide">Better Clinic</span> to confirm:
                  </label>
                  <input
                    type="text"
                    value={inputPhrase}
                    disabled={isPending}
                    onChange={(e) => setInputPhrase(e.target.value)}
                    placeholder="Better Clinic"
                    className="w-full px-3 py-2 rounded-lg bg-slate-950 border border-slate-700 text-white text-sm focus:outline-none focus:border-cyan-500 font-mono"
                  />
                </div>

                <div className="flex items-center justify-end space-x-3 pt-3">
                  <button
                    type="button"
                    onClick={handleClose}
                    disabled={isPending}
                    className="px-4 py-2 rounded-lg bg-slate-800 hover:bg-slate-700 text-slate-300 text-xs font-medium transition"
                  >
                    Cancel
                  </button>
                  <button
                    type="button"
                    onClick={handleDelete}
                    disabled={!isMatch || isPending}
                    className={`inline-flex items-center space-x-2 px-4 py-2 rounded-lg text-xs font-semibold transition ${
                      isMatch && !isPending
                        ? "bg-rose-600 hover:bg-rose-500 text-white shadow-lg shadow-rose-950/50 cursor-pointer"
                        : "bg-slate-800 text-slate-500 cursor-not-allowed border border-slate-700"
                    }`}
                  >
                    {isPending ? (
                      <>
                        <Loader2 className="h-4 w-4 animate-spin" />
                        <span>Purging Data...</span>
                      </>
                    ) : (
                      <>
                        <Trash2 className="h-4 w-4" />
                        <span>Confirm Scoped Delete</span>
                      </>
                    )}
                  </button>
                </div>
              </div>
            ) : (
              <div className="space-y-4">
                <div className="flex items-center space-x-3 text-emerald-400">
                  <div className="p-2 rounded-lg bg-emerald-500/10 border border-emerald-500/30">
                    <CheckCircle2 className="h-6 w-6" />
                  </div>
                  <div>
                    <h3 className="font-bold text-base text-white">Synthetic Data Deleted</h3>
                    <p className="text-xs text-emerald-400 font-mono">Scoped Purge Successful</p>
                  </div>
                </div>

                <p className="text-xs text-slate-300">
                  All synthetic seed rows have been removed. Below is the breakdown of rows purged per table:
                </p>

                <div className="max-h-60 overflow-y-auto space-y-1 bg-slate-950 p-3 rounded-xl border border-slate-800 text-xs font-mono">
                  {Object.entries(deletionReport).map(([table, count]) => (
                    <div key={table} className="flex justify-between py-1 border-b border-slate-900 last:border-0">
                      <span className="text-slate-400">{table}</span>
                      <span className="text-emerald-400 font-semibold">{count} removed</span>
                    </div>
                  ))}
                </div>

                <div className="flex justify-end pt-2">
                  <button
                    type="button"
                    onClick={handleClose}
                    className="px-4 py-2 rounded-lg bg-cyan-600 hover:bg-cyan-500 text-white text-xs font-semibold transition"
                  >
                    Done
                  </button>
                </div>
              </div>
            )}
          </div>
        </div>
      )}
    </>
  );
}
