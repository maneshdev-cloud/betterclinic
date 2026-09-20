import type { Metadata } from "next";
import Link from "next/link";
import { PageHeader } from "@/components/shared/page-header";
import { AssistantChat } from "@/components/assistant/chat";
import { createClient } from "@/lib/supabase/server";
import { requireRole } from "@/services/auth/service";
import { getOrCreateConversation, listMessages } from "@/services/assistant/service";
import { getUserPreferences } from "@/services/preferences/service";
import { isAiConfigured } from "@/lib/env";
import { env } from "@/lib/env";
import { DISCLAIMER } from "@/lib/assistant/fallback";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { BotOff, Settings } from "lucide-react";

export const metadata: Metadata = { title: "Health assistant" };

export default async function PatientAssistantPage() {
  const user = await requireRole(["PATIENT"], "/patient/assistant");
  const supabase = await createClient();

  const preferences = await getUserPreferences(supabase, user.id);

  if (!preferences.aiAssistantEnabled) {
    return (
      <div className="page-container space-y-6 py-8">
        <PageHeader
          title="Health assistant"
          description="Ask about your appointments, medications, prescriptions, allergies, follow-ups and queue token — answers come from your own records."
        />
        <Card className="border-dashed">
          <CardContent className="flex flex-col items-center justify-center p-8 text-center">
            <div className="flex h-12 w-12 items-center justify-center rounded-full bg-muted text-muted-foreground">
              <BotOff className="h-6 w-6" aria-hidden />
            </div>
            <h2 className="mt-4 text-base font-semibold">Health Assistant is disabled</h2>
            <p className="mt-1.5 max-w-md text-sm text-muted-foreground">
              You disabled the AI health assistant in your preferences. You can turn it back on at any time to resume asking questions about your records.
            </p>
            <Button asChild className="mt-6" variant="outline">
              <Link href="/patient/settings">
                <Settings className="mr-2 h-4 w-4" />
                Go to Preferences
              </Link>
            </Button>
          </CardContent>
        </Card>
      </div>
    );
  }

  const conversationId = await getOrCreateConversation(supabase, user.id);
  const messages = await listMessages(supabase, conversationId);

  return (
    <div className="page-container space-y-6 py-8">
      <PageHeader
        title="Health assistant"
        description="Ask about your appointments, medications, prescriptions, allergies, follow-ups and queue token — answers come from your own records."
      />
      <AssistantChat
        initialMessages={messages.map((message) => ({
          id: message.id,
          role: message.role,
          content: message.content,
          usedLlm: message.usedLlm,
        }))}
        assistantMode={isAiConfigured() ? "llm" : "fallback"}
        modelLabel={isAiConfigured() ? env.ai.model : ""}
      />
      <p className="text-xs text-muted-foreground">{DISCLAIMER}</p>
    </div>
  );
}
