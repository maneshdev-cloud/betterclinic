"use client";

import { useState, useTransition } from "react";
import { toast } from "sonner";
import {
  Sun,
  Moon,
  Laptop,
  Bell,
  Volume2,
  VolumeX,
  Shield,
  Bot,
  CheckCircle2,
  Loader2,
} from "lucide-react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Switch } from "@/components/ui/switch";
import { Label } from "@/components/ui/label";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";
import type { Role } from "@/lib/constants";
import type { UserPreferences } from "@/services/preferences/service";
import { updateUserPreferencesAction } from "@/services/preferences/actions";

interface PreferencesFormProps {
  initialPreferences: UserPreferences;
  role: Role;
}

export function PreferencesForm({ initialPreferences, role }: PreferencesFormProps) {
  const [prefs, setPrefs] = useState<UserPreferences>(initialPreferences);
  const [isPending, startTransition] = useTransition();

  const applyThemeToDom = (theme: "system" | "light" | "dark") => {
    const isDark =
      theme === "dark" ||
      (theme === "system" && window.matchMedia("(prefers-color-scheme: dark)").matches);
    if (isDark) {
      document.documentElement.classList.add("dark");
    } else {
      document.documentElement.classList.remove("dark");
    }
  };

  const handleUpdate = (updates: Partial<Omit<UserPreferences, "userId">>) => {
    const updated = { ...prefs, ...updates };
    setPrefs(updated);

    if (updates.theme) {
      applyThemeToDom(updates.theme);
    }

    startTransition(async () => {
      const res = await updateUserPreferencesAction(updates);
      if (res.ok) {
        toast.success("Preferences updated");
      } else {
        toast.error(res.error ?? "Failed to save preference");
        // Rollback
        setPrefs(prefs);
      }
    });
  };

  return (
    <div className="space-y-6">
      {/* 1. Theme Preferences */}
      <Card>
        <CardHeader>
          <div className="flex items-center gap-2">
            <Sun className="h-5 w-5 text-primary" />
            <CardTitle>Appearance & Theme</CardTitle>
          </div>
          <CardDescription>
            Choose your preferred color theme. Changes take effect immediately and are saved across devices.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-3 gap-3 max-w-md">
            <button
              type="button"
              onClick={() => handleUpdate({ theme: "light" })}
              disabled={isPending}
              className={cn(
                "flex flex-col items-center gap-2 rounded-lg border-2 p-4 text-center transition-all hover:bg-muted/50",
                prefs.theme === "light"
                  ? "border-primary bg-primary/5 font-semibold text-primary"
                  : "border-border text-muted-foreground"
              )}
            >
              <Sun className="h-6 w-6" />
              <span className="text-xs">Light</span>
            </button>

            <button
              type="button"
              onClick={() => handleUpdate({ theme: "dark" })}
              disabled={isPending}
              className={cn(
                "flex flex-col items-center gap-2 rounded-lg border-2 p-4 text-center transition-all hover:bg-muted/50",
                prefs.theme === "dark"
                  ? "border-primary bg-primary/5 font-semibold text-primary"
                  : "border-border text-muted-foreground"
              )}
            >
              <Moon className="h-6 w-6" />
              <span className="text-xs">Dark</span>
            </button>

            <button
              type="button"
              onClick={() => handleUpdate({ theme: "system" })}
              disabled={isPending}
              className={cn(
                "flex flex-col items-center gap-2 rounded-lg border-2 p-4 text-center transition-all hover:bg-muted/50",
                prefs.theme === "system"
                  ? "border-primary bg-primary/5 font-semibold text-primary"
                  : "border-border text-muted-foreground"
              )}
            >
              <Laptop className="h-6 w-6" />
              <span className="text-xs">System</span>
            </button>
          </div>
        </CardContent>
      </Card>

      {/* 2. Notification Preferences */}
      <Card>
        <CardHeader>
          <div className="flex items-center gap-2">
            <Bell className="h-5 w-5 text-primary" />
            <CardTitle>Notification Categories</CardTitle>
          </div>
          <CardDescription>
            Configure which updates generate in-app notifications for your account. When disabled, the server will not produce notifications for that category.
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="flex items-center justify-between gap-4 rounded-lg border p-3">
            <div className="space-y-0.5">
              <div className="flex items-center gap-2">
                {prefs.soundEnabled ? (
                  <Volume2 className="h-4 w-4 text-primary" />
                ) : (
                  <VolumeX className="h-4 w-4 text-muted-foreground" />
                )}
                <Label htmlFor="sound_enabled" className="text-sm font-medium">
                  Live alert sound chime
                </Label>
              </div>
              <p className="text-xs text-muted-foreground">
                Play an audible chime in your browser when a new notification arrives in real-time.
              </p>
            </div>
            <Switch
              id="sound_enabled"
              checked={prefs.soundEnabled}
              onCheckedChange={(checked) => handleUpdate({ soundEnabled: checked })}
              disabled={isPending}
            />
          </div>

          <div className="flex items-center justify-between gap-4 rounded-lg border p-3">
            <div className="space-y-0.5">
              <Label htmlFor="notify_appointments" className="text-sm font-medium">
                Appointment updates
              </Label>
              <p className="text-xs text-muted-foreground">
                Confirmations, cancellations, rescheduling, and doctor notices.
              </p>
            </div>
            <Switch
              id="notify_appointments"
              checked={prefs.notifyAppointments}
              onCheckedChange={(checked) => handleUpdate({ notifyAppointments: checked })}
              disabled={isPending}
            />
          </div>

          <div className="flex items-center justify-between gap-4 rounded-lg border p-3">
            <div className="space-y-0.5">
              <Label htmlFor="notify_queue" className="text-sm font-medium">
                Live queue alerts
              </Label>
              <p className="text-xs text-muted-foreground">
                When your token is called or the waiting queue advances.
              </p>
            </div>
            <Switch
              id="notify_queue"
              checked={prefs.notifyQueue}
              onCheckedChange={(checked) => handleUpdate({ notifyQueue: checked })}
              disabled={isPending}
            />
          </div>

          <div className="flex items-center justify-between gap-4 rounded-lg border p-3">
            <div className="space-y-0.5">
              <Label htmlFor="notify_prescriptions" className="text-sm font-medium">
                Prescriptions &amp; consultations
              </Label>
              <p className="text-xs text-muted-foreground">
                Digital prescriptions issued and completed consultation summaries.
              </p>
            </div>
            <Switch
              id="notify_prescriptions"
              checked={prefs.notifyPrescriptions}
              onCheckedChange={(checked) => handleUpdate({ notifyPrescriptions: checked })}
              disabled={isPending}
            />
          </div>

          <div className="flex items-center justify-between gap-4 rounded-lg border p-3">
            <div className="space-y-0.5">
              <Label htmlFor="notify_followups" className="text-sm font-medium">
                Follow-up visit reminders
              </Label>
              <p className="text-xs text-muted-foreground">
                Notifications when a scheduled clinic follow-up date approaches.
              </p>
            </div>
            <Switch
              id="notify_followups"
              checked={prefs.notifyFollowups}
              onCheckedChange={(checked) => handleUpdate({ notifyFollowups: checked })}
              disabled={isPending}
            />
          </div>

          <div className="flex items-center justify-between gap-4 rounded-lg border p-3">
            <div className="space-y-0.5">
              <Label htmlFor="notify_reminders" className="text-sm font-medium">
                Medication schedule reminders
              </Label>
              <p className="text-xs text-muted-foreground">
                Scheduled dose intake reminders for active prescriptions.
              </p>
            </div>
            <Switch
              id="notify_reminders"
              checked={prefs.notifyReminders}
              onCheckedChange={(checked) => handleUpdate({ notifyReminders: checked })}
              disabled={isPending}
            />
          </div>
        </CardContent>
      </Card>

      {/* 3. Visibility & Privacy Controls */}
      <Card>
        <CardHeader>
          <div className="flex items-center gap-2">
            <Shield className="h-5 w-5 text-primary" />
            <CardTitle>Visibility &amp; Privacy</CardTitle>
          </div>
          <CardDescription>
            Control how your health profile and public contributions are displayed across Better Clinic.
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          {role === "PATIENT" ? (
            <>
              <div className="flex items-center justify-between gap-4 rounded-lg border p-3">
                <div className="space-y-0.5">
                  <Label htmlFor="anonymous_reviews" className="text-sm font-medium">
                    Anonymous reviews
                  </Label>
                  <p className="text-xs text-muted-foreground">
                    When enabled, doctor and clinic reviews you write are attributed as &ldquo;Verified Patient&rdquo; instead of showing your full name.
                  </p>
                </div>
                <Switch
                  id="anonymous_reviews"
                  checked={prefs.anonymousReviews}
                  onCheckedChange={(checked) => handleUpdate({ anonymousReviews: checked })}
                  disabled={isPending}
                />
              </div>

              <div className="flex items-center justify-between gap-4 rounded-lg border p-3">
                <div className="space-y-0.5">
                  <Label htmlFor="show_emergency_contact" className="text-sm font-medium">
                    Emergency contact accessibility
                  </Label>
                  <p className="text-xs text-muted-foreground">
                    Allow attending doctors and clinic receptionists to see your designated emergency contact phone number during care.
                  </p>
                </div>
                <Switch
                  id="show_emergency_contact"
                  checked={prefs.showEmergencyContact}
                  onCheckedChange={(checked) => handleUpdate({ showEmergencyContact: checked })}
                  disabled={isPending}
                />
              </div>
            </>
          ) : null}

          {role === "DOCTOR" ? (
            <div className="flex items-center justify-between gap-4 rounded-lg border p-3">
              <div className="space-y-0.5">
                <Label htmlFor="public_fee" className="text-sm font-medium">
                  Public consultation fee
                </Label>
                <p className="text-xs text-muted-foreground">
                  Display your exact consultation fee on public doctor search results. When disabled, shows &ldquo;Consultation fee available at clinic&rdquo;.
                </p>
              </div>
              <Switch
                id="public_fee"
                checked={prefs.publicFee}
                onCheckedChange={(checked) => handleUpdate({ publicFee: checked })}
                disabled={isPending}
              />
            </div>
          ) : null}

          {role !== "PATIENT" && role !== "DOCTOR" ? (
            <p className="text-xs text-muted-foreground">
              No role-specific privacy overrides for staff accounts.
            </p>
          ) : null}
        </CardContent>
      </Card>

      {/* 4. AI Assistant Preferences */}
      <Card>
        <CardHeader>
          <div className="flex items-center gap-2">
            <Bot className="h-5 w-5 text-primary" />
            <CardTitle>Health Assistant Preferences</CardTitle>
          </div>
          <CardDescription>
            Customize your interaction with the clinical record health assistant.
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="flex items-center justify-between gap-4 rounded-lg border p-3">
            <div className="space-y-0.5">
              <Label htmlFor="ai_assistant_enabled" className="text-sm font-medium">
                Health assistant enabled
              </Label>
              <p className="text-xs text-muted-foreground">
                Provide answers from your appointments, prescriptions, and queue status.
              </p>
            </div>
            <Switch
              id="ai_assistant_enabled"
              checked={prefs.aiAssistantEnabled}
              onCheckedChange={(checked) => handleUpdate({ aiAssistantEnabled: checked })}
              disabled={isPending}
            />
          </div>

          <div className="space-y-2 rounded-lg border p-3">
            <Label className="text-sm font-medium">Response detail level</Label>
            <p className="text-xs text-muted-foreground">
              Tune whether the assistant provides brief action items or detailed clinical explanations.
            </p>
            <div className="grid grid-cols-2 gap-2 pt-2">
              <button
                type="button"
                onClick={() => handleUpdate({ aiResponseLength: "concise" })}
                disabled={isPending || !prefs.aiAssistantEnabled}
                className={cn(
                  "rounded-md border p-2.5 text-xs font-medium text-center transition-all",
                  prefs.aiResponseLength === "concise"
                    ? "border-primary bg-primary/10 text-primary font-semibold"
                    : "border-border text-muted-foreground hover:bg-muted/50",
                  !prefs.aiAssistantEnabled && "opacity-50 cursor-not-allowed"
                )}
              >
                Concise (Quick answers)
              </button>
              <button
                type="button"
                onClick={() => handleUpdate({ aiResponseLength: "detailed" })}
                disabled={isPending || !prefs.aiAssistantEnabled}
                className={cn(
                  "rounded-md border p-2.5 text-xs font-medium text-center transition-all",
                  prefs.aiResponseLength === "detailed"
                    ? "border-primary bg-primary/10 text-primary font-semibold"
                    : "border-border text-muted-foreground hover:bg-muted/50",
                  !prefs.aiAssistantEnabled && "opacity-50 cursor-not-allowed"
                )}
              >
                Detailed (In-depth guidance)
              </button>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
