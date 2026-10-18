import { NextResponse } from 'next/server';
import { v2 as cloudinary } from 'cloudinary';
import { adminAuth } from '@/lib/firebase/admin';
import { cookies } from 'next/headers';

cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

export async function POST(request: Request) {
  try {
    // Verify the caller is a contributor or admin
    const cookieStore = await cookies();
    const idToken = cookieStore.get('__session')?.value;

    if (!idToken) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const decodedToken = await adminAuth.verifyIdToken(idToken);
    const isContributor =
      decodedToken.contributor === true || decodedToken.admin === true;

    if (!isContributor) {
      return NextResponse.json({ error: 'Forbidden' }, { status: 403 });
    }

    const { folder = 'wallpapers' } = await request.json();

    const timestamp = Math.round(Date.now() / 1000);
    const uploadPreset = process.env.CLOUDINARY_UPLOAD_PRESET!;
    const paramsToSign = { timestamp, folder, upload_preset: uploadPreset };

    const signature = cloudinary.utils.api_sign_request(
      paramsToSign,
      process.env.CLOUDINARY_API_SECRET!
    );

    return NextResponse.json({
      signature,
      timestamp,
      apiKey: process.env.CLOUDINARY_API_KEY,
      cloudName: process.env.CLOUDINARY_CLOUD_NAME,
      uploadPreset,
      folder,
    });
  } catch (err) {
    console.error('sign-upload error:', err);
    return NextResponse.json({ error: 'Server error' }, { status: 500 });
  }
}
