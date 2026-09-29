"use client";

import Link from "next/link";
import { useState, useTransition } from "react";
import * as DropdownMenu from "@radix-ui/react-dropdown-menu";
import { Check, ChevronDown, Loader2, LogOut, Plus, RefreshCw, Settings, User } from "lucide-react";
import { UserAvatar } from "@/components/shared/user-avatar";
import { ROLE_LABELS, roleHomePath, type Role } from "@/lib/constants";
import { signOutAction, switchRoleAction } from "@/app/(auth)/actions";
import { useNavigationProgress } from "@/components/layout/navigation-progress";
import { cn } from "@/lib/utils";

interface UserMenuProps {
  name: string;
  email: string;
  role: Role;
  avatarUrl?: string | null;
  settingsHref: string;
  availableRoles?: Role[];
}

const itemClass =
  "flex cursor-pointer select-none items-center gap-2 rounded-sm px-2 py-1.5 text-sm outline-none transition-colors focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50";

export function UserMenu({
  name,
  email,
  role,
  avatarUrl,
  settingsHref,
  availableRoles = [],
}: UserMenuProps) {
  const [pending, startTransition] = useTransition();
  const [switchingRole, setSwitchingRole] = useState<Role | null>(null);
  const [signingOut, setSigningOut] = useState(false);
  const { startNavigation, stopNavigation } = useNavigationProgress();

  return (
    <DropdownMenu.Root>
      <DropdownMenu.Trigger
        className={cn(
          "flex items-center gap-2 rounded-md border border-transparent px-2 py-1.5 text-sm font-medium transition-colors hover:bg-muted focus:outline-none focus-visible:ring-2 focus-visible:ring-ring",
          pending && "opacity-60"
        )}
        aria-label="Account menu"
      >
        <UserAvatar name={name} src={avatarUrl} size="sm" />
        <span className="hidden max-w-[140px] truncate sm:block">{name}</span>
        <ChevronDown className="h-4 w-4 text-muted-foreground" aria-hidden />
      </DropdownMenu.Trigger>
      <DropdownMenu.Portal>
        <DropdownMenu.Content
          sideOffset={6}
          align="end"
          className="z-50 min-w-[220px] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md"
        >
          <div className="px-2 py-2">
            <p className="truncate text-sm font-medium">{name}</p>
            <p className="truncate text-xs text-muted-foreground">{email}</p>
            <div className="mt-1 flex items-center gap-1.5">
              <span className="rounded bg-primary/10 px-1.5 py-0.5 text-[10px] font-semibold text-primary">
                {ROLE_LABELS[role]}
              </span>
              {availableRoles.length > 1 ? (
                <span className="text-[10px] text-muted-foreground">
                  ({availableRoles.length} roles)
                </span>
              ) : null}
            </div>
          </div>

          {availableRoles.length > 1 ? (
            <>
              <DropdownMenu.Separator className="my-1 h-px bg-muted" />
              <div className="px-2 py-1 text-[11px] font-semibold uppercase tracking-wider text-muted-foreground">
                Switch Workspace
              </div>
              {availableRoles.map((r) => {
                const isActive = r === role;
                const isSelected = switchingRole === r;
                return (
                  <DropdownMenu.Item
                    key={r}
                    disabled={isActive || pending}
                    className={cn(
                      itemClass,
                      isActive ? "bg-accent/40 font-medium" : "hover:bg-accent",
                      isSelected && "bg-primary/10 text-primary font-medium"
                    )}
                    onSelect={(e) => {
                      if (isActive || pending) {
                        e.preventDefault();
                        return;
                      }
                      setSwitchingRole(r);
                      startNavigation(roleHomePath(r));
                      startTransition(async () => {
                        try {
                          await switchRoleAction(r);
                        } catch (err: any) {
                          if (err?.digest?.startsWith("NEXT_REDIRECT") || err?.message === "NEXT_REDIRECT") {
                            return;
                          }
                          setSwitchingRole(null);
                          stopNavigation();
                        }
                      });
                    }}
                  >
                    {isSelected ? (
                      <Loader2 className="h-3.5 w-3.5 animate-spin text-primary" />
                    ) : (
                      <RefreshCw className={cn("h-3.5 w-3.5", isActive && "text-primary")} />
                    )}
                    <span className="flex-1">{ROLE_LABELS[r]}</span>
                    {isSelected ? (
                      <span className="text-[10px] text-primary font-medium animate-pulse">Switching…</span>
                    ) : isActive ? (
                      <Check className="h-3.5 w-3.5 text-primary" />
                    ) : null}
                  </DropdownMenu.Item>
                );
              })}
            </>
          ) : null}

          <DropdownMenu.Separator className="my-1 h-px bg-muted" />
          <DropdownMenu.Item asChild>
            <Link href={settingsHref} className={itemClass}>
              <Settings className="h-4 w-4" aria-hidden /> Settings
            </Link>
          </DropdownMenu.Item>
          <DropdownMenu.Item asChild>
            <Link href={settingsHref} className={itemClass}>
              <User className="h-4 w-4" aria-hidden /> Profile
            </Link>
          </DropdownMenu.Item>
          <DropdownMenu.Item asChild>
            <Link href="/account/add-role" className={itemClass}>
              <Plus className="h-4 w-4 text-muted-foreground" aria-hidden /> Add another role
            </Link>
          </DropdownMenu.Item>
          <DropdownMenu.Separator className="my-1 h-px bg-muted" />
          <DropdownMenu.Item
            disabled={pending || signingOut}
            className={cn(itemClass, "text-destructive focus:bg-destructive/10 focus:text-destructive")}
            onSelect={(event) => {
              event.preventDefault();
              setSigningOut(true);
              startNavigation("/");
              startTransition(async () => {
                try {
                  await signOutAction();
                } finally {
                  window.location.replace("/");
                }
              });
            }}
          >
            {signingOut ? (
              <Loader2 className="h-4 w-4 animate-spin text-destructive" aria-hidden />
            ) : (
              <LogOut className="h-4 w-4" aria-hidden />
            )}
            <span>{signingOut ? "Signing out…" : "Sign out"}</span>
          </DropdownMenu.Item>
        </DropdownMenu.Content>
      </DropdownMenu.Portal>
    </DropdownMenu.Root>
  );
}
