"use client";

import { useEffect } from "react";
import Link from "next/link";
import { AlertTriangle, RotateCcw } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";

/**
 * Root error boundary. Server pages that fail mid-render (database
 * unreachable, unexpected shape) land here instead of a raw crash —
 * with an honest message and a retry.
 */
export default function RootError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    console.error("Page error:", error);
  }, [error]);

  return (
    <div className="flex min-h-[70vh] items-center justify-center px-4">
      <Card className="max-w-md text-center">
        <CardHeader>
          <span className="mx-auto mb-2 flex h-11 w-11 items-center justify-center rounded-full bg-amber-100">
            <AlertTriangle className="h-5 w-5 text-amber-700" aria-hidden />
          </span>
          <CardTitle>Something went wrong</CardTitle>
          <CardDescription>
            The page failed to load. This is a prototype — if your Supabase project or database
            connection is not configured yet, most signed-in pages cannot load their data.
          </CardDescription>
        </CardHeader>
        <CardContent className="flex flex-col gap-2">
          <Button onClick={reset}>
            <RotateCcw className="mr-1.5 h-4 w-4" aria-hidden />
            Try again
          </Button>
          <Link href="/" className="text-sm text-muted-foreground underline hover:text-foreground">
            Back to the home page
          </Link>
        </CardContent>
      </Card>
    </div>
  );
}
