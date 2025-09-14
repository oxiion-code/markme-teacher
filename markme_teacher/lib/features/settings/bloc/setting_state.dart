import 'package:equatable/equatable.dart';
import 'package:markme_teacher/core/models/branch.dart';

abstract class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object?> get props => [];
}

class SettingInitial extends SettingState {}

class SettingLoading extends SettingState {}

/// 🔹 Loaded state specifically for Branches
class SettingBranchesLoaded extends SettingState {
  final List<Branch> branches;

  const SettingBranchesLoaded(this.branches);

  @override
  List<Object?> get props => [branches];
}

class SettingError extends SettingState {
  final String message;

  const SettingError(this.message);

  @override
  List<Object?> get props => [message];
}
