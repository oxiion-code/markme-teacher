import 'package:equatable/equatable.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/academic_structure/models/academic_batch.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';
import 'package:markme_admin/features/academic_structure/models/section.dart';
import 'package:markme_admin/features/academic_structure/models/semester.dart';

class SectionState extends Equatable{
  const SectionState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SectionInitial extends SectionState{}
class SectionLoading extends SectionState{}
class SectionSuccess extends SectionState{}
class SectionError extends SectionState{
  final String message;
  const SectionError(this.message);
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
class SectionsLoaded extends SectionState{
  final List<Section> sections;
  const SectionsLoaded(this.sections);
  @override
  List<Object?> get props => [sections];
}
class BatchesLoaded extends SectionState{
  final List<AcademicBatch> batches;
  const BatchesLoaded(this.batches);
  @override
  List<Object?> get props => [batches];
}
class BranchesLoaded extends SectionState{
  final List<Branch> branches;
  const BranchesLoaded(this.branches);
  @override
  List<Object?> get props => [branches];
}