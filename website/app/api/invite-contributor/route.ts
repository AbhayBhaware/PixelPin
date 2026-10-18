import { NextResponse } from 'next/server';
import { adminAuth, adminDb } from '@/lib/firebase/admin';
import { cookies } from 'next/headers';
import { FieldValue } from 'firebase-admin/firestore';

export async function POST(request: Request) {
  try {
    // Only admin can invite
    const cookieStore = await cookies();
    const idToken = cookieStore.get('__session')?.value;

    if (!idToken) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const decodedToken = await adminAuth.verifyIdToken(idToken);
    if (!decodedToken.admin) {
      return NextResponse.json({ error: 'Forbidden' }, { status: 403 });
    }

    const { email, name } = await request.json();
    if (!email || !name) {
      return NextResponse.json(
        { error: 'Email and name are required' },
        { status: 400 }
      );
    }

    // Create or get user by email
    let user;
    try {
      user = await adminAuth.getUserByEmail(email);
    } catch {
      // User doesn't exist yet — create a placeholder
      user = await adminAuth.createUser({
        email,
        displayName: name,
        emailVerified: false,
      });
    }

    // Set contributor custom claim
    await adminAuth.setCustomUserClaims(user.uid, { contributor: true });

    // Create/update user doc
    await adminDb.collection('users').doc(user.uid).set(
      {
        uid: user.uid,
        name,
        email,
        role: 'contributor',
        status: 'active',
        createdAt: FieldValue.serverTimestamp(),
        invitedBy: decodedToken.uid,
        invitedAt: FieldValue.serverTimestamp(),
      },
      { merge: true }
    );

    // TODO: Send invite email via SendGrid/Resend/Firebase Dynamic Link
    // await sendInviteEmail(email, name);

    return NextResponse.json({
      success: true,
      uid: user.uid,
      message: `Contributor ${name} (${email}) invited successfully.`,
    });
  } catch (err) {
    console.error('invite-contributor error:', err);
    return NextResponse.json({ error: 'Server error' }, { status: 500 });
  }
}
