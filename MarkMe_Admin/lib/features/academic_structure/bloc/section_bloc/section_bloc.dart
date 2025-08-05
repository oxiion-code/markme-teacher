import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/section_bloc/section_event.dart';
import 'package:markme_admin/features/academic_structure/bloc/section_bloc/section_state.dart';
import 'package:markme_admin/features/academic_structure/repository/batch_repo/academic_batch_repository.dart';
import 'package:markme_admin/features/academic_structure/repository/branch_repo/branch_repository.dart';
import 'package:markme_admin/features/academic_structure/repository/section_repo/section_repository.dart';
import 'package:markme_admin/features/academic_structure/repository/semester_repo/semester_repository.dart';

class SectionBloc extends Bloc<SectionEvent, SectionState> {
  final SectionRepository sectionRepository;
  final AcademicBatchRepository batchRepository;
  final BranchRepository branchRepository;
  SectionBloc(
    this.branchRepository,
    this.sectionRepository,
    this.batchRepository,
  ) : super(SectionInitial()) {
    on<AddNewSectionEvent>(_addSection);
    on<UpdateSectionEvent>(_updateSection);
    on<DeleteSectionEvent>(_deleteSection);
    on<LoadAllBatchesEvent>(_loadBatches);
    on<LoadAllSectionEvent>(_loadSections);
    on<LoadAllBranchesEvent>(_loadSemesters);
  }

  FutureOr<void> _addSection(
    AddNewSectionEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(SectionLoading());
    final result = await sectionRepository.addSection(event.section);
    result.fold((failure) => emit(SectionError(failure.message)), (_) {
      emit(SectionSuccess());
      add(LoadAllSectionEvent());
    });
  }

  FutureOr<void> _updateSection(
    UpdateSectionEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(SectionLoading());
    final result = await sectionRepository.updateSection(event.section);
    result.fold((failure) => emit(SectionError(failure.message)), (_) {
      emit(SectionSuccess());
      add(LoadAllSectionEvent());
    });
  }

  FutureOr<void> _deleteSection(
    DeleteSectionEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(SectionLoading());
    final result = await sectionRepository.deleteSection(event.section);
    result.fold((failure) => emit(SectionError(failure.message)), (_) {
      emit(SectionSuccess());
      add(LoadAllSectionEvent());
    });
  }

  FutureOr<void> _loadBatches(
    LoadAllBatchesEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(SectionLoading());
    final result = await batchRepository.getBatches();
    result.fold((failure) => emit(SectionError(failure.message)), (batches) {
      emit(BatchesLoaded(batches));
    });
  }

  FutureOr<void> _loadSections(
    LoadAllSectionEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(SectionLoading());
    final result = await sectionRepository.getAllSections();
    result.fold(
      (failure) => emit(SectionError(failure.message)),
      (sections) => emit(SectionsLoaded(sections)),
    );
  }

  FutureOr<void> _loadSemesters(
    LoadAllBranchesEvent event,
    Emitter<SectionState> emit,
  ) async {
    emit(SectionLoading());
    final result = await branchRepository.loadAllBranches();
    result.fold(
      (failure) => emit(SectionError(failure.message)),
      (branches) => emit(BranchesLoaded(branches)),
    );
  }
}
