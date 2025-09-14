import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_teacher/features/subject/blocs/subject_event.dart';
import 'package:markme_teacher/features/subject/blocs/subject_state.dart';
import 'package:markme_teacher/features/subject/repositories/subject_repository.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  final SubjectRepository subjectRepository;
  SubjectBloc(this.subjectRepository) : super(SubjectInitial()) {
    on<AddSubjectEvent>(_addSubject);
    on<DeleteSubjectEvent>(_deleteSubject);
    on<GetAllCoursesEvent>(_getAllCourses);
    on<GetAllSubjectsForTeacherEvent>(_getAllSubjectsForTeacher);
    on<GetBatchesForBranchEvent>(_getBatchesForBranch);
    on<GetBranchesForCourseEvent>(_getBranchesForCourse);
    on<GetSubjectsForBatchEvent>(_getSubjectsForBatch);
  }
  FutureOr<void> _addSubject(
      AddSubjectEvent event,
      Emitter<SubjectState> emit,
      ) async {
    emit(SubjectLoading());

    final result = await subjectRepository.addSubject(
      event.subject,
      event.teacherId,
    );

    result.fold(
          (failure) => emit(SubjectFailure(failure.message)),
          (_) {
            add(GetAllSubjectsForTeacherEvent(event.teacherId));
          },
    );
  }

  FutureOr<void> _deleteSubject(
      DeleteSubjectEvent event,
      Emitter<SubjectState> emit,
      ) async {
    emit(SubjectLoading());

    final result = await subjectRepository.deleteSubject(
      event.subject,
      event.teacherId,
    );

    result.fold(
          (failure) => emit(SubjectFailure(failure.message)),
          (_) {
            emit(SubjectSuccess(action:SubjectAction.delete));
      },
    );
  }

  FutureOr<void> _getAllCourses(
    GetAllCoursesEvent event,
    Emitter<SubjectState> emit,
  ) async {
    emit(SubjectLoading());
    final result = await subjectRepository.getAllCourses();
    result.fold(
      (failure) => emit(SubjectFailure(failure.message)),
      (courses) => emit(CoursesLoadedForSubject(courses)),
    );
  }

  FutureOr<void> _getBatchesForBranch(
    GetBatchesForBranchEvent event,
    Emitter<SubjectState> emit,
  ) async {
    emit(SubjectLoading());
    final result = await subjectRepository.getBatchesForBranch(event.branchId);
    result.fold(
      (failure) => emit(SubjectFailure(failure.message)),
      (batches) => emit(BatchesLoadedForSubject(batches)),
    );
  }

  FutureOr<void> _getAllSubjectsForTeacher(
    GetAllSubjectsForTeacherEvent event,
    Emitter<SubjectState> emit,
  ) async {
    emit(SubjectLoading());
    final result = await subjectRepository.getAllSubjects(event.teacherId);
    result.fold(
      (failure) => emit(SubjectFailure(failure.message)),
      (subjects) => emit(SubjectsLoadedForTeacher(subjects)),
    );
  }

  FutureOr<void> _getBranchesForCourse(
    GetBranchesForCourseEvent event,
    Emitter<SubjectState> emit,
  ) async {
    emit(SubjectLoading());
    final result = await subjectRepository.getBranchesForCourse(event.courseId);
    result.fold(
      (failure) => emit(SubjectFailure(failure.message)),
      (branches) => emit(BranchesLoadedForSubject(branches)),
    );
  }

  FutureOr<void> _getSubjectsForBatch(
    GetSubjectsForBatchEvent event,
    Emitter<SubjectState> emit,
  ) async {
    emit(SubjectLoading());
    final result = await subjectRepository.getSubjectsForBatch(event.batchId);
    result.fold(
      (failure) => emit(SubjectFailure(failure.message)),
      (subjects) => emit(SubjectsLoaded(subjects)),
    );
  }
}
