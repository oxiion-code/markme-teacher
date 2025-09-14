import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_teacher/features/attendance/bloc/attendance_event.dart';
import 'package:markme_teacher/features/attendance/bloc/attendance_state.dart';
import 'package:markme_teacher/features/attendance/repositories/attendance_repository.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceRepository attendanceRepository;
  AttendanceBloc(this.attendanceRepository) : super(AttendanceInitial()) {
    on<CreateOrGetAttendanceForLiveClass>(_createOrGetAttendanceForLiveClass);
    on<MarkAttendanceForLiveClass>(_markAttendanceForLiveClass);
    on<DeleteLiveAttendanceEvent>(_deleteLiveAttendance);
  }

  FutureOr<void> _createOrGetAttendanceForLiveClass(
    CreateOrGetAttendanceForLiveClass event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());

    final result = await attendanceRepository.createOrGetAttendance(
      event.classData,
      event.students,
    );

    result.fold((failure) => emit(AttendanceCreationFailure(failure.message)), (
      checkResult,
    ) {
      if (checkResult.alreadyTaken) {
          emit(AttendanceAlreadyTaken(checkResult.presentStudents,checkResult.lessonTopic!));
      } else {
        emit(AttendanceForClassCreated(checkResult.attendanceId));
      }
    });
  }

  FutureOr<void> _markAttendanceForLiveClass(
    MarkAttendanceForLiveClass event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());

    final result = await attendanceRepository.markAttendanceManual(
      event.attendanceId,
      event.selectedStudents,
      event.mode,
      event.teacherId,
      event.selectedTopic,
      event.sectionId
    );

    result.fold(
      (failure) => emit(AttendanceMarkFailure(failure.message)),
      (_) => emit(AttendanceMarkedForLiveClass()),
    );
  }

  FutureOr<void> _deleteLiveAttendance(
    DeleteLiveAttendanceEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    try {
      emit(AttendanceLoading());
      final result = await attendanceRepository.deleteAttendanceById(
        event.attendanceId,
        event.classId,
        event.lessonNumber,
        event.sectionId,
        event.teacherId
      );
      result.fold(
        (failure) => emit(AttendanceDeletionFailure(failure.message)),
        (_) => emit(AttendanceDeleted()),
      );
    } catch (e) {
      emit(AttendanceDeletionFailure("Some unknown error occurred"));
    }
  }
}
