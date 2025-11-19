import 'package:firebase_auth/firebase_auth.dart';

class auth {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentuser => _firebaseAuth.currentUser;

  Stream<User?> get authStatechanges => _firebaseAuth.authStateChanges();

  //sign in service

  Future<void> signInWithemailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //registration service
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //signout
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
