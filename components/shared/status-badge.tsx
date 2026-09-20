import { Badge } from "@/components/ui/badge";
import {
  APPOINTMENT_STATUS_LABELS,
  QUEUE_STATUS_LABELS,
  PRIORITY_LABELS,
  type AppointmentStatus,
  type QueueStatus,
  type Priority,
} from "@/lib/constants";

type Tone = "default" | "success" | "warning" | "info" | "destructive" | "muted" | "secondary";

/** Status conveyed by text AND colour (accessibility requirement). */

const APPOINTMENT_TONES: Record<AppointmentStatus, Tone> = {
  BOOKED: "info",
  CONFIRMED: "info",
  CHECKED_IN: "secondary",
  WAITING: "warning",
  CALLED: "warning",
  IN_CONSULTATION: "secondary",
  COMPLETED: "success",
  CANCELLED: "muted",
  NO_SHOW: "destructive",
};

export function AppointmentStatusBadge({ status }: { status: AppointmentStatus }) {
  return <Badge variant={APPOINTMENT_TONES[status]}>{APPOINTMENT_STATUS_LABELS[status]}</Badge>;
}

const QUEUE_TONES: Record<QueueStatus, Tone> = {
  WAITING: "warning",
  CALLED: "info",
  IN_CONSULTATION: "secondary",
  COMPLETED: "success",
  SKIPPED: "destructive",
  CANCELLED: "muted",
};

export function QueueStatusBadge({ status }: { status: QueueStatus }) {
  return <Badge variant={QUEUE_TONES[status]}>{QUEUE_STATUS_LABELS[status]}</Badge>;
}

const PRIORITY_TONES: Record<Priority, Tone> = { NORMAL: "muted", HIGH: "warning", URGENT: "destructive" };

export function PriorityBadge({ priority }: { priority: Priority }) {
  if (priority === "NORMAL") return null;
  return <Badge variant={PRIORITY_TONES[priority]}>{PRIORITY_LABELS[priority]}</Badge>;
}
