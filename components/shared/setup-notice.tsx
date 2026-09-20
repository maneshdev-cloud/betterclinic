import Link from "next/link";
import { PlugZap } from "lucide-react";
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";

/**
 * Friendly, actionable state shown anywhere the app runs without a
 * connected Supabase project. Never a crash, never a raw error.
 */
export function SetupNotice() {
  return (
    <Alert variant="warning">
      <PlugZap aria-hidden />
      <AlertTitle>Supabase is not connected yet</AlertTitle>
      <AlertDescription className="space-y-2">
        <p>
          This app needs a free <span className="font-medium">Supabase</span> project as its
          database, authentication and realtime backend. To connect it:
        </p>
        <ol className="list-decimal space-y-1 pl-5">
          <li>
            Create a project at{" "}
            <a
              className="font-medium text-primary underline underline-offset-2"
              href="https://supabase.com/dashboard"
              target="_blank"
              rel="noreferrer"
            >
              supabase.com/dashboard
            </a>{" "}
            (free tier is enough).
          </li>
          <li>
            In the project, open <span className="font-medium">Project Settings → API</span> and
            copy the <span className="font-mono text-xs">Project URL</span>,{" "}
            <span className="font-mono text-xs">anon key</span> and{" "}
            <span className="font-mono text-xs">service_role key</span>; also copy the database
            connection string from <span className="font-medium">Settings → Database</span>.
          </li>
          <li>
            Paste them into <span className="font-mono text-xs">.env.local</span> (the placeholders
            are already there), then restart the dev server.
          </li>
          <li>
            Run <span className="font-mono text-xs">npm run db:push</span> to create the schema,
            then <span className="font-mono text-xs">npm run seed</span> for realistic demo data.
          </li>
        </ol>
        <p>
          Full walkthrough on the{" "}
          <Link href="/setup" className="font-medium text-primary underline underline-offset-2">
            setup page
          </Link>
          .
        </p>
      </AlertDescription>
    </Alert>
  );
}
