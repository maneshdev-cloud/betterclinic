"use client";

import { Printer } from "lucide-react";
import { Button } from "@/components/ui/button";

/** Uses the browser's native print dialog (no external PDF service). */
export function PrintButton({ label = "Print" }: { label?: string }) {
  return (
    <Button variant="outline" size="sm" onClick={() => window.print()}>
      <Printer className="mr-1.5 h-4 w-4" aria-hidden /> {label}
    </Button>
  );
}
