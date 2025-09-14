import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_teacher/features/settings/bloc/setting_event.dart';
import 'package:markme_teacher/features/settings/bloc/setting_state.dart' ;
import 'package:markme_teacher/features/settings/repositories/setting_repository.dart';


class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final SettingRepository repository;

  SettingBloc(this.repository) : super(SettingInitial()) {
    on<LoadBranchesEvent>((event, emit) async {
      emit(SettingLoading());

      final result = await repository.getBranches();

      result.fold(
            (failure) => emit(SettingError(failure.message)),
            (branches) => emit(SettingBranchesLoaded(branches)),
      );
    });
  }
}
