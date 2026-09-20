import type { LucideIcon } from "lucide-react";
import {
  BarChart3,
  Bot,
  Building2,
  CalendarCheck,
  CalendarDays,
  CalendarClock,
  ClipboardList,
  Clock,
  FileText,
  LayoutDashboard,
  Pill,
  Search,
  Settings,
  ScrollText,
  Siren,
  Stethoscope,
  Radio,
  Users,
  Bell,
} from "lucide-react";

export interface NavItem {
  label: string;
  href: string;
  icon: LucideIcon;
}

export interface NavSection {
  title: string;
  items: NavItem[];
}

export const PATIENT_NAV: NavSection[] = [
  {
    title: "Overview",
    items: [{ label: "Home", href: "/patient", icon: LayoutDashboard }],
  },
  {
    title: "Discover",
    items: [
      { label: "Find doctors", href: "/patient/doctors", icon: Search },
      { label: "Clinics", href: "/patient/clinics", icon: Building2 },
    ],
  },
  {
    title: "My care",
    items: [
      { label: "Appointments", href: "/patient/appointments", icon: CalendarDays },
      { label: "Live queue", href: "/patient/queue", icon: Clock },
      { label: "Prescriptions", href: "/patient/prescriptions", icon: ClipboardList },
      { label: "Medications", href: "/patient/medications", icon: Pill },
      { label: "Medical records", href: "/patient/records", icon: FileText },
      { label: "Follow-ups", href: "/patient/follow-ups", icon: CalendarClock },
    ],
  },
  {
    title: "Support",
    items: [
      { label: "Health assistant", href: "/patient/assistant", icon: Bot },
      { label: "Emergency (demo)", href: "/patient/emergency", icon: Siren },
    ],
  },
  {
    title: "Account",
    items: [{ label: "Notifications", href: "/patient/notifications", icon: Bell }, { label: "Settings", href: "/patient/settings", icon: Settings }],
  },
];

export const DOCTOR_NAV: NavSection[] = [
  {
    title: "Overview",
    items: [{ label: "Dashboard", href: "/doctor", icon: LayoutDashboard }],
  },
  {
    title: "Clinic",
    items: [
      { label: "My queue", href: "/doctor/queue", icon: Clock },
      { label: "Consultations", href: "/doctor/consultations", icon: Stethoscope },
      { label: "My patients", href: "/doctor/patients", icon: Users },
      { label: "Availability", href: "/doctor/availability", icon: CalendarCheck },
    ],
  },
  {
    title: "Account",
    items: [{ label: "Notifications", href: "/doctor/notifications", icon: Bell }, { label: "Settings", href: "/doctor/settings", icon: Settings }],
  },
];

export const STAFF_NAV: NavSection[] = [
  {
    title: "Operations",
    items: [
      { label: "Dashboard", href: "/staff", icon: LayoutDashboard },
      { label: "Live queue", href: "/staff/queue", icon: Radio },
      { label: "Appointments", href: "/staff/appointments", icon: CalendarDays },
    ],
  },
  {
    title: "Account",
    items: [{ label: "Notifications", href: "/staff/notifications", icon: Bell }, { label: "Settings", href: "/staff/settings", icon: Settings }],
  },
];

export const ADMIN_NAV: NavSection[] = [
  {
    title: "Clinic",
    items: [
      { label: "Overview", href: "/admin", icon: LayoutDashboard },
      { label: "Analytics", href: "/admin/analytics", icon: BarChart3 },
      { label: "Audit log", href: "/admin/audit", icon: ScrollText },
      { label: "Doctors", href: "/admin/doctors", icon: Stethoscope },
      { label: "Staff", href: "/admin/staff", icon: Users },
    ],
  },
  {
    title: "Account",
    items: [{ label: "Notifications", href: "/admin/notifications", icon: Bell }, { label: "Settings", href: "/admin/settings", icon: Settings }],
  },
];
