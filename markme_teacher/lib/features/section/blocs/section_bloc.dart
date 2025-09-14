import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_teacher/features/section/blocs/section_event.dart';
import 'package:markme_teacher/features/section/blocs/section_state.dart';

import 'package:markme_teacher/features/subject/repositories/subject_repository.dart';

import '../repository/section_repository.dart';

class SectionBloc extends Bloc<SectionEvent, SectionState> {
  final SubjectRepository subjectRepository;
  final SectionRepository sectionRepository;

  SectionBloc(this.subjectRepository, this.sectionRepository)
    : super(SectionInitial()) {
    on<AddSectionEvent>(_onAddSection);
    on<DeleteSectionEvent>(_onDeleteSection);
    on<GetCoursesEvent>(_onGetCourses);
    on<GetBranchesForSectionEvent>(_onGetBranchesForSection);
    on<GetBatchesForSectionEvent>(_onGetBatchesForSection);
    on<GetSectionsByFilterEvent>(_onGetSectionsByFilter);
    on<GetSectionsOfTeacherEvent>(_onGetSectionsOfTeacher);
  }
  Future<void> _onAddSection(
    AddSectionEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(SectionLoading());
    final result = await sectionRepository.addSection(
      event.teacherId,
      event.sectionId,
    );
    result.fold((failure) => emit(SectionFailure(failure.message)), (_)=>emit(SectionAdded()));
  }

  Future<void> _onDeleteSection(
    DeleteSectionEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(SectionLoading());
    final result = await sectionRepository.deleteSection(
      event.teacherId,
      event.sectionId,
    );
    result.fold((failure) => emit(SectionFailure(failure.message)),(_)=>emit(SectionDeleted()));
  }

  Future<void> _onGetCourses(
    GetCoursesEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(SectionLoading());
    final result = await subjectRepository.getAllCourses();
    result.fold(
      (failure) => emit(SectionFailure(failure.message)),
      (courses) => emit(CoursesLoadedForSection(courses)),
    );
  }

  Future<void> _onGetBranchesForSection(
    GetBranchesForSectionEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(SectionLoading());
    final result = await subjectRepository.getBranchesForCourse(event.courseId);
    result.fold(
      (failure) => emit(SectionFailure(failure.message)),
      (branches) => emit(BranchesLoadedForSection(branches)),
    );
  }

  Future<void> _onGetBatchesForSection(
    GetBatchesForSectionEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(SectionLoading());
    final result = await subjectRepository.getBatchesForBranch(event.branchId);
    result.fold(
      (failure) => emit(SectionFailure(failure.message)),
      (batches) => emit(BatchesLoadedForSection(batches)),
    );
  }

  Future<void> _onGetSectionsByFilter(
    GetSectionsByFilterEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(SectionLoading());
    final result = await sectionRepository.getSectionsByFilters(
      courseId: event.courseId,
      branchId: event.branchId,
      batchId: event.batchId,
    );
    result.fold(
      (failure) => emit(SectionFailure(failure.message)),
      (sections) => emit(SectionsLoaded(sections)),
    );
  }

  Future<void> _onGetSectionsOfTeacher(
    GetSectionsOfTeacherEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(SectionLoading());
    final result = await sectionRepository.getSections(event.teacherId);
    result.fold(
      (failure) => emit(SectionFailure(failure.message)),
      (sections) => emit(SectionsOfTeacherLoaded(sections)),
    );
  }
}
