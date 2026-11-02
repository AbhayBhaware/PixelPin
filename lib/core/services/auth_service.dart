import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:pixelpin/core/constants/app_constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Ensure user document exists in Firestore
        final userDocRef = _firestore.collection(AppConstants.usersCollection).doc(user.uid);
        final doc = await userDocRef.get();

        if (!doc.exists) {
          await userDocRef.set({
            'uid': user.uid,
            'email': user.email,
            'displayName': user.displayName ?? 'Wallpaper Artist',
            'photoUrl': user.photoURL,
            'role': 'viewer',
            'creatorApplicationStatus': 'none',
            'createdAt': FieldValue.serverTimestamp(),
            'lastLoginAt': FieldValue.serverTimestamp(),
          });
        } else {
          await userDocRef.update({
            'lastLoginAt': FieldValue.serverTimestamp(),
            if (user.photoURL != null) 'photoUrl': user.photoURL,
            if (user.displayName != null) 'displayName': user.displayName,
          });
        }
      }

      return userCredential;
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      rethrow;
    }
  }

  /// Sign Out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    }
  }

  /// Submit an application to become a creator
  Future<void> submitCreatorApplication({
    required String displayName,
    required String portfolioUrl,
    required String bio,
    required String artStyle,
  }) async {
    final user = currentUser;
    if (user == null) {
      throw Exception('You must be signed in to submit a creator application.');
    }

    final applicationData = {
      'userId': user.uid,
      'displayName': displayName.trim(),
      'email': user.email ?? '',
      'photoUrl': user.photoURL ?? '',
      'portfolioUrl': portfolioUrl.trim(),
      'bio': bio.trim(),
      'artStyle': artStyle.trim(),
      'status': AppConstants.statusPending,
      'appliedAt': FieldValue.serverTimestamp(),
      'reviewedAt': null,
      'rejectionReason': null,
    };

    // 1. Write or update creator application document
    await _firestore
        .collection(AppConstants.creatorApplicationsCollection)
        .doc(user.uid)
        .set(applicationData, SetOptions(merge: true));

    // 2. Update user profile document status
    await _firestore.collection(AppConstants.usersCollection).doc(user.uid).set({
      'creatorApplicationStatus': AppConstants.statusPending,
      'portfolioUrl': portfolioUrl.trim(),
      'artStyle': artStyle.trim(),
      'bio': bio.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Stream current creator application status for the current user
  Stream<Map<String, dynamic>?> streamCreatorApplication() {
    final user = currentUser;
    if (user == null) return Stream.value(null);

    return _firestore
        .collection(AppConstants.creatorApplicationsCollection)
        .doc(user.uid)
        .snapshots()
        .map((snapshot) => snapshot.data());
  }
}
