import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vipromi/services/firebase_auth_service.dart';

import '../models/user_data.dart';

class AuthRepository{
  AuthRepository(this._firebaseAuthService,this._firestore);
  final FirebaseAuthService _firebaseAuthService;
  final FirebaseFirestore _firestore;

  Future<UserCredential> signUp(UserData userdata,String password) async {
    final userCredential = await _firebaseAuthService.signUp(userData: userdata, password: password);

    await _firestore.collection('users').doc(userCredential.user!.uid).set(userdata.toMap());
    return userCredential;
  }

  Future<UserCredential> signIn(String email,String password){
    return _firebaseAuthService.signIn(email: email, password: password);
  }

  Future<void> signOut(){
    return _firebaseAuthService.signOut();
  }

  User? getCurrentUser(){
    return _firebaseAuthService.currentUser;
  }

  Future<UserData?> getUserData(String uid) async {
    final snapshot= await _firestore.collection('users').doc(uid).get();
    if(snapshot.exists){
      return UserData.fromMap(snapshot.data()!);
    }
    return null;
  }
}