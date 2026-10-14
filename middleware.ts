import { createServerClient, type CookieOptions } from "@supabase/ssr";
import { NextResponse, type NextRequest } from "next/server";
import { env, isSupabaseConfigured } from "@/lib/env";
import { roleHomePath, type Role } from "@/lib/constants";

/**
 * Auth middleware:
 *  - skips getUser() entirely on public unauthenticated routes (landing page, etc.)
 *  - refreshes the Supabase session cookie on guarded/auth requests
 *  - guards role-prefixed areas (/patient, /doctor, /staff, /admin)
 *  - supports multi-role identity and session active role cookie
 *  - sets strict no-store cache-control headers on protected surfaces
 */

import { withRetry } from "@/lib/network/with-retry";

const ROLE_PREFIXES: { prefix: string; roles: Role[] }[] = [
  { prefix: "/patient", roles: ["PATIENT"] },
  { prefix: "/doctor", roles: ["DOCTOR"] },
  { prefix: "/staff", roles: ["RECEPTIONIST"] },
  { prefix: "/admin", roles: ["CLINIC_ADMIN"] },
];

const AUTH_PAGES = ["/login", "/signup", "/choose-role"];

export async function middleware(request: NextRequest) {
  let response = NextResponse.next({ request });

  const { pathname, search } = request.nextUrl;

  // Skip static assets, icons and favicon immediately
  if (
    pathname.includes("icon.svg") ||
    pathname.endsWith(".svg") ||
    pathname.endsWith(".ico") ||
    pathname.endsWith(".png") ||
    pathname.endsWith(".jpg")
  ) {
    return response;
  }

  const guarded = ROLE_PREFIXES.find(
    (r) => pathname === r.prefix || pathname.startsWith(`${r.prefix}/`)
  );
  const isAuthPage = AUTH_PAGES.some((p) => pathname === p || pathname.startsWith(`${p}/`));
  const isAccountPage = pathname === "/account" || pathname.startsWith("/account/");

  // Performance optimization: Skip auth check on unauthenticated public routes
  if (!guarded && !isAuthPage && !isAccountPage) {
    return response;
  }

  function applyNoStoreHeaders(res: NextResponse): NextResponse {
    res.headers.set("Cache-Control", "no-cache, must-revalidate");
    return res;
  }

  // 1. Check for Demo User Session
  const demoCookie = request.cookies.get("bc_demo_user");
  let demoUser: { role: Role; roles: Role[]; fullName?: string } | null = null;
  if (demoCookie?.value) {
    try {
      demoUser = JSON.parse(decodeURIComponent(demoCookie.value));
    } catch {
      try {
        demoUser = JSON.parse(demoCookie.value);
      } catch {}
    }
  }

  if (demoUser) {
    const activeCookieRole = request.cookies.get("bc_active_role")?.value as Role | undefined;
    const effectiveRole =
      activeCookieRole && demoUser.roles?.includes(activeCookieRole)
        ? activeCookieRole
        : demoUser.role || "PATIENT";

    if (isAuthPage) {
      if (pathname === "/choose-role") return applyNoStoreHeaders(response);
      const url = request.nextUrl.clone();
      url.pathname = roleHomePath(effectiveRole);
      url.search = "";
      return applyNoStoreHeaders(NextResponse.redirect(url));
    }

    if (guarded) {
      const hasAccess =
        guarded.roles.includes(effectiveRole) ||
        (demoUser.roles && demoUser.roles.some((r) => guarded.roles.includes(r)));
      if (!hasAccess) {
        const url = request.nextUrl.clone();
        url.pathname = roleHomePath(effectiveRole);
        url.search = "";
        return applyNoStoreHeaders(NextResponse.redirect(url));
      }
    }

    return applyNoStoreHeaders(response);
  }

  // 2. If Supabase is NOT configured and no demo session exists
  if (!isSupabaseConfigured()) {
    if (guarded || isAccountPage) {
      const url = request.nextUrl.clone();
      url.pathname = "/login";
      url.search = `?next=${encodeURIComponent(pathname + search)}`;
      return applyNoStoreHeaders(NextResponse.redirect(url));
    }
    return response;
  }

  const allCookies = request.cookies.getAll();
  const hasAuthCookie = allCookies.some(
    (c) => c.name.startsWith("sb-") && c.name.includes("-auth-token")
  );

  // Fast-path: Unauthenticated user trying to access a guarded route
  if (!hasAuthCookie) {
    if (guarded || isAccountPage) {
      const url = request.nextUrl.clone();
      url.pathname = "/login";
      url.search = `?next=${encodeURIComponent(pathname + search)}`;
      return NextResponse.redirect(url);
    }
    if (isAuthPage) {
      return response;
    }
  }

  // Fast-path for Next.js internal RSC navigations
  const isRscRequest = request.headers.get("rsc") === "1" || request.nextUrl.searchParams.has("_rsc");
  if (isRscRequest && (guarded || isAccountPage) && hasAuthCookie) {
    return response;
  }

  const supabase = createServerClient(env.supabaseUrl, env.supabaseAnonKey, {
    cookies: {
      getAll() {
        return request.cookies.getAll();
      },
      setAll(cookiesToSet: { name: string; value: string; options: CookieOptions }[]) {
        cookiesToSet.forEach(({ name, value }) => request.cookies.set(name, value));
        response = NextResponse.next({ request });
        cookiesToSet.forEach(({ name, value, options }) =>
          response.cookies.set(name, value, options)
        );
      },
    },
  });

  let user = null;
  try {
    const authPromise = supabase.auth.getUser();
    const timeoutPromise = new Promise<{ data: { user: null }; error: Error }>((_, reject) =>
      setTimeout(() => reject(new Error("Auth timeout")), 2000)
    );
    const { data } = await Promise.race([authPromise, timeoutPromise]);
    user = data.user;
  } catch {
    if (guarded || isAccountPage) {
      return response;
    }
  }

  if (!user) {
    if (guarded || isAccountPage) {
      const url = request.nextUrl.clone();
      url.pathname = "/login";
      url.search = `?next=${encodeURIComponent(pathname + search)}`;
      return applyNoStoreHeaders(NextResponse.redirect(url));
    }
    if (isAuthPage) {
      return applyNoStoreHeaders(response);
    }
    return response;
  }

  // Signed in — allow /choose-role, otherwise redirect away from login/signup
  if (isAuthPage) {
    if (pathname === "/choose-role") {
      return applyNoStoreHeaders(response);
    }
    const userRoles = (user.app_metadata?.roles as Role[] | undefined) ?? [];
    if (userRoles.length > 1) {
      const url = request.nextUrl.clone();
      url.pathname = "/choose-role";
      url.search = "";
      return applyNoStoreHeaders(NextResponse.redirect(url));
    }
    const role = (user.app_metadata?.role as Role | undefined) ?? "PATIENT";
    const url = request.nextUrl.clone();
    url.pathname = roleHomePath(role);
    url.search = "";
    return applyNoStoreHeaders(NextResponse.redirect(url));
  }

  // Signed in — enforce role prefixes
  if (guarded) {
    const userRoles = (user.app_metadata?.roles as Role[] | undefined) ?? [];
    const activeCookieRole = request.cookies.get("bc_active_role")?.value as Role | undefined;
    const defaultRole = (user.app_metadata?.role as Role | undefined) ?? "PATIENT";
    const effectiveRole =
      activeCookieRole && (userRoles.includes(activeCookieRole) || defaultRole === activeCookieRole)
        ? activeCookieRole
        : defaultRole;

    const hasAccess =
      guarded.roles.includes(effectiveRole) || userRoles.some((r) => guarded.roles.includes(r));

    if (!hasAccess) {
      const url = request.nextUrl.clone();
      url.pathname = roleHomePath(effectiveRole);
      url.search = "";
      return applyNoStoreHeaders(NextResponse.redirect(url));
    }
    return applyNoStoreHeaders(response);
  }

  return response;
}

export const config = {
  matcher: [
    "/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp|ico)$).*)",
  ],
};
