import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:markme_teacher/core/error/failure.dart';
import 'package:markme_teacher/core/models/teacher.dart';
import 'package:markme_teacher/features/auth/models/auth_info.dart';
import 'package:markme_teacher/features/auth/repository/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  FirebaseAuth firebaseAuth;
  FirebaseFirestore firestore;
  FirebaseStorage storage;

  AuthRepositoryImpl(this.firebaseAuth, this.firestore, this.storage);

  @override
  Future<Either<AppFailure, Teacher>> getUserdata({
    required String phoneNumber,
  }) async {
    try {
      final querySnapshot = await firestore
          .collection("teachers")
          .where("phoneNumber", isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return Left(AppFailure(message: "Phone number is not registered"));
      }

      final doc = querySnapshot.docs.first;
      final data = doc.data();
      final user = Teacher.fromMap(data);
      final deviceToken = await FirebaseMessaging.instance.getToken();

      if (deviceToken != null && data["deviceToken"] != deviceToken) {
        await firestore.collection("teachers").doc(doc.id).update({
          "deviceToken": deviceToken,
        });
      }
      final updatedUser = user.copyWith(
        deviceToken: deviceToken ?? user.deviceToken,
      );
      return Right(updatedUser);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> logout() async {
    try {
      await firebaseAuth.signOut();
      return Right(null);
    } catch (e) {
      return Left(AppFailure(message: "Logout failed:${e.toString()}"));
    }
  }

  // send otp

  @override
  Future<Either<AppFailure, String>> sendOtp({
    required String phoneNumber,
  }) async {
    try {
      final completer = Completer<Either<AppFailure, String>>();

      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await firebaseAuth.signInWithCredential(credential);
            // Auto verification can be handled if needed.
          } catch (e) {
            // Ignore or log this; main focus is manual verification
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          completer.complete(
            Left(AppFailure(message: e.message ?? "OTP send failed")),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          completer.complete(Right(verificationId));
        },
        codeAutoRetrievalTimeout: (_) {},
        timeout: const Duration(seconds: 60),
      );

      return completer.future;
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  //verify the otp

  @override
  Future<Either<AppFailure, AuthInfo>> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await firebaseAuth.signInWithCredential(credential);
      if (firebaseAuth.currentUser == null) {
        return Left(AppFailure(message: "No current user"));
      }
      final uid = firebaseAuth.currentUser!.uid;
      final phoneNumber = firebaseAuth.currentUser!.phoneNumber;
      return Right(AuthInfo(uid: uid, phoneNumber: phoneNumber!));
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Teacher>> updateTeacherData({
    required Teacher teacher,
    File? profilePhoto,
  }) async {
    try {
      String? downloadUrl;
      if (profilePhoto != null) {
        downloadUrl = await uploadProfileImage(profilePhoto, teacher.teacherId);
      }

      final updatedTeacher = teacher.copyWith(
        profilePhotoUrl: downloadUrl ?? teacher.profilePhotoUrl,
      );
      await firestore
          .collection("teachers")
          .doc(updatedTeacher.teacherId)
          .set(updatedTeacher.toMap());
      return Right(updatedTeacher);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  Future<String> uploadProfileImage(File file, String id) async {
    try {
      final ref = storage.ref().child("teacher_profiles").child("$id.jpg");

      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      throw Exception("Image upload failed: $e");
    }
  }

  @override
  Future<Either<AppFailure, String>> sendUpdateOtp({
    required String phoneNumber,
  }) async {
    try {
      final completer = Completer<Either<AppFailure, String>>();

      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            // Do not sign in here; just keep it for auto-retrieval
          } catch (_) {}
        },
        verificationFailed: (FirebaseAuthException e) {
          completer.complete(
            Left(AppFailure(message: e.message ?? "OTP send failed")),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          completer.complete(Right(verificationId));
        },
        codeAutoRetrievalTimeout: (_) {},
        timeout: const Duration(seconds: 60),
      );

      return completer.future;
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> verifyAndUpdatePhoneNumber({
    required String verificationId,
    required String otp,
    required String uid,
    required String newPhoneNumber
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        return Left(AppFailure(message: "No current user logged in"));
      }

      // Update phone number for the signed-in user
      await currentUser.updatePhoneNumber(credential);
      debugPrint(uid);
      // Also update in Firestore
      await firestore
          .collection("teachers")
          .doc(uid)
          .update({"phoneNumber":newPhoneNumber});

      return const Right(null);
    } catch (e) {
      return Left(AppFailure(message: "Phone update failed: $e"));
    }
  }
}
