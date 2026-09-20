import fs from "node:fs";
import path from "node:path";

/**
 * Minimal .env loader for local scripts (migrations, seed, RLS tests).
 * Reads .env.local then .env — values already present in the real
 * environment are never overwritten.
 */
function loadEnvFile(file: string): void {
  if (!fs.existsSync(file)) return;
  const content = fs.readFileSync(file, "utf8");
  for (const rawLine of content.split(/\r?\n/)) {
    const line = rawLine.trim();
    if (!line || line.startsWith("#")) continue;
    const eq = line.indexOf("=");
    if (eq === -1) continue;
    const key = line.slice(0, eq).trim();
    if (!key) continue;
    let value = line.slice(eq + 1).trim();
    if (
      (value.startsWith('"') && value.endsWith('"') && value.length >= 2) ||
      (value.startsWith("'") && value.endsWith("'") && value.length >= 2)
    ) {
      value = value.slice(1, -1);
    }
    if (process.env[key] === undefined || process.env[key] === "") {
      process.env[key] = value;
    }
  }
}

export function loadLocalEnv(cwd = process.cwd()): void {
  loadEnvFile(path.join(cwd, ".env.local"));
  loadEnvFile(path.join(cwd, ".env"));
}

export function requireEnv(name: string): string {
  const value = process.env[name];
  if (!value) {
    console.error(
      `Missing ${name}. Add it to .env.local (see .env.example for where to find each value).`
    );
    process.exit(1);
  }
  return value;
}
