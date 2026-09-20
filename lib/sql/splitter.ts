/**
 * Splits a .sql file into individual executable statements.
 * Correctly handles:
 *   - single-quoted strings (with '' escapes)
 *   - double-quoted identifiers
 *   - line comments (`--`) and block comments (`/* * /`)
 *   - dollar-quoted bodies (`$$ ... $$`, `$fn$ ... $fn$`)
 *   - semicolons inside any of the above are NOT statement separators
 */
export function splitSqlStatements(sql: string): string[] {
  const statements: string[] = [];
  let current = "";
  let i = 0;

  let inSingleQuote = false;
  let inDoubleQuote = false;
  let inLineComment = false;
  let inBlockComment = false;
  let dollarTag: string | null = null;

  while (i < sql.length) {
    const ch = sql[i]!;
    const next = sql[i + 1] ?? "";

    if (inLineComment) {
      if (ch === "\n") inLineComment = false;
      current += ch;
      i += 1;
      continue;
    }
    if (inBlockComment) {
      if (ch === "*" && next === "/") {
        inBlockComment = false;
        current += "*/";
        i += 2;
        continue;
      }
      current += ch;
      i += 1;
      continue;
    }
    if (dollarTag !== null) {
      if (sql.startsWith(dollarTag, i)) {
        current += dollarTag;
        i += dollarTag.length;
        dollarTag = null;
        continue;
      }
      current += ch;
      i += 1;
      continue;
    }
    if (inSingleQuote) {
      if (ch === "'") {
        if (next === "'") {
          current += "''";
          i += 2;
          continue;
        }
        inSingleQuote = false;
      }
      current += ch;
      i += 1;
      continue;
    }
    if (inDoubleQuote) {
      if (ch === '"') inDoubleQuote = false;
      current += ch;
      i += 1;
      continue;
    }

    if (ch === "-" && next === "-") {
      inLineComment = true;
      current += "--";
      i += 2;
      continue;
    }
    if (ch === "/" && next === "*") {
      inBlockComment = true;
      current += "/*";
      i += 2;
      continue;
    }
    if (ch === "$") {
      const match = /^\$[A-Za-z_0-9]*\$/.exec(sql.slice(i));
      if (match) {
        dollarTag = match[0];
        current += match[0];
        i += match[0].length;
        continue;
      }
    }
    if (ch === "'") {
      inSingleQuote = true;
      current += ch;
      i += 1;
      continue;
    }
    if (ch === '"') {
      inDoubleQuote = true;
      current += ch;
      i += 1;
      continue;
    }
    if (ch === ";") {
      const trimmed = current.trim();
      if (trimmed.length > 0) statements.push(trimmed);
      current = "";
      i += 1;
      continue;
    }
    current += ch;
    i += 1;
  }

  const trimmed = current.trim();
  if (trimmed.length > 0) statements.push(trimmed);
  return statements;
}
