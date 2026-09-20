export function FieldError({ error }: { error?: string | null }) {
  if (!error) return null;
  return <p className="text-xs text-destructive mt-1">{error}</p>;
}
