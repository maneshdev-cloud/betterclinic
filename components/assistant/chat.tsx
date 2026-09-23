"use client";

import { useEffect, useRef, useState } from "react";
import { Send, Stethoscope, User } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { cn } from "@/lib/utils";
import { sendAssistantMessageAction } from "@/services/assistant/actions";

interface ChatMessage {
  id: string;
  role: "USER" | "ASSISTANT";
  content: string;
  usedLlm?: boolean;
}

interface ChatProps {
  initialMessages: ChatMessage[];
  assistantMode: "llm" | "fallback";
  modelLabel: string;
}

const SUGGESTIONS = [
  "When is my next appointment?",
  "What medications am I taking?",
  "What are my allergies?",
  "When is my follow-up?",
];

/** Health assistant chat — replies come from a server action (LLM or deterministic fallback). */
export function AssistantChat({ initialMessages, assistantMode, modelLabel }: ChatProps) {
  const [messages, setMessages] = useState<ChatMessage[]>(initialMessages);
  const [input, setInput] = useState("");
  const [pending, setPending] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const listRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    listRef.current?.scrollTo({ top: listRef.current.scrollHeight });
  }, [messages]);

  const send = async (text: string) => {
    const trimmed = text.trim();
    if (trimmed.length < 2 || pending) return;
    setPending(true);
    setError(null);
    setInput("");
    setMessages((current) => [...current, { id: `local-${Date.now()}`, role: "USER", content: trimmed }]);

    const result = await sendAssistantMessageAction(trimmed);
    if (result.ok && result.data) {
      setMessages((current) => [
        ...current,
        {
          id: `reply-${Date.now()}`,
          role: "ASSISTANT",
          content: result.data!.reply,
          usedLlm: result.data!.usedLlm,
        },
      ]);
    } else {
      setError(result.error ?? "The assistant could not reply. Please try again.");
    }
    setPending(false);
  };

  return (
    <div className="flex h-[calc(100vh-16rem)] min-h-[420px] flex-col rounded-lg border bg-card">
      {/* Mode banner — honest about how replies are generated */}
      <div className="flex items-center justify-between gap-2 border-b px-4 py-2.5">
        <p className="inline-flex items-center gap-2 text-sm font-medium">
          <Stethoscope className="h-4 w-4 text-primary" aria-hidden /> Health assistant
        </p>
        <span
          className={cn(
            "rounded-full border px-2.5 py-0.5 text-xs font-medium",
            assistantMode === "llm"
              ? "border-emerald-200 bg-emerald-50 text-emerald-700"
              : "border-sky-200 bg-sky-50 text-sky-700"
          )}
        >
          {assistantMode === "llm" ? `LLM: ${modelLabel} · grounded in your records` : "Rule-based assistant · your records only"}
        </span>
      </div>

      <div ref={listRef} className="flex-1 space-y-3 overflow-y-auto p-4" aria-live="polite">
        {messages.length === 0 ? (
          <div className="flex h-full flex-col items-center justify-center gap-3 text-center">
            <p className="text-sm text-muted-foreground">
              Ask me about your appointments, medications, prescriptions, allergies, follow-ups or queue token.
            </p>
            <div className="flex flex-wrap justify-center gap-2">
              {SUGGESTIONS.map((suggestion) => (
                <button
                  key={suggestion}
                  type="button"
                  onClick={() => void send(suggestion)}
                  className="rounded-full border px-3 py-1.5 text-xs font-medium text-muted-foreground transition-colors hover:border-primary hover:text-foreground"
                >
                  {suggestion}
                </button>
              ))}
            </div>
          </div>
        ) : (
          messages.map((message) => (
            <div
              key={message.id}
              className={cn("flex gap-2.5", message.role === "USER" ? "justify-end" : "justify-start")}
            >
              {message.role === "ASSISTANT" ? (
                <span className="mt-1 flex h-7 w-7 shrink-0 items-center justify-center rounded-full bg-primary/10">
                  <Stethoscope className="h-3.5 w-3.5 text-primary" aria-hidden />
                </span>
              ) : null}
              <div
                className={cn(
                  "max-w-[80%] whitespace-pre-wrap rounded-2xl px-3.5 py-2.5 text-sm leading-relaxed",
                  message.role === "USER"
                    ? "rounded-br-sm bg-primary text-primary-foreground"
                    : "rounded-bl-sm border bg-muted/40"
                )}
              >
                {message.content}
              </div>
              {message.role === "USER" ? (
                <span className="mt-1 flex h-7 w-7 shrink-0 items-center justify-center rounded-full bg-muted">
                  <User className="h-3.5 w-3.5 text-muted-foreground" aria-hidden />
                </span>
              ) : null}
            </div>
          ))
        )}
        {pending ? (
          <div className="flex gap-2.5">
            <span className="mt-1 flex h-7 w-7 shrink-0 items-center justify-center rounded-full bg-primary/10">
              <Stethoscope className="h-3.5 w-3.5 text-primary" aria-hidden />
            </span>
            <div className="rounded-2xl rounded-bl-sm border bg-muted/40 px-3.5 py-2.5 text-sm text-muted-foreground">
              Checking your records…
            </div>
          </div>
        ) : null}
      </div>

      {error ? (
        <p className="border-t px-4 py-2 text-sm text-red-600" role="alert">
          {error}
        </p>
      ) : null}

      <div className="border-t p-3">
        <div className="flex items-end gap-2">
          <Textarea
            value={input}
            onChange={(event) => setInput(event.target.value)}
            onKeyDown={(event) => {
              if (event.key === "Enter" && !event.shiftKey) {
                event.preventDefault();
                void send(input);
              }
            }}
            placeholder="Ask about your appointments, medications, queue…"
            rows={2}
            maxLength={1000}
            disabled={pending}
            aria-label="Message the health assistant"
          />
          <Button onClick={() => void send(input)} disabled={pending || input.trim().length < 2}>
            <Send className="h-4 w-4" aria-hidden />
            <span className="sr-only">Send</span>
          </Button>
        </div>

        <div className="mt-2 flex flex-col gap-0.5 rounded border border-amber-200/60 bg-amber-50/50 px-2.5 py-1.5 text-xs text-amber-900/90 dark:border-amber-900/40 dark:bg-amber-950/20 dark:text-amber-200">
          <p className="font-medium">
            This is not medical advice — always consult your doctor for treatment decisions.
          </p>
          <p className="text-[11px] text-muted-foreground">
            Answers are grounded strictly in your clinic records. In a medical emergency, call 108 or 112 immediately.
          </p>
        </div>
      </div>
    </div>
  );
}
