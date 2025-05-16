import 'package:firebase_auth/firebase_auth.dart';
import 'package:talabat/models/user.model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<AppUser?> get user => _auth
      .authStateChanges()
      .map((user) => user != null ? AppUser.fromFirebaseUser(user) : null);

  Future<AppUser?> signUp(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return AppUser.fromFirebaseUser(cred.user!);
  }

  Future<AppUser?> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return AppUser.fromFirebaseUser(cred.user!);
  }

  Future<void> signOut() async => _auth.signOut();
}
