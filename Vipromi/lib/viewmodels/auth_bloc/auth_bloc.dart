import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vipromi/models/user_data.dart';
import 'package:vipromi/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';


part 'auth_state.dart';

part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<SignUpEvent>(_onSignUp);
    on<SignInEvent>(_onSignIn);
    on<SignOutEvent>(_onSignOut);
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userCredential = await _authRepository.signUp(
        event.userData,
        event.password,
      );
      emit(AuthSuccess(userCredential.user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  FutureOr<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userCredential = await _authRepository.signIn(
        event.email,
        event.password,
      );
      emit(AuthSuccess(userCredential.user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  FutureOr<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
