import Link from "next/link";
import { SearchX } from "lucide-react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";

/** Custom 404 — keeps the app's look instead of the default bare page. */
export default function NotFound() {
  return (
    <div className="flex min-h-screen items-center justify-center px-4">
      <Card className="max-w-md text-center">
        <CardHeader>
          <span className="mx-auto mb-2 flex h-11 w-11 items-center justify-center rounded-full bg-muted">
            <SearchX className="h-5 w-5 text-muted-foreground" aria-hidden />
          </span>
          <CardTitle>Page not found</CardTitle>
          <CardDescription>
            The page you are looking for does not exist or may have moved.
          </CardDescription>
        </CardHeader>
        <CardContent className="flex flex-col gap-2">
          <Link
            href="/"
            className="rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground hover:bg-primary/90"
          >
            Go to the home page
          </Link>
          <Link href="/login" className="text-sm text-muted-foreground underline hover:text-foreground">
            Sign in
          </Link>
        </CardContent>
      </Card>
    </div>
  );
}
