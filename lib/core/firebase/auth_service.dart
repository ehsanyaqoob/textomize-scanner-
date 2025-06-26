import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  // Singleton instance
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔑 Sign Up with Email & Password
  Future<UserCredential> signUp(String email, String password) async {
    try {
      debugPrint('Attempting to sign up user with email: $email');
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('✅ User signed up: ${userCredential.user?.uid}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ SignUp Error (${e.code}): ${e.message}');
      throw AuthException(e.code, e.message ?? 'An error occurred during sign up');
    } catch (e) {
      debugPrint('❌ Unexpected error in signUp: $e');
      throw AuthException('unknown-error', 'An unexpected error occurred');
    }
  }

  // ✅ Save User Data to Firestore
  Future<void> saveUserToFirestore({
    required String uid,
    required String name,
    required String phone,
    required String email,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      debugPrint('📤 Saving user data to Firestore for UID: $uid');
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'phone': phone,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        if (additionalData != null) ...additionalData,
      });
      debugPrint('✅ Firestore user data saved');
    } catch (e) {
      debugPrint('❌ Error saving user data: $e');
      throw AuthException('firestore-save-failed', 'Failed to save user data');
    }
  }

  // 🔁 Sign Up and Save Firestore User
  Future<UserCredential> signUpAndSaveUser({
    required String email,
    required String password,
    required String name,
    required String phone,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      debugPrint('🔄 Starting complete sign up process for: $email');
      final userCredential = await signUp(email, password);

      if (userCredential.user == null) {
        throw AuthException('no-user', 'User creation failed - no user returned');
      }

      await saveUserToFirestore(
        uid: userCredential.user!.uid,
        name: name,
        phone: phone,
        email: email,
        additionalData: additionalData,
      );

      debugPrint('✅ Sign up + Firestore save completed');
      return userCredential;
    } catch (e) {
      debugPrint('❌ Error in signUpAndSaveUser: $e');
      rethrow;
    }
  }

  // 🔑 Sign In with Email & Password
  Future<UserCredential> signIn(String email, String password) async {
    try {
      debugPrint('🔐 Signing in user: $email');
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user?.emailVerified == false) {
        throw AuthException('email-not-verified', 'Please verify your email before signing in');
      }

      debugPrint('✅ User signed in: ${userCredential.user?.uid}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ SignIn Error (${e.code}): ${e.message}');
      throw AuthException(e.code, e.message ?? 'Authentication failed');
    } catch (e) {
      debugPrint('❌ Unexpected error in signIn: $e');
      throw AuthException('unknown-error', 'An unexpected error occurred');
    }
  }

  // 🔒 Sign Out
  Future<void> signOut() async {
    try {
      debugPrint('🚪 Signing out user');
      await _auth.signOut();
      debugPrint('✅ User signed out');
    } catch (e) {
      debugPrint('❌ Error signing out: $e');
      throw AuthException('signout-failed', 'Failed to sign out');
    }
  }

  // 👤 Get Current User
  User? getCurrentUser() {
    final user = _auth.currentUser;
    debugPrint('👤 Current user: ${user?.uid}');
    return user;
  }

  // 📧 Send Email Verification
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        debugPrint('📧 Sending verification to: ${user.email}');
        await user.sendEmailVerification();
        debugPrint('✅ Email verification sent');
      }
    } catch (e) {
      debugPrint('❌ Verification email error: $e');
      throw AuthException('verification-failed', 'Failed to send verification email');
    }
  }

  // 🔑 Reset Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      debugPrint('🔁 Sending password reset to: $email');
      await _auth.sendPasswordResetEmail(email: email);
      debugPrint('✅ Password reset email sent');
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Password reset error (${e.code}): ${e.message}');
      throw AuthException(e.code, e.message ?? 'Failed to send reset email');
    }
  }

  // 🗑 Delete Account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        debugPrint('🗑 Deleting user: ${user.uid}');
        await user.delete();
        debugPrint('✅ User account deleted');
      }
    } catch (e) {
      debugPrint('❌ Delete account error: $e');
      throw AuthException('delete-failed', 'Failed to delete account');
    }
  }

  // 🔒 Listen to auth state changes
  Stream<User?> authStateChanges() {
    debugPrint('🔍 Listening to auth state changes');
    return _auth.authStateChanges();
  }

  // 🔍 Fetch all users from Firestore
  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    try {
      debugPrint('📥 Fetching all users from Firestore...');
      final querySnapshot = await _firestore.collection('users').get();

      final users = querySnapshot.docs.map((doc) {
        return {
          'uid': doc.id,
          ...doc.data(),
        };
      }).toList();

      debugPrint('✅ Fetched ${users.length} users');
      return users;
    } catch (e) {
      debugPrint('❌ Error fetching users: $e');
      throw AuthException('fetch-users-failed', 'Failed to fetch users');
    }
  }
}

// ✅ Custom Auth Exception
class AuthException implements Exception {
  final String code;
  final String message;
  AuthException(this.code, this.message);

  @override
  String toString() => 'AuthException(code: $code, message: $message)';
}
