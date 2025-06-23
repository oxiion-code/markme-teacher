part of 'auth_bloc.dart';

abstract class AuthState extends Equatable{
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState{}
class AuthLoading extends AuthState{}
class AuthSuccess extends AuthState{
  final User? user;
  const AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}
class AuthError extends AuthState{
  final String error;
  const AuthError(this.error);

  @override
  List<Object?> get props => [error];
}