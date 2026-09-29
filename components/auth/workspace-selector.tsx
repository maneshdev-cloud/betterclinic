"use client";

import { useState, useTransition, useEffect, useRef } from "react";
import { Building2, Stethoscope, User, Users, ArrowRight, Loader2, RefreshCw, AlertCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { switchRoleAction } from "@/app/(auth)/actions";
import { useNavigationProgress } from "@/components/layout/navigation-progress";
import { roleHomePath, type Role } from "@/lib/constants";
import { cn } from "@/lib/utils";

const ROLE_DETAILS: Record<
  Role,
  { title: string; description: string; icon: React.ComponentType<{ className?: string }> }
> = {
  PATIENT: {
    title: "Patient",
    description: "Book appointments, track live queue tokens, and view medical records.",
    icon: User,
  },
  DOCTOR: {
    title: "Doctor",
    description: "Manage consultations, write prescriptions, and call patients from the queue.",
    icon: Stethoscope,
  },
  RECEPTIONIST: {
    title: "Receptionist",
    description: "Check in patients, issue queue tokens, and coordinate clinic flow.",
    icon: Users,
  },
  CLINIC_ADMIN: {
    title: "Clinic Administrator",
    description: "Manage clinic hours, onboard doctors and staff, and view operational analytics.",
    icon: Building2,
  },
};

interface WorkspaceSelectorProps {
  roles: Role[];
  currentRole: Role;
  userFullName: string;
}

export function WorkspaceSelector({
  roles,
  currentRole,
  userFullName,
}: WorkspaceSelectorProps) {
  const [pendingRole, setPendingRole] = useState<Role | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [isDelayed, setIsDelayed] = useState(false);
  const [isPending, startTransition] = useTransition();
  const { startNavigation, stopNavigation } = useNavigationProgress();
  const delayTimerRef = useRef<NodeJS.Timeout | null>(null);

  useEffect(() => {
    return () => {
      if (delayTimerRef.current) clearTimeout(delayTimerRef.current);
    };
  }, []);

  const handleSelectRole = (targetRole: Role) => {
    if (pendingRole !== null || isPending) return;

    setError(null);
    setIsDelayed(false);
    setPendingRole(targetRole);

    // Trigger non-blocking global top progress bar immediately
    startNavigation(roleHomePath(targetRole));

    // Notice if network/session initialization takes longer than 2.8s
    if (delayTimerRef.current) clearTimeout(delayTimerRef.current);
    delayTimerRef.current = setTimeout(() => {
      setIsDelayed(true);
    }, 2800);

    startTransition(async () => {
      try {
        // 120ms micro-buffer to ensure intentional visual click acknowledgement
        await new Promise((resolve) => setTimeout(resolve, 120));
        await switchRoleAction(targetRole);
      } catch (err: unknown) {
        const errorObject = err as { digest?: string; message?: string };
        // Next.js redirect throws a NEXT_REDIRECT digest which is expected
        if (
          errorObject?.digest?.startsWith("NEXT_REDIRECT") ||
          errorObject?.message === "NEXT_REDIRECT"
        ) {
          return;
        }

        if (delayTimerRef.current) clearTimeout(delayTimerRef.current);
        console.error("Workspace switch failed:", err);
        setError(
          errorObject?.message ||
            "Failed to switch workspace. Please check your connection and try again."
        );
        setPendingRole(null);
        setIsDelayed(false);
        stopNavigation();
      }
    });
  };

  return (
    <div className="w-full max-w-lg space-y-6">
      <div className="text-center">
        <h1 className="text-2xl font-bold tracking-tight">Choose your workspace</h1>
        <p className="mt-2 text-sm text-muted-foreground">
          Welcome, <strong>{userFullName}</strong>. Your account has multiple active roles. Select which
          workspace you want to use for this session.
        </p>
      </div>

      <div className="space-y-3" role="group" aria-label="Available workspaces">
        {roles.map((r) => {
          const info = ROLE_DETAILS[r] ?? {
            title: r,
            description: "Access your clinic role workspace.",
            icon: User,
          };
          const Icon = info.icon;
          const isCurrent = currentRole === r;
          const isSelected = pendingRole === r;
          const isDisabled = pendingRole !== null && !isSelected;

          return (
            <Card
              key={r}
              onClick={() => {
                if (!isDisabled && !isSelected) {
                  handleSelectRole(r);
                }
              }}
              className={cn(
                "group relative overflow-hidden transition-all duration-150 select-none",
                !isDisabled && !isSelected && "hover:border-primary hover:shadow-md cursor-pointer",
                isCurrent && !isSelected && "border-primary/60 bg-primary/5",
                isSelected && "border-primary ring-2 ring-primary/20 bg-primary/5 shadow-md",
                isDisabled && "opacity-50 pointer-events-none cursor-not-allowed"
              )}
            >
              <CardContent className="p-4 flex items-center justify-between gap-4">
                <div className="flex items-start gap-3.5">
                  <div
                    className={cn(
                      "rounded-lg p-2 shrink-0 transition-colors",
                      isSelected
                        ? "bg-primary text-primary-foreground shadow-xs"
                        : "bg-primary/10 text-primary"
                    )}
                  >
                    <Icon className="h-5 w-5" />
                  </div>
                  <div>
                    <div className="flex items-center gap-2">
                      <p className="font-semibold text-sm">{info.title}</p>
                      {isCurrent ? (
                        <span className="rounded bg-primary/20 px-1.5 py-0.2 text-[10px] font-medium text-primary">
                          Current
                        </span>
                      ) : null}
                    </div>
                    <p className="text-xs text-muted-foreground mt-0.5">{info.description}</p>
                  </div>
                </div>

                <Button
                  size="sm"
                  variant={isCurrent ? "default" : "outline"}
                  loading={isSelected}
                  disabled={isDisabled || isSelected}
                  onClick={(e) => {
                    e.stopPropagation();
                    handleSelectRole(r);
                  }}
                  className={cn(
                    "shrink-0 min-w-[96px] transition-all",
                    isSelected && "font-semibold pointer-events-none shadow-xs",
                    !isSelected && "gap-1 group-hover:translate-x-0.5 transition-transform"
                  )}
                >
                  {isSelected ? (
                    "Opening…"
                  ) : (
                    <>
                      Continue
                      <ArrowRight className="h-3.5 w-3.5" />
                    </>
                  )}
                </Button>
              </CardContent>

              {/* Subtle non-blocking progress line on the selected card */}
              {isSelected ? (
                <div
                  className="absolute inset-x-0 bottom-0 h-0.5 bg-primary/20 overflow-hidden"
                  role="progressbar"
                  aria-label={`Opening ${info.title} workspace`}
                >
                  <div className="h-full bg-primary animate-indeterminate" />
                </div>
              ) : null}
            </Card>
          );
        })}
      </div>

      {/* Lightweight loading and progress status */}
      {pendingRole ? (
        <div
          className="flex flex-col items-center gap-2 pt-1 animate-in fade-in duration-200"
          role="status"
          aria-live="polite"
        >
          <div className="flex items-center gap-2 text-xs font-medium text-muted-foreground">
            <Loader2 className="h-3.5 w-3.5 animate-spin text-primary" />
            <span>Connecting to {ROLE_DETAILS[pendingRole]?.title ?? "selected"} workspace…</span>
          </div>
          {isDelayed ? (
            <div className="flex items-center gap-2 rounded-md border border-amber-300/60 bg-amber-50/90 px-3 py-1.5 text-xs font-medium text-amber-800 dark:border-amber-700/50 dark:bg-amber-950/40 dark:text-amber-300 animate-in fade-in slide-in-from-top-1">
              <RefreshCw className="h-3.5 w-3.5 shrink-0 animate-spin text-amber-700 dark:text-amber-400" />
              <span>Setting up your session — taking a moment, thanks for your patience...</span>
            </div>
          ) : null}
        </div>
      ) : null}

      {/* Graceful error state if network or session switch fails */}
      {error ? (
        <div className="flex items-center gap-2 rounded-md border border-destructive/40 bg-destructive/10 p-3 text-xs text-destructive animate-in fade-in">
          <AlertCircle className="h-4 w-4 shrink-0" />
          <span className="flex-1">{error}</span>
          <Button
            size="sm"
            variant="outline"
            className="h-7 text-xs px-2.5"
            onClick={() => setError(null)}
          >
            Try again
          </Button>
        </div>
      ) : null}

      <p className="text-center text-xs text-muted-foreground">
        You can switch between your roles anytime using the profile menu in the top navigation.
      </p>
    </div>
  );
}
