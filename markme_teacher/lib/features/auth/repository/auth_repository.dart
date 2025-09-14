import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:markme_teacher/core/error/failure.dart';
import 'package:markme_teacher/core/models/teacher.dart';


import '../models/auth_info.dart';

abstract class AuthRepository {
  Future<Either<AppFailure, String>> sendOtp({
    required String phoneNumber,
  });

  Future<Either<AppFailure, AuthInfo>> verifyOtp({
    required String verificationId,
    required String otp,
  });

  Future<Either<AppFailure, String>> sendUpdateOtp({
    required String phoneNumber,
  });

  Future<Either<AppFailure, void>> verifyAndUpdatePhoneNumber({
    required String verificationId,
    required String otp,
    required String uid,
    required String newPhoneNumber
  });

  Future<Either<AppFailure, Teacher>> getUserdata({
    required String phoneNumber,
  });

  Future<Either<AppFailure, Teacher>> updateTeacherData({
    required Teacher teacher,
    File? profilePhoto,
  });

  Future<Either<AppFailure, void>> logout();
}
