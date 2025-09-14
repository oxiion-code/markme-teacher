import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_teacher/features/lesson_plan/bloc/lesson_event.dart';
import 'package:markme_teacher/features/lesson_plan/bloc/lesson_state.dart';
import 'package:markme_teacher/features/lesson_plan/repositories/lesson_plan_repository.dart';

class LessonBloc extends Bloc<LessonEvent, LessonState> {
  final LessonRepository lessonRepository;
  LessonBloc(this.lessonRepository) : super(LessonInitial()) {
    on<AddLessonForSubjectEvent>(_addLesson);
    on<DeleteLessonFoeSubjectEvent>(_deleteLesson);
    on<LoadAllLessonsForTeacherEvent>(_loadLessonPlans);
    on<LoadLessonPlanForAttendanceEvent>(_loadLessonPlanForAttendance);
  }

  FutureOr<void> _addLesson(
    AddLessonForSubjectEvent event,
    Emitter<LessonState> emit,
  ) async {
    try {
      emit(LessonLoading());
      final result = await lessonRepository.addLessonPlanByTeacherId(
        event.lessonPlan,
        event.teacherId,
      );
      result.fold((failure) => emit(LessonFailure(failure.message)), (_) {
        emit(LessonAddedForSubject());
      });
    } catch (e) {
      emit(LessonFailure("Some unknown error occurred"));
    }
  }

  FutureOr<void> _deleteLesson(
    DeleteLessonFoeSubjectEvent event,
    Emitter<LessonState> emit,
  ) async {
    try {
      emit(LessonLoading());
      final result = await lessonRepository.deleteLessonPlanByTeacherId(
        event.lessonPlan,
        event.teacherId,
      );
      result.fold((failure) => emit(LessonFailure(failure.message)), (_) {
        emit(LessonDeletedForSubject());
      });
    } catch (e) {
      emit(LessonFailure("Some unknown error occurred"));
    }
  }

  FutureOr<void> _loadLessonPlans(
    LoadAllLessonsForTeacherEvent event,
    Emitter<LessonState> emit,
  ) async {
    try {
      emit(LessonLoading());
      final result = await lessonRepository.getLessonPlansByTeacherId(
        event.teacherId,
      );
      result.fold(
        (failure) => emit(LessonFailure(failure.message)),
        (lessonPlans) => emit(LessonsLoadedForTeacher(lessonPlans)),
      );
    } catch (e) {
      emit(LessonFailure("Some unknown error occurred"));
    }
  }

  FutureOr<void> _loadLessonPlanForAttendance(
    LoadLessonPlanForAttendanceEvent event,
    Emitter<LessonState> emit,
  ) async {
    try {
      emit(LessonLoading());
      final result = await lessonRepository.getLessonPlanForAttendance(
        event.teacherId,
        event.sectionId,
        event.subjectId,
      );
      result.fold(
        (failure) => emit(LessonFailure(failure.message)),
        (lessonPlan) => emit(LessonPlanLoadedForAttendance(lessonPlan)),
      );
    } catch (e) {}
  }
}
