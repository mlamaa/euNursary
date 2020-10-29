import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

abstract class BaseAuth {
  Future<FirebaseUser> currentUser();
  Future<String> signIn(String email, String password);
  Future<String> createUser(String email, String password);
  Future<void> signOut();
  Future<String> getEmail();
  Future<bool> isEmailVerified();
  Future<void> resetPassword(String email);
  Future<void> sendEmailVerification();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  
Future deleteUser(String email, String password) async {
    try {
      FirebaseApp app = await FirebaseApp.configure(
        name: 'Secondary', options: await FirebaseApp.instance.options);
        AuthCredential credentials =
          EmailAuthProvider.getCredential(email: email, password: password);
      FirebaseAuth.fromApp(app).signInWithCredential(credentials);
      FirebaseAuth.fromApp(app).currentUser().then((value) => value.delete());
      await _firebaseAuth.currentUser().then((value) => print(value.email));
      // FirebaseUser user = await _firebaseAuth.
      // AuthCredential credentials =
      //     EmailAuthProvider.getCredential(email: email, password: password);
      // AuthResult result = await user.reauthenticateWithCredential(credentials);
      // await DatabaseService(uid: result.user.uid).deleteuser(); // called from database class
      // await result.user.delete();
      // return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<FirebaseUser> register(String email, String password) async {
    FirebaseApp app = await FirebaseApp.configure(
        name: 'Secondary', options: await FirebaseApp.instance.options);
    return FirebaseAuth.fromApp(app)
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<String> signIn(String email, String password) async {

    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<String> createUser(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<FirebaseUser> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
//    print("uid ${user.uid}");
    return user;
  }

  Future<String> getEmail() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.email;
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<void> resetPassword(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.sendEmailVerification();
  }
}
