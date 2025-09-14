import 'package:equatable/equatable.dart';
import 'package:markme_teacher/core/models/teacher.dart';

import '../models/auth_info.dart';


abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OtpSent extends AuthState {
  final String verificationId;

  const OtpSent(this.verificationId);
  @override
  // TODO: implement props
  List<Object?> get props => [verificationId];
}

class AuthenticationSuccess extends AuthState {
  final AuthInfo authInfo;
  final bool isNewUser;
  final Teacher? teacher;
  const AuthenticationSuccess({required this.authInfo,required this.isNewUser,this.teacher});

  @override
  List<Object?> get props => [authInfo,isNewUser,teacher];
}

class UserAlreadyLoggedIn extends AuthState{
  final Teacher? teacher;
  const UserAlreadyLoggedIn(this.teacher);

  @override
  List<Object?> get props => [teacher];
}

class UnAuthenticated extends AuthState{

}
class AuthError extends AuthState {
  final String error;
  const AuthError(this.error);

  @override
  List<Object?> get props => [error];
}
class LogoutSuccess extends AuthState{

}

class TeacherUpdateSuccess extends AuthState{
  final Teacher teacher;
  const TeacherUpdateSuccess(this.teacher);
  @override
  List<Object?> get props => [teacher];
}

class UpdateOtpSent extends AuthState {
  final String verificationId;
  const UpdateOtpSent(this.verificationId);

  @override
  List<Object?> get props => [verificationId];
}

class PhoneNumberUpdated extends AuthState {
  const PhoneNumberUpdated();
}

