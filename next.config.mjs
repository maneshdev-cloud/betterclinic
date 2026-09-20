/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  experimental: {
    staleTimes: {
      dynamic: 0,
    },
  },
  images: {
    remotePatterns: [
      {
        protocol: "https",
        hostname: "*.supabase.co",
        pathname: "/storage/v1/object/public/**",
      },
    ],
  },
  async headers() {
    const noStoreHeaders = [
      { key: "Cache-Control", value: "no-store, must-revalidate" },
      { key: "Pragma", value: "no-cache" },
      { key: "Expires", value: "0" },
    ];
    return [
      {
        source: "/:path(login|signup|choose-role|patient|doctor|staff|admin)",
        headers: noStoreHeaders,
      },
      {
        source: "/:path(login|signup|choose-role|patient|doctor|staff|admin)/:subpath*",
        headers: noStoreHeaders,
      },
    ];
  },
};

export default nextConfig;
