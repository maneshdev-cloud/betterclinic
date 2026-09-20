/**
 * Next.js searchParams values can be string | string[] | undefined.
 * Normalise to a plain string record so zod schemas can parse them.
 */
export function searchParamsToObject(
  searchParams: Record<string, string | string[] | undefined>
): Record<string, string> {
  const result: Record<string, string> = {};
  for (const [key, value] of Object.entries(searchParams)) {
    if (typeof value === "string") result[key] = value;
    else if (Array.isArray(value) && value.length > 0) result[key] = value[0]!;
  }
  return result;
}

/** Build a query string, skipping empty/default values so URLs stay clean. */
export function buildQueryString(params: Record<string, string | number | boolean | undefined>): string {
  const search = new URLSearchParams();
  for (const [key, value] of Object.entries(params)) {
    if (value === undefined || value === "" || value === false) continue;
    search.set(key, String(value));
  }
  const qs = search.toString();
  return qs ? `?${qs}` : "";
}
