import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_teacher/features/class/bloc/class_event.dart';
import 'package:markme_teacher/features/class/bloc/class_state.dart';
import 'package:uuid/uuid.dart';

import '../../../core/error/failure.dart';
import '../../section/repository/section_repository.dart';
import '../../student/repositories/student_repository.dart';
import '../repositories/class_repository.dart';

class ClassBloc extends Bloc<ClassEvent, ClassState> {
  final SectionRepository sectionRepository;
  final StudentRepository studentRepository;
  final ClassRepository classRepository;
  ClassBloc(
    this.classRepository,
    this.studentRepository,
    this.sectionRepository,
  ) : super(ClassInitial()) {
    on<StartClassEvent>(_startClass);
    on<JoinLiveClassEvent>(_joinLiveClass);
    on<EndClassEvent>(_endLiveClass);
  }

  FutureOr<void> _startClass(
    StartClassEvent event,
    Emitter<ClassState> emit,
  ) async {
    emit(ClassLoading());
    try {
      final studentsResult = await studentRepository.getStudentsBySectionId(
        event.classSession.sectionId,
      );
      if (studentsResult.isLeft()) {
        final failure = studentsResult.swap().getOrElse(
          () => AppFailure(message: "Something went wrong"),
        );
        emit(ClassFailure(failure.message));
        return;
      }
      final students = studentsResult.getOrElse(() => []);

      final classSessionId = _generateClassId();

      final classStartResult = await classRepository.startClass(
        event.classSession.copyWith(classId: classSessionId),
      );
      classStartResult.fold(
        (failure) {
          emit(ClassFailure(failure.message));
        },
        (classData) {
          emit(ClassStarted(students: students, classData: classData));
        },
      );
    } catch (e) {
      emit(ClassFailure(e.toString()));
    }
  }

  String _generateClassId() {
    final uuid = Uuid();
    return "CLS-${uuid.v1()}";
  }

  FutureOr<void> _joinLiveClass(
    JoinLiveClassEvent event,
    Emitter<ClassState> emit,
  ) async {
    emit(ClassLoading());
    final result = await classRepository.joinLiveClass(event.classId);
    result.fold(
      (failure) => emit(ClassFailure(failure.message)),
      (classData) => emit(JoinedLiveClass(classData)),
    );
  }

  FutureOr<void> _endLiveClass(
    EndClassEvent event,
    Emitter<ClassState> emit,
  ) async {
    emit(ClassLoading());
    final result = await classRepository.endLiveClass(
      event.classId,
      event.teacherId,
    );
    result.fold(
      (failure) => emit(ClassFailure(failure.message)),
      (_) => emit(EndedLiveClass()),
    );
  }
}
