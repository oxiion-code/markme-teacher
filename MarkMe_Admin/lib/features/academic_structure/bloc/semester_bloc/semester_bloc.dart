import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/semester_bloc/semester_event.dart';
import 'package:markme_admin/features/academic_structure/bloc/semester_bloc/semester_state.dart';
import 'package:markme_admin/features/academic_structure/repository/branch_repo/branch_repository.dart';
import 'package:markme_admin/features/academic_structure/repository/semester_repo/semester_repository.dart';

class SemesterBloc extends Bloc<SemesterEvent, SemesterState> {
  final BranchRepository branchRepository;
  final SemesterRepository semesterRepository;

  SemesterBloc(this.branchRepository, this.semesterRepository)
      : super(SemesterInitial()) {
    on<AddNewSemesterEvent>(_addNewSemester);
    on<DeleteSemesterEvent>(_deleteSemester);
    on<UpdateSemesterEvent>(_updateSemester);
    on<LoadBranchesEvent>(_loadBranches);
    on<LoadSemestersEvent>(_loadSemesters);
  }

  FutureOr<void> _addNewSemester(AddNewSemesterEvent event,
      Emitter<SemesterState> emit,) async {
    emit(SemesterLoading());
    final result = await semesterRepository.addSemester(event.semester);
    result.fold((failure) => emit(SemesterFailure(failure.message)), (_) {
      emit(SemesterSuccess());
      add(LoadSemestersEvent());
    });
  }

  FutureOr<void> _deleteSemester(DeleteSemesterEvent event,
      Emitter<SemesterState> emit,) async {
    emit(SemesterLoading());
    final result = await semesterRepository.deleteSemester(event.semester);
    result.fold((failure) => emit(SemesterFailure(failure.message)), (_) {
      emit(SemesterSuccess());
      add(LoadSemestersEvent());
    });
  }

  FutureOr<void> _updateSemester(UpdateSemesterEvent event,
      Emitter<SemesterState> emit,) async {
    emit(SemesterLoading());
    final result = await semesterRepository.updateSemester(event.semester);
    result.fold((failure) => emit(SemesterFailure(failure.message)), (_) {
      emit(SemesterSuccess());
      add(LoadSemestersEvent());
    });
  }

  FutureOr<void> _loadBranches(LoadBranchesEvent event,
      Emitter<SemesterState> emit,) async {
    emit(SemesterLoading());
    final result = await branchRepository.loadAllBranches();
    result.fold((failure) => emit(SemesterFailure(failure.message)), (
        branches) {
      emit(BranchesLoaded(branches));
    });
  }

  FutureOr<void> _loadSemesters(LoadSemestersEvent event,
      Emitter<SemesterState> emit,) async {
    emit(SemesterLoading());
    final result = await semesterRepository.getSemesters();
    result.fold((failure) => emit(SemesterFailure(failure.message)), (
        semesters) {
      emit(SemestersLoaded(semesters));
    });
  }
}