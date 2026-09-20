import { describe, expect, it } from "vitest";
import { splitSqlStatements } from "@/lib/sql/splitter";

describe("splitSqlStatements", () => {
  it("splits simple statements on semicolons", () => {
    const sql = "create table a (id int);\ncreate table b (id int);";
    expect(splitSqlStatements(sql)).toEqual([
      "create table a (id int)",
      "create table b (id int)",
    ]);
  });

  it("does not split on semicolons inside single-quoted strings", () => {
    const sql = `insert into t values ('a;b;c');`;
    expect(splitSqlStatements(sql)).toEqual([`insert into t values ('a;b;c')`]);
  });

  it("handles escaped quotes ('') inside strings", () => {
    const sql = `insert into t values ('it''s; fine'); select 1;`;
    expect(splitSqlStatements(sql)).toEqual([
      `insert into t values ('it''s; fine')`,
      "select 1",
    ]);
  });

  it("does not split inside dollar-quoted bodies", () => {
    const sql = [
      "create or replace function f() returns trigger language plpgsql as $$",
      "begin",
      "  if new.status = 'X'; then null; end if; -- semicolon above must not split",
      "  perform something();",
      "  return new;",
      "end;",
      "$$;",
      "select 1;",
    ].join("\n");
    const statements = splitSqlStatements(sql);
    expect(statements).toHaveLength(2);
    expect(statements[0]).toContain("create or replace function f()");
    expect(statements[0]).toContain("return new");
    expect(statements[1]).toBe("select 1");
  });

  it("handles tagged dollar quotes ($body$)", () => {
    const sql = "create function g() returns int language plpgsql as $body$ begin return 1; end $body$;";
    expect(splitSqlStatements(sql)).toHaveLength(1);
  });

  it("handles nested dollar quotes with different tags", () => {
    const sql = `create function h() returns void as $outer$ begin perform f(); end $outer$; select 2;`;
    expect(splitSqlStatements(sql)).toHaveLength(2);
  });

  it("ignores semicolons in line comments", () => {
    const sql = "-- a comment with ; a semicolon\nselect 1;";
    expect(splitSqlStatements(sql)).toEqual(["-- a comment with ; a semicolon\nselect 1"]);
  });

  it("ignores semicolons in block comments", () => {
    const sql = "/* start ; middle ; end */ select 1;";
    expect(splitSqlStatements(sql)).toEqual(["/* start ; middle ; end */ select 1"]);
  });

  it("does not split inside double-quoted identifiers", () => {
    const sql = `select "col;name" from t; select 2;`;
    expect(splitSqlStatements(sql)).toEqual([`select "col;name" from t`, "select 2"]);
  });

  it("keeps a trailing statement without a semicolon", () => {
    expect(splitSqlStatements("select 1")).toEqual(["select 1"]);
  });

  it("drops empty statements", () => {
    expect(splitSqlStatements(";;;  ;\n;")).toEqual([]);
  });

  it("handles a realistic DO block from our migrations", () => {
    const sql = `do $$ begin
  create type public.user_role as enum ('PATIENT','DOCTOR');
exception when duplicate_object then null; end $$;

do $$ begin
  alter publication supabase_realtime add table public.appointments;
exception when duplicate_object then null; end $$;`;
    const statements = splitSqlStatements(sql);
    expect(statements).toHaveLength(2);
    expect(statements[0]).toContain("user_role");
    expect(statements[1]).toContain("supabase_realtime");
  });
});
