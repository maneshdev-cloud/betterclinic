"use client";

import { useState } from "react";
import { ExternalLink, MapPin, Navigation } from "lucide-react";
import { Button } from "@/components/ui/button";

interface GoogleMapEmbedProps {
  query: string;
  title?: string;
  heightClass?: string;
  className?: string;
  showDirectionsButton?: boolean;
}

export function GoogleMapEmbed({
  query,
  title = "Location Map",
  heightClass = "h-64 sm:h-72",
  className = "",
  showDirectionsButton = true,
}: GoogleMapEmbedProps) {
  const [hasError, setHasError] = useState(false);
  const apiKey = process.env.NEXT_PUBLIC_MAPS_API_KEY;

  const encodedQuery = encodeURIComponent(query);
  const directMapsUrl = `https://www.google.com/maps/search/?api=1&query=${encodedQuery}`;
  const directionsUrl = `https://www.google.com/maps/dir/?api=1&destination=${encodedQuery}`;
  const embedUrl = apiKey
    ? `https://www.google.com/maps/embed/v1/place?key=${apiKey}&q=${encodedQuery}`
    : null;

  return (
    <div className={`overflow-hidden rounded-xl border border-border/80 bg-card shadow-sm ${className}`}>
      {embedUrl && !hasError ? (
        <div className="relative w-full">
          <iframe
            title={title}
            src={embedUrl}
            className={`w-full border-0 ${heightClass}`}
            loading="lazy"
            referrerPolicy="no-referrer-when-downgrade"
            allowFullScreen
            onError={() => setHasError(true)}
          />
        </div>
      ) : (
        <div className={`flex flex-col items-center justify-center p-6 text-center bg-muted/30 ${heightClass}`}>
          <div className="flex h-12 w-12 items-center justify-center rounded-full bg-primary/10 text-primary mb-3">
            <MapPin className="h-6 w-6" aria-hidden />
          </div>
          <p className="text-sm font-semibold text-foreground">{title}</p>
          <p className="text-xs text-muted-foreground mt-1 max-w-sm line-clamp-2">{query}</p>
          <div className="mt-4 flex gap-2">
            <Button size="sm" variant="outline" asChild>
              <a href={directMapsUrl} target="_blank" rel="noopener noreferrer">
                <ExternalLink className="mr-1.5 h-3.5 w-3.5" />
                Open in Google Maps
              </a>
            </Button>
          </div>
        </div>
      )}

      {showDirectionsButton && (
        <div className="flex flex-wrap items-center justify-between gap-2 border-t border-border/60 bg-muted/15 px-3.5 py-2.5 text-xs">
          <span className="truncate text-muted-foreground font-medium flex items-center gap-1.5">
            <MapPin className="h-3.5 w-3.5 text-primary shrink-0" />
            <span className="truncate">{query}</span>
          </span>
          <div className="flex items-center gap-2 shrink-0">
            <a
              href={directionsUrl}
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center gap-1 font-medium text-primary hover:underline"
            >
              <Navigation className="h-3 w-3" />
              Get Directions
            </a>
            <span className="text-muted-foreground/40">·</span>
            <a
              href={directMapsUrl}
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center gap-1 text-muted-foreground hover:text-foreground hover:underline"
            >
              <ExternalLink className="h-3 w-3" />
              Larger Map
            </a>
          </div>
        </div>
      )}
    </div>
  );
}
