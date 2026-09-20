import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { avatarTone, cn, initials } from "@/lib/utils";

const TONE_CLASSES: Record<string, string> = {
  teal: "bg-teal-100 text-teal-800",
  blue: "bg-sky-100 text-sky-800",
  amber: "bg-amber-100 text-amber-800",
  rose: "bg-rose-100 text-rose-800",
  slate: "bg-slate-200 text-slate-700",
  indigo: "bg-indigo-100 text-indigo-800",
};

interface UserAvatarProps {
  name: string | null | undefined;
  src?: string | null;
  size?: "sm" | "md" | "lg";
  className?: string;
}

/**
 * Deterministic initials avatar (no external image service required).
 * Falls back from the uploaded photo to a tone-coloured initial chip.
 */
export function UserAvatar({ name, src, size = "md", className }: UserAvatarProps) {
  const label = name ?? "?";
  const tone = TONE_CLASSES[avatarTone(label)] ?? TONE_CLASSES.slate;
  const sizeClass = size === "sm" ? "h-7 w-7 text-xs" : size === "lg" ? "h-12 w-12 text-base" : "h-9 w-9 text-sm";

  return (
    <Avatar className={cn(sizeClass, className)}>
      {src ? <AvatarImage src={src} alt={name ?? "User"} /> : null}
      <AvatarFallback className={cn(tone, "font-medium")} delayMs={src ? 300 : 0}>
        {initials(label)}
      </AvatarFallback>
    </Avatar>
  );
}
