"use client";

import { useState } from "react";
import { Database, Search, Layers } from "lucide-react";

interface TableStat {
  real: number;
  synthetic: number;
  total: number;
}

interface DataBreakdownTableProps {
  breakdowns: Record<string, TableStat>;
}

export function DataBreakdownTable({ breakdowns }: DataBreakdownTableProps) {
  const [filter, setFilter] = useState("");

  const keyTables = [
    "profiles",
    "patients",
    "doctors",
    "clinics",
    "clinic_staff",
    "appointments",
    "appointment_slots",
    "consultations",
    "prescriptions",
    "prescription_items",
    "medication_schedules",
    "follow_ups",
    "diagnoses",
    "treatment_plans",
    "reviews",
    "notifications",
    "queue_entries",
    "check_ins",
    "emergency_requests",
    "ai_conversations",
    "ai_messages",
  ];

  const entries = Object.entries(breakdowns).filter(([name]) => {
    if (!filter) return true;
    return name.toLowerCase().includes(filter.toLowerCase());
  });

  // Sort key tables first, then alphabetically
  entries.sort(([a], [b]) => {
    const aKey = keyTables.includes(a);
    const bKey = keyTables.includes(b);
    if (aKey && !bKey) return -1;
    if (!aKey && bKey) return 1;
    return a.localeCompare(b);
  });

  const totalReal = Object.values(breakdowns).reduce((acc, curr) => acc + (curr.real || 0), 0);
  const totalSynth = Object.values(breakdowns).reduce((acc, curr) => acc + (curr.synthetic || 0), 0);
  const grandTotal = totalReal + totalSynth;

  return (
    <div className="p-5 rounded-2xl bg-slate-900 border border-slate-800 space-y-4">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
        <div className="flex items-center space-x-3">
          <div className="p-2.5 rounded-xl bg-cyan-500/10 border border-cyan-500/30 text-cyan-400">
            <Layers className="h-5 w-5" />
          </div>
          <div>
            <h3 className="font-bold text-sm text-white">Database Row Breakdown (Real vs. Synthetic)</h3>
            <p className="text-xs text-slate-400">
              {totalReal.toLocaleString()} real rows &bull; {totalSynth.toLocaleString()} synthetic seed rows &bull; {grandTotal.toLocaleString()} total
            </p>
          </div>
        </div>

        <div className="relative w-full sm:w-64">
          <Search className="absolute left-3 top-2.5 h-3.5 w-3.5 text-slate-500" />
          <input
            type="text"
            value={filter}
            onChange={(e) => setFilter(e.target.value)}
            placeholder="Search table name..."
            className="w-full pl-8 pr-3 py-1.5 rounded-lg bg-slate-950 border border-slate-700 text-xs text-white placeholder-slate-500 focus:outline-none focus:border-cyan-500 font-mono"
          />
        </div>
      </div>

      <div className="border border-slate-800 rounded-xl overflow-hidden bg-slate-950">
        <div className="overflow-x-auto max-h-96">
          <table className="w-full text-left text-xs font-mono">
            <thead className="bg-slate-900/90 text-slate-400 uppercase tracking-wider text-[11px] sticky top-0 z-10 border-b border-slate-800">
              <tr>
                <th className="py-2.5 px-4">Table Name</th>
                <th className="py-2.5 px-4 text-right">Real Rows</th>
                <th className="py-2.5 px-4 text-right">Synthetic Rows</th>
                <th className="py-2.5 px-4 text-right">Total Rows</th>
                <th className="py-2.5 px-4 text-right">Composition</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-900">
              {entries.map(([table, stat]) => {
                const synthPct = stat.total > 0 ? Math.round((stat.synthetic / stat.total) * 100) : 0;
                const isKey = keyTables.includes(table);

                return (
                  <tr key={table} className="hover:bg-slate-900/40 transition">
                    <td className="py-2 px-4 flex items-center space-x-2">
                      <span className={isKey ? "text-white font-semibold" : "text-slate-300"}>
                        {table}
                      </span>
                      {isKey && (
                        <span className="text-[10px] px-1 py-0.2 rounded bg-cyan-950 text-cyan-400 border border-cyan-800/40">
                          core
                        </span>
                      )}
                    </td>
                    <td className="py-2 px-4 text-right text-emerald-400 font-medium">
                      {stat.real.toLocaleString()}
                    </td>
                    <td className="py-2 px-4 text-right text-amber-400 font-medium">
                      {stat.synthetic.toLocaleString()}
                    </td>
                    <td className="py-2 px-4 text-right text-slate-300 font-bold">
                      {stat.total.toLocaleString()}
                    </td>
                    <td className="py-2 px-4 text-right">
                      <div className="flex items-center justify-end space-x-2">
                        <div className="w-16 bg-emerald-950/60 rounded-full h-1.5 overflow-hidden flex">
                          <div
                            className="bg-amber-400 h-full"
                            style={{ width: `${synthPct}%` }}
                            title={`${synthPct}% Synthetic`}
                          />
                        </div>
                        <span className="text-[10px] text-slate-400 w-8 text-right">{synthPct}% S</span>
                      </div>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
