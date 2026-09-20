"use client";

import { useState } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { Menu, Stethoscope } from "lucide-react";
import {
  Sheet,
  SheetContent,
  SheetHeader,
  SheetTitle,
  SheetTrigger,
} from "@/components/ui/sheet";
import { Badge } from "@/components/ui/badge";
import { UserMenu } from "@/components/layout/user-menu";
import { NotificationBell } from "@/components/notifications/notification-bell";
import {
  PATIENT_NAV,
  DOCTOR_NAV,
  STAFF_NAV,
  ADMIN_NAV,
  type NavSection,
} from "@/components/layout/nav-config";
import type { Role } from "@/lib/constants";
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
  return (
    <Link
      href={item.href}
      onClick={onNavigate}
      aria-current={active ? "page" : undefined}
      className={cn(
        "flex items-center gap-2.5 rounded-md px-2.5 py-2 text-sm font-medium transition-colors",
        "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring",
        active
          ? "bg-secondary text-secondary-foreground"
          : "text-muted-foreground hover:bg-muted hover:text-foreground"
      )}
    >
      <item.icon className="h-4 w-4 shrink-0" aria-hidden />
      {item.label}
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
    <nav className="flex-1 space-y-5 overflow-y-auto px-3 py-4" aria-label="Main navigation">
      {sections.map((section) => (
        <div key={section.title}>
          <p className="mb-1.5 px-2.5 text-[11px] font-semibold uppercase tracking-wider text-muted-foreground">
            {section.title}
          </p>
          <div className="space-y-0.5">
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
    <div className="flex h-14 shrink-0 items-center justify-between border-b bg-card px-4">
      <div className="flex items-center gap-2">
        <Sheet open={mobileOpen} onOpenChange={setMobileOpen}>
          <SheetTrigger
            className="rounded-md p-2 hover:bg-muted focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring lg:hidden"
            aria-label="Open navigation menu"
          >
            <Menu className="h-5 w-5" />
          </SheetTrigger>
          <SheetContent side="left" className="w-72 p-0">
            <SheetHeader className="border-b">
              <SheetTitle className="flex items-center gap-2 text-base">
                <div className="flex h-7 w-7 items-center justify-center rounded-md bg-primary">
                  <Stethoscope className="h-3.5 w-3.5 text-primary-foreground" aria-hidden />
                </div>
                Better Clinic
              </SheetTitle>
            </SheetHeader>
            <NavSections sections={navSections} pathname={pathname} onNavigate={() => setMobileOpen(false)} />
          </SheetContent>
        </Sheet>
        <div className="flex items-center gap-2.5">
          <span className="text-sm font-semibold tracking-tight">Better Clinic</span>
          {contextLabel ? (
            <span className="hidden max-w-[220px] truncate text-sm text-muted-foreground sm:block">
              · {contextLabel}
            </span>
          ) : null}
        </div>
      </div>
      <div className="flex items-center gap-1.5">
        <NotificationBell userId={userId} viewAllHref={notificationsHref} />
        <UserMenu
          name={userName}
          email={userEmail}
          role={userRole}
          avatarUrl={avatarUrl}
          settingsHref={settingsHref}
          availableRoles={availableRoles}
        />
      </div>
    </div>
  );

  return (
    <div className="flex min-h-screen">
      {/* Desktop sidebar */}
      <aside className="sticky top-0 hidden h-screen w-60 shrink-0 flex-col border-r bg-card lg:flex">
        <div className="flex h-14 items-center gap-2 border-b px-4">
          <div className="flex h-7 w-7 items-center justify-center rounded-md bg-primary">
            <Stethoscope className="h-3.5 w-3.5 text-primary-foreground" aria-hidden />
          </div>
          <span className="text-sm font-semibold tracking-tight">Better Clinic</span>
        </div>
        {contextLabel ? (
          <div className="px-4 pt-4">
            <Badge variant="secondary" className="max-w-full truncate">
              {contextLabel}
            </Badge>
          </div>
        ) : null}
        <NavSections sections={navSections} pathname={pathname} />
        <p className="border-t px-4 py-3 text-[11px] text-muted-foreground">
          Final-year prototype · fictional data
        </p>
      </aside>

      {/* Main column */}
      <div className="flex min-w-0 flex-1 flex-col">
        {header}
        <main className="flex-1 bg-background">{children}</main>
      </div>
    </div>
  );
}
