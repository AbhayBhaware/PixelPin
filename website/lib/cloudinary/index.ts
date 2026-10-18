/**
 * Cloudinary URL transformer utilities
 * Uses URL-based transformations — no SDK calls needed on client
 */

const CLOUD_NAME = process.env.NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME!;

export function getThumbUrl(publicId: string, width = 400): string {
  return `https://res.cloudinary.com/${CLOUD_NAME}/image/upload/f_auto,q_auto,w_${width}/${publicId}`;
}

export function getPreviewUrl(publicId: string, width = 1080): string {
  return `https://res.cloudinary.com/${CLOUD_NAME}/image/upload/f_auto,q_auto,w_${width}/${publicId}`;
}

export function getOriginalUrl(publicId: string): string {
  return `https://res.cloudinary.com/${CLOUD_NAME}/image/upload/${publicId}`;
}

/**
 * Request a signed upload signature from our API route
 */
export async function getSignedUploadParams(folder = 'wallpapers') {
  const res = await fetch('/api/sign-upload', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ folder }),
  });
  if (!res.ok) throw new Error('Failed to get upload signature');
  return res.json();
}

/**
 * Upload file to Cloudinary with signed params
 */
export async function uploadToCloudinary(
  file: File,
  folder = 'wallpapers',
  onProgress?: (pct: number) => void
): Promise<{ publicId: string; url: string; width: number; height: number; bytes: number }> {
  const { signature, timestamp, apiKey, cloudName, uploadPreset } =
    await getSignedUploadParams(folder);

  const formData = new FormData();
  formData.append('file', file);
  formData.append('signature', signature);
  formData.append('timestamp', timestamp.toString());
  formData.append('api_key', apiKey);
  formData.append('upload_preset', uploadPreset);
  formData.append('folder', folder);

  return new Promise((resolve, reject) => {
    const xhr = new XMLHttpRequest();
    xhr.open(
      'POST',
      `https://api.cloudinary.com/v1_1/${cloudName}/image/upload`
    );
    xhr.upload.onprogress = (e) => {
      if (e.lengthComputable && onProgress) {
        onProgress(Math.round((e.loaded / e.total) * 100));
      }
    };
    xhr.onload = () => {
      if (xhr.status === 200) {
        const res = JSON.parse(xhr.responseText);
        resolve({
          publicId: res.public_id,
          url: res.secure_url,
          width: res.width,
          height: res.height,
          bytes: res.bytes,
        });
      } else {
        reject(new Error(`Upload failed: ${xhr.statusText}`));
      }
    };
    xhr.onerror = () => reject(new Error('Network error during upload'));
    xhr.send(formData);
  });
}
