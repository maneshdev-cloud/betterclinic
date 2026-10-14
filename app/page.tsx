import type { Metadata } from "next";
import { isSupabaseConfigured } from "@/lib/env";
import { LandingView } from "@/components/landing/landing-view";

export const metadata: Metadata = {
  title: "Better Clinic — Smart Digital Healthcare Platform",
  description:
    "Intelligent healthcare platform connecting patient discovery, slot booking, live token queues, and structured clinical records.",
};

export default function HomePage() {
  const configured = isSupabaseConfigured();

  return <LandingView isConfigured={configured} />;
}
