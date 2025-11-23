import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChange => _auth.authStateChanges();

  Future<AppUser?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('✅ User signed in: ${userCredential.user!.uid}');
      return await _getOrCreateUser(userCredential.user!);
    } catch (e) {
      print('❌ Sign in error: $e');
      rethrow;
    }
  }

  Future<AppUser?> registerWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('✅ User created in Auth: ${userCredential.user!.uid}');

      // Create user object
      final user = AppUser(
        id: userCredential.user!.uid,
        email: email,
        displayName: displayName,
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      await _firestore.collection('users').doc(user.id).set(user.toMap());

      print('✅ User saved to Firestore: ${user.id}');
      return user;
    } catch (e) {
      print('❌ Registration error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('✅ User signed out successfully');
    } catch (e) {
      print('❌ Sign out error: $e');
      rethrow;
    }
  }

  Future<AppUser?> _getOrCreateUser(User firebaseUser) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (doc.exists) {
        print('✅ User found in Firestore: ${firebaseUser.uid}');
        return AppUser.fromMap(doc.data()!);
      } else {
        print('⚠️ User not found in Firestore, creating new user...');
        // Create user document if it doesn't exist
        final newUser = AppUser(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? 'User',
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(newUser.id)
            .set(newUser.toMap());
        print('✅ New user created in Firestore: ${newUser.id}');
        return newUser;
      }
    } catch (e) {
      print('❌ Error getting/creating user: $e');
      return null;
    }
  }

  Stream<AppUser?> getUserStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
          if (snapshot.exists) {
            print('📱 User stream updated: ${snapshot.data()}');
            return AppUser.fromMap(snapshot.data()!);
          }
          print('📱 User stream: no data for user $userId');
          return null;
        })
        .handleError((error) {
          print('❌ User stream error: $error');
          return null;
        });
  }

  Future<void> updateUser(AppUser user) async {
    await _firestore.collection('users').doc(user.id).update(user.toMap());
    print('✅ User updated: ${user.id}');
  }

  // Debug method to check current state
  Future<void> debugCheckUser() async {
    final currentUser = _auth.currentUser;
    print('🔍 Debug - Current Auth User: ${currentUser?.uid}');

    if (currentUser != null) {
      final userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();
      print('🔍 Debug - User in Firestore: ${userDoc.exists}');
      if (userDoc.exists) {
        print('🔍 Debug - User data: ${userDoc.data()}');
      }
    }
  }
}
