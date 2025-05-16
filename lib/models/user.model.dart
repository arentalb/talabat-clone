import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String uid;
  final String email;

  AppUser({required this.uid, required this.email});

  factory AppUser.fromFirebaseUser(User user) =>
      AppUser(uid: user.uid, email: user.email ?? '');
}
