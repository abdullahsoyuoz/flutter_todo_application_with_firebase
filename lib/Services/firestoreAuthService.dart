import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/Services/sharedPreferences.dart';

class FirebaseAuthService {
  static FirebaseAuthService _service = FirebaseAuthService._internal();
  FirebaseAuthService._internal() {
    currentUser = FirebaseAuth.instance.currentUser;
  }
  factory FirebaseAuthService() => _service;

  static User currentUser;
  FirebaseAuth auth = FirebaseAuth.instance;

  static void dispose() async {
    FirebaseAuthService.dispose();
  }

  static Future<UserCredential> signUp(String email, String password) async {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  static Future<UserCredential> signIn(String email, String password) async {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      setPrefsEmailPassword(email, password);
      return value;
    });
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut().then((value) {
      resetPrefsEmailPassword();
      return value;
    });
    dispose();
  }

  //FirebaseAuthService
}

final firebaseAuthService = FirebaseAuthService();
