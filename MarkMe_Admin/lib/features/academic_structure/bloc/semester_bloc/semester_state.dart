import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';
import 'package:markme_admin/features/academic_structure/models/semester.dart';

abstract class SemesterState extends Equatable{
  const SemesterState();
  @override
  List<Object?> get props => [];
}

class SemesterInitial extends SemesterState{}

class SemesterSuccess extends SemesterState{}

class SemesterLoading extends SemesterState{}

class SemesterFailure extends SemesterState{
  final String message;
  const SemesterFailure(this.message);
  @override
  List<Object?> get props => [message];
}
class SemestersLoaded extends SemesterState{
  final List<Semester> semesters;
  const SemestersLoaded(this.semesters);
  @override
  List<Object?> get props => [];
}
class BranchesLoaded extends SemesterState{
  final List<Branch> branches;
  const BranchesLoaded(this.branches);
  @override
  List<Object?> get props => [branches];
}