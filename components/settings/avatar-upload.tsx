"use client";

import { useRef, useState } from "react";
import { useRouter } from "next/navigation";
import { Camera, Loader2, Trash2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { UserAvatar } from "@/components/shared/user-avatar";
import { setAvatarUrlAction } from "@/services/users/actions";
import { AppError } from "@/lib/errors";

/**
 * Avatar upload wired to the public "avatars" storage bucket (migration
 * 00004): each user writes only inside their own folder, ≤ 1 MB, image
 * types only. The public URL is stored on profiles.avatar_url via a
 * server action that only accepts URLs from this bucket.
 */
const MAX_BYTES = 1024 * 1024;
const ALLOWED_TYPES = ["image/png", "image/jpeg", "image/webp"];

export function AvatarUpload({
  userId,
  name,
  currentUrl,
}: {
  userId: string;
  name: string;
  currentUrl: string | null;
}) {
  const [uploading, setUploading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const inputRef = useRef<HTMLInputElement>(null);
  const router = useRouter();

  const upload = async (file: File) => {
    setError(null);
    if (!ALLOWED_TYPES.includes(file.type)) {
      setError("Please choose a PNG, JPEG or WebP image.");
      return;
    }
    if (file.size > MAX_BYTES) {
      setError("Image is larger than 1 MB — please pick a smaller one.");
      return;
    }

    setUploading(true);
    try {
      const { createClient } = await import("@/lib/supabase/client");
      const supabase = createClient();
      const extension = file.type === "image/png" ? "png" : file.type === "image/webp" ? "webp" : "jpg";
      const path = `${userId}/avatar-${Date.now()}.${extension}`;
      const { error: uploadError } = await supabase.storage
        .from("avatars")
        .upload(path, file, { upsert: true, contentType: file.type });
      if (uploadError) throw uploadError;

      const { data } = supabase.storage.from("avatars").getPublicUrl(path);
      const result = await setAvatarUrlAction(data.publicUrl);
      if (!result.ok) {
        setError(result.error ?? "Could not save the avatar.");
      } else {
        router.refresh();
      }
    } catch (err) {
      setError(
        err instanceof AppError && err.code === "SUPABASE_NOT_CONFIGURED"
          ? "Avatar upload needs a configured Supabase project (see .env.local)."
          : "Upload failed — please try again."
      );
    } finally {
      setUploading(false);
      if (inputRef.current) inputRef.current.value = "";
    }
  };

  const remove = async () => {
    setUploading(true);
    setError(null);
    try {
      const result = await setAvatarUrlAction("");
      if (!result.ok) setError(result.error ?? "Could not remove the avatar.");
      else router.refresh();
    } finally {
      setUploading(false);
    }
  };

  return (
    <div className="flex flex-col items-center gap-3 sm:flex-row sm:items-center sm:gap-4">
      <UserAvatar name={name} src={currentUrl} size="lg" />
      <div className="flex flex-col items-center gap-2 sm:items-start">
        <div className="flex gap-2">
          <Button
            type="button"
            variant="outline"
            size="sm"
            disabled={uploading}
            onClick={() => inputRef.current?.click()}
          >
            {uploading ? (
              <Loader2 className="mr-1.5 h-3.5 w-3.5 animate-spin" aria-hidden />
            ) : (
              <Camera className="mr-1.5 h-3.5 w-3.5" aria-hidden />
            )}
            {currentUrl ? "Change photo" : "Upload photo"}
          </Button>
          {currentUrl ? (
            <Button type="button" variant="ghost" size="sm" disabled={uploading} onClick={() => void remove()}>
              <Trash2 className="mr-1.5 h-3.5 w-3.5" aria-hidden />
              Remove
            </Button>
          ) : null}
        </div>
        <p className="text-xs text-muted-foreground">PNG, JPEG or WebP · up to 1 MB</p>
        {error ? (
          <p className="text-xs text-red-600" role="alert">
            {error}
          </p>
        ) : null}
        <input
          ref={inputRef}
          type="file"
          accept="image/png,image/jpeg,image/webp"
          className="hidden"
          aria-label="Choose an avatar image"
          onChange={(event) => {
            const file = event.target.files?.[0];
            if (file) void upload(file);
          }}
        />
      </div>
    </div>
  );
}
