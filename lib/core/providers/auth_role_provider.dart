import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixelpin/core/constants/app_constants.dart';
import 'package:pixelpin/core/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

/// Current Firebase Auth User Stream
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

/// Current User Role Provider (streamed from Firestore user doc / claims)
final userRoleProvider = StreamProvider<String>((ref) {
  final authUser = ref.watch(authStateProvider).value;
  if (authUser == null) {
    return Stream.value('viewer');
  }

  return FirebaseFirestore.instance
      .collection(AppConstants.usersCollection)
      .doc(authUser.uid)
      .snapshots()
      .map((doc) {
        if (!doc.exists) return 'viewer';
        final data = doc.data();
        if (data == null) return 'viewer';
        final role = data['role'] as String?;
        return role ?? 'viewer';
      });
});

/// Whether the current user has approved creator status
final isCreatorProvider = Provider<bool>((ref) {
  final role = ref.watch(userRoleProvider).value ?? 'viewer';
  return role == 'creator' ||
      role == AppConstants.roleContributor ||
      role == AppConstants.roleAdmin;
});

/// Stream of current user's creator application document
final creatorApplicationProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  final authUser = ref.watch(authStateProvider).value;
  if (authUser == null) {
    return Stream.value(null);
  }

  return FirebaseFirestore.instance
      .collection(AppConstants.creatorApplicationsCollection)
      .doc(authUser.uid)
      .snapshots()
      .map((doc) => doc.data());
});
