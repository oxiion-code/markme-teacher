import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:markme_teacher/core/models/teacher.dart';

abstract class AuthEvent extends Equatable{
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class CheckAuthStatus extends AuthEvent{

}
class LogoutRequested extends AuthEvent{

}

class SendOtpEvent extends AuthEvent{
  final String phoneNumber;
  const SendOtpEvent(this.phoneNumber);
  @override
  List<Object?> get props => [phoneNumber];
}

class VerifyOtpEvent extends AuthEvent{
  final String verificationId;
  final String otp;
  const VerifyOtpEvent(this.verificationId,this.otp);
  @override
  List<Object?> get props => [verificationId,otp];
}

class UpdateDataEvent extends AuthEvent {
  final Teacher teacher;
  final File? file;
  const UpdateDataEvent(this.teacher, this.file);

  @override
  List<Object?> get props => [teacher, file];
}
class SendUpdateOtpEvent extends AuthEvent {
  final String phoneNumber;
  const SendUpdateOtpEvent(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class VerifyAndUpdatePhoneNumberEvent extends AuthEvent {
  final String verificationId;
  final String otp;
  final String uid;
  final String newPhoneNumber;
  const VerifyAndUpdatePhoneNumberEvent(this.verificationId, this.otp, this.uid, this.newPhoneNumber);

  @override
  List<Object?> get props => [verificationId, otp , uid, newPhoneNumber];
}

