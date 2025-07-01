import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart' as AppUser;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentFirebaseUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> registerUser(
    String username,
    String email,
    String mobile,
    List<String> interests,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      await _db.collection('users').doc(result.user!.uid).set({
        'username': username,
        'email': email,
        'mobile': mobile,
        'interests': interests,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<AppUser.User?> getCurrentUser() async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) return null;

      DocumentSnapshot userDoc = await _db.collection('users').doc(firebaseUser.uid).get();
      
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        return AppUser.User(
          id: firebaseUser.uid,
          username: data['username'] ?? '',
          email: data['email'] ?? firebaseUser.email ?? '',
          mobile: data['mobile'] ?? '',
          interests: List<String>.from(data['interests'] ?? []),
        );
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  bool isLoggedIn() {
    return _auth.currentUser != null;
  }
}