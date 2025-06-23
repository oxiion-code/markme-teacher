
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vipromi/models/user_data.dart';

class FirebaseAuthService{
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  Future<UserCredential> signUp({required UserData userData,required String password}){
    return _firebaseAuth.createUserWithEmailAndPassword(email: userData.email, password: password);
  }
  Future<UserCredential> signIn({required String email, required String password}){
    return _firebaseAuth.signInWithEmailAndPassword(email: email, password:password);
  }

  Future <void> signOut(){
    return _firebaseAuth.signOut();
  }
  User? get currentUser => _firebaseAuth.currentUser;

  Future <void> sendEmailVerification() async{
    final user=_firebaseAuth.currentUser;
    if(user !=null && !user.emailVerified){
      await user.sendEmailVerification();
    }
  }
  Future<void> sendPasswordResetEmail(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}