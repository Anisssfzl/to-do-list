import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register user with email and password
  Future<User?> register(String email, String password) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      rethrow;
    }
  }

  // Login user with email and password
  Future<User?> login(String email, String password) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      rethrow;
    }
  }

  // Logout user
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Get current user
  User? get currentUser => _auth.currentUser;
}
