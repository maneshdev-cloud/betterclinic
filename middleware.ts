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

const ROLE_PREFIXES: { prefix: string; roles: Role[] }[] = [
  { prefix: "/patient", roles: ["PATIENT"] },
  { prefix: "/doctor", roles: ["DOCTOR"] },
  { prefix: "/staff", roles: ["RECEPTIONIST"] },
  { prefix: "/admin", roles: ["CLINIC_ADMIN"] },
];

const AUTH_PAGES = ["/login", "/signup", "/choose-role"];

export async function middleware(request: NextRequest) {
  let response = NextResponse.next({ request });

  if (!isSupabaseConfigured()) return response;

  const { pathname, search } = request.nextUrl;

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
    res.headers.set("Cache-Control", "no-store, must-revalidate");
    res.headers.set("Pragma", "no-cache");
    res.headers.set("Expires", "0");
    return res;
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

  const {
    data: { user },
  } = await supabase.auth.getUser();

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
