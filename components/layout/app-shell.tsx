"use client";

import { useState } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { Menu, Stethoscope, Loader2 } from "lucide-react";
import { useNavigationProgress } from "@/components/layout/navigation-progress";
import {
  Sheet,
  SheetContent,
  SheetHeader,
  SheetTitle,
  SheetTrigger,
} from "@/components/ui/sheet";
import { Badge } from "@/components/ui/badge";
import { UserMenu } from "@/components/layout/user-menu";
import { ThemeToggle } from "@/components/layout/theme-toggle";
import { NotificationBell } from "@/components/notifications/notification-bell";
import { DoctorIdBadgeModal } from "@/components/doctors/doctor-id-badge-modal";
import {
  PATIENT_NAV,
  DOCTOR_NAV,
  STAFF_NAV,
  ADMIN_NAV,
  type NavSection,
} from "@/components/layout/nav-config";
import { ROLE_LABELS, type Role } from "@/lib/constants";
import { cn } from "@/lib/utils";

interface AppShellProps {
  sections?: NavSection[];
  userName: string;
  userEmail: string;
  userRole: Role;
  avatarUrl?: string | null;
  settingsHref: string;
  availableRoles?: Role[];
  /** Signed-in user id — used to scope the notification bell (RLS). */
  userId: string;
  notificationsHref: string;
  contextLabel?: string;
  children: React.ReactNode;
}

function NavLink({
  item,
  active,
  onNavigate,
}: {
  item: NavSection["items"][number];
  active: boolean;
  onNavigate?: () => void;
}) {
  const { pendingHref } = useNavigationProgress();
  const isPending = pendingHref === item.href;

  return (
    <Link
      href={item.href}
      prefetch={true}
      onClick={onNavigate}
      aria-current={active ? "page" : undefined}
      aria-busy={isPending ? "true" : undefined}
      className={cn(
        "group relative flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium transition-colors",
        "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring",
        isPending && "pointer-events-none bg-primary/10 text-primary font-medium",
        !isPending &&
          active &&
          "bg-primary/10 text-primary font-semibold shadow-2xs",
        !isPending &&
          !active &&
          "text-muted-foreground hover:bg-muted hover:text-foreground"
      )}
    >
      {active && (
        <span
          className="absolute left-0 top-2 bottom-2 w-1 rounded-r-full bg-primary"
          aria-hidden
        />
      )}
      <item.icon
        className={cn(
          "h-4 w-4 shrink-0 transition-colors",
          isPending && "text-primary animate-pulse",
          !isPending && active && "text-primary",
          !isPending && !active && "text-muted-foreground group-hover:text-foreground"
        )}
        aria-hidden
      />
      <span className="flex-1 truncate">{item.label}</span>
      {isPending ? (
        <Loader2
          className="h-3.5 w-3.5 shrink-0 animate-spin text-primary/80"
          aria-hidden
        />
      ) : null}
    </Link>
  );
}

function NavSections({
  sections,
  pathname,
  onNavigate,
}: {
  sections: NavSection[];
  pathname: string;
  onNavigate?: () => void;
}) {
  return (
    <nav className="flex-1 space-y-6 overflow-y-auto no-scrollbar px-3 py-4" aria-label="Main navigation">
      {sections.map((section) => (
        <div key={section.title}>
          <p className="mb-2 px-3 text-[11px] font-bold uppercase tracking-wider text-muted-foreground">
            {section.title}
          </p>
          <div className="space-y-1">
            {section.items.map((item) => (
              <NavLink
                key={item.href}
                item={item}
                active={pathname === item.href}
                onNavigate={onNavigate}
              />
            ))}
          </div>
        </div>
      ))}
    </nav>
  );
}

export function AppShell({
  sections,
  userName,
  userEmail,
  userRole,
  avatarUrl,
  settingsHref,
  availableRoles,
  userId,
  notificationsHref,
  contextLabel,
  children,
}: AppShellProps) {
  const pathname = usePathname();
  const [mobileOpen, setMobileOpen] = useState(false);
  const { isNavigating } = useNavigationProgress();

  const navSections =
    sections ??
    (userRole === "PATIENT"
      ? PATIENT_NAV
      : userRole === "DOCTOR"
        ? DOCTOR_NAV
        : userRole === "CLINIC_ADMIN"
          ? ADMIN_NAV
          : STAFF_NAV);

  const header = (
    <header className="sticky top-0 z-30 flex h-16 shrink-0 items-center justify-between border-b border-border/80 bg-card/90 backdrop-blur-md px-4 transition-colors">
      <div className="flex items-center gap-3">
        <Sheet open={mobileOpen} onOpenChange={setMobileOpen}>
          <SheetTrigger
            className="rounded-lg p-2 hover:bg-muted focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring lg:hidden text-foreground"
            aria-label="Open navigation menu"
          >
            <Menu className="h-5 w-5" />
          </SheetTrigger>
          <SheetContent side="left" className="flex flex-col w-72 p-0 h-full border-r bg-card">
            <SheetHeader className="border-b shrink-0 px-4 py-4">
              <SheetTitle className="flex items-center gap-3 text-base">
                <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-primary-foreground shadow-sm">
                  <Stethoscope className="h-4 w-4" aria-hidden />
                </div>
                <div className="flex flex-col text-left">
                  <span className="font-bold tracking-tight text-foreground">Better Clinic</span>
                  <span className="text-[11px] font-medium text-muted-foreground">
                    {ROLE_LABELS[userRole] || "Healthcare"}
                  </span>
                </div>
              </SheetTitle>
            </SheetHeader>
            <NavSections sections={navSections} pathname={pathname} onNavigate={() => setMobileOpen(false)} />
          </SheetContent>
        </Sheet>

        <div className="flex items-center gap-3">
          <Link href="/" className="flex items-center gap-2.5 lg:hidden">
            <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary text-primary-foreground">
              <Stethoscope className="h-4 w-4" aria-hidden />
            </div>
            <span className="text-sm font-bold tracking-tight">Better Clinic</span>
          </Link>

          {contextLabel ? (
            <div className="hidden sm:flex items-center gap-2">
              <span className="text-muted-foreground/60 text-xs">/</span>
              <span className="max-w-[240px] truncate text-xs font-semibold text-foreground bg-muted/70 px-2.5 py-1 rounded-md border border-border/60">
                {contextLabel}
              </span>
            </div>
          ) : null}
        </div>
      </div>

      <div className="flex items-center gap-2.5">
        {/* Always visible button to inspect 3D ID Card Lanyard */}
        <DoctorIdBadgeModal
          name={userRole === "DOCTOR" ? userName : "Dr. Aarav Deshmukh"}
          role={userRole === "DOCTOR" ? "Verified Consultant" : "Chief of Medicine"}
          brand="BETTER CLINIC"
          brandTagline="Digital Credential ID"
          idNumber="DOC-4921-MMC"
          location="Mumbai Central Campus"
          avatarUrl={userRole === "DOCTOR" ? avatarUrl : "https://images.unsplash.com/photo-1622253692010-333f2da6031d?auto=format&fit=crop&w=256&q=80"}
          variant="header"
          buttonText="ID Card Badge"
        />

        <div className="hidden md:flex items-center gap-1.5 px-3 py-1 rounded-full bg-emerald-50 text-emerald-700 dark:bg-emerald-950/40 dark:text-emerald-300 border border-emerald-200 dark:border-emerald-800 text-xs font-semibold">
          <span className="h-2 w-2 rounded-full bg-emerald-500 animate-pulse" />
          <span>Clinic Online</span>
        </div>

        <ThemeToggle />

        <NotificationBell userId={userId} viewAllHref={notificationsHref} />

        <div className="h-5 w-px bg-border mx-1" />

        <UserMenu
          name={userName}
          email={userEmail}
          role={userRole}
          avatarUrl={avatarUrl}
          settingsHref={settingsHref}
          availableRoles={availableRoles}
        />
      </div>
    </header>
  );

  return (
    <div className="flex min-h-screen bg-background">
      {/* Desktop sidebar */}
      <aside className="sticky top-0 hidden h-screen w-64 shrink-0 flex-col border-r border-border/80 bg-card/95 lg:flex">
        {/* Brand Header */}
        <div className="flex h-16 items-center gap-3 border-b border-border/80 px-4">
          <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-primary-foreground shadow-sm shadow-primary/20">
            <Stethoscope className="h-5 w-5" aria-hidden />
          </div>
          <div className="flex flex-col">
            <span className="text-sm font-bold tracking-tight text-foreground">Better Clinic</span>
            <span className="text-[11px] font-medium text-muted-foreground">
              Healthcare Portal
            </span>
          </div>
        </div>

        {/* Role context card */}
        <div className="px-3 pt-3">
          <div className="flex items-center justify-between rounded-xl border border-border/70 bg-muted/40 p-2.5">
            <div className="flex items-center gap-2 truncate">
              <div className="h-2 w-2 rounded-full bg-primary" />
              <span className="truncate text-xs font-bold text-foreground">
                {ROLE_LABELS[userRole] || "Portal"}
              </span>
            </div>
            {contextLabel ? (
              <Badge variant="outline" className="text-[10px] px-1.5 py-0 border-primary/30 text-primary">
                {contextLabel}
              </Badge>
            ) : null}
          </div>
        </div>

        {/* Navigation Sections */}
        <NavSections sections={navSections} pathname={pathname} />

        {/* Footer status widget */}
        <div className="border-t border-border/80 p-3.5 bg-muted/30">
          <div className="flex items-center justify-between text-xs text-muted-foreground">
            <span className="font-medium">Better Clinic</span>
            <span className="rounded-full bg-emerald-50 px-2 py-0.5 text-[10px] font-semibold text-emerald-700 dark:bg-emerald-950/40 dark:text-emerald-300">
              Active
            </span>
          </div>
        </div>
      </aside>

      {/* Main column */}
      <div className="flex min-w-0 flex-1 flex-col">
        {header}
        {isNavigating ? (
          <div
            className="h-0.5 w-full bg-primary/20 overflow-hidden shrink-0"
            role="status"
            aria-label="Loading page content"
          >
            <div className="h-full bg-primary animate-indeterminate" />
          </div>
        ) : null}
        <main
          className={cn(
            "flex-1 bg-background transition-opacity duration-150",
            isNavigating && "opacity-70 pointer-events-none"
          )}
        >
          {children}
        </main>
      </div>
    </div>
  );
}
