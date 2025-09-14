import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_teacher/core/error/failure.dart';
import 'package:markme_teacher/features/class/repositories/class_repository.dart';
import 'package:markme_teacher/features/home/bloc/home_event.dart';
import 'package:markme_teacher/features/home/bloc/home_state.dart';
import 'package:markme_teacher/features/home/repositories/home_repository.dart';
import 'package:markme_teacher/features/section/repository/section_repository.dart';
import 'package:markme_teacher/features/student/repositories/student_repository.dart';
import 'package:uuid/uuid.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;
  final SectionRepository sectionRepository;
  final StudentRepository studentRepository;
  final ClassRepository classRepository;
  StreamSubscription? _subscription;
  HomeBloc(
    this.homeRepository,
    this.sectionRepository,
    this.studentRepository,
    this.classRepository,
  ) : super(HomeLoading()) {
    on<HomeStarted>(_onStarted);
    on<HomeUpdated>(_onUpdated);
    on<GetSectionDetailsForHome>(_getSectionDetails);
  }
  void _onStarted(HomeStarted event, Emitter<HomeState> emit) {
    // Show loading once when listener starts
    emit(HomeLoading());

    // Cancel any previous subscription
    _subscription?.cancel();

    // Start listening to teacher snapshot
    _subscription = homeRepository.listenToTeacher(event.teacherId).listen(
          (teacher) {
        // On each snapshot update, emit data directly
        add(HomeUpdated(teacher));
      },
      onError: (e) {
        emit(HomeFailure(e.toString()));
      },
    );
  }

  FutureOr<void> _onUpdated(HomeUpdated event, Emitter<HomeState> emit) {
    // No loading here, just emit the latest data
    emit(TeacherDataLoadedForHome(event.teacher));
  }
  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }


  FutureOr<void> _getSectionDetails(
    GetSectionDetailsForHome event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    final result = await sectionRepository.getSectionDetails(event.sectionId);
    result.fold(
      (failure) => emit(HomeFailure(failure.message)),
      (section) => emit(SectionDataLoadedForHome(section)),
    );
  }
}
