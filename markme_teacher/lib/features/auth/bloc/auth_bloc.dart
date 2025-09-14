import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_teacher/core/utils/app_utils.dart';
import '../repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<CheckAuthStatus>(_checkAuthStatus);
    on<UpdateDataEvent>(_updateData);
    on<LogoutRequested>(_onLogoutRequest);
    on<SendUpdateOtpEvent>(_onSendUpdateOtp);
    on<VerifyAndUpdatePhoneNumberEvent>(_onVerifyAndUpdatePhoneNumber);
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await authRepository.sendOtp(phoneNumber: event.phoneNumber);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (verificationId) => emit(OtpSent(verificationId)),
    );
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await authRepository.verifyOtp(
      verificationId: event.verificationId,
      otp: event.otp,
    );

    await result.fold(
      (failure) async {
        emit(AuthError(failure.message));
      },
      (authInfo) async {
        final userDataResult = await authRepository.getUserdata(
          phoneNumber: authInfo.phoneNumber,
        );
        userDataResult.fold(
          (failure) {
            emit(AuthError("You are not registered."));
            add(LogoutRequested());
          },
          (teacher) {
            final isNewUser = teacher.profilePhotoUrl.trim().isEmpty;

            emit(
              AuthenticationSuccess(
                authInfo: authInfo,
                isNewUser: isNewUser,
                teacher: teacher,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _checkAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      emit(UnAuthenticated());
      return;
    }
    final result = await authRepository.getUserdata(
      phoneNumber: currentUser.phoneNumber!,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (adminUser) => emit(UserAlreadyLoggedIn(adminUser)),
    );
  }

  Future<void> _onLogoutRequest(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await authRepository.logout();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(LogoutSuccess()),
    );
  }

  FutureOr<void> _updateData(
    UpdateDataEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final currentDeviceId = await AppUtils.getCurrentDeviceToken();
    final updatedTeacher = event.teacher.copyWith(deviceToken: currentDeviceId);
    final result = await authRepository.updateTeacherData(
      teacher: updatedTeacher,
      profilePhoto: event.file,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (teacher) => emit(TeacherUpdateSuccess(teacher)),
    );
  }

  FutureOr<void> _onSendUpdateOtp(
    SendUpdateOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await authRepository.sendUpdateOtp(
      phoneNumber: event.phoneNumber,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (verificationId) => emit(UpdateOtpSent(verificationId)),
    );
  }

  FutureOr<void> _onVerifyAndUpdatePhoneNumber(
    VerifyAndUpdatePhoneNumberEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await authRepository.verifyAndUpdatePhoneNumber(
      verificationId: event.verificationId,
      otp: event.otp,
      uid: event.uid,
      newPhoneNumber: event.newPhoneNumber
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const PhoneNumberUpdated()),
    );
  }
}
