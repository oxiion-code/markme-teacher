part of 'auth_bloc.dart';


abstract class AuthEvent extends Equatable{
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class SignUpEvent extends AuthEvent{
  final UserData userData;
  final String password;
  const SignUpEvent({required this.userData,required this.password});

  @override
  List<Object?> get props => [userData,password];
}

class SignInEvent extends AuthEvent{
  final String email;
  final String password;
  const SignInEvent({required this.email, required this.password});
  @override
  List<Object?> get props => [email,password];
}

class SignOutEvent extends AuthEvent{

}