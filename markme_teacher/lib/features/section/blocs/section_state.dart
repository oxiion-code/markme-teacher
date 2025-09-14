import 'package:equatable/equatable.dart';
import 'package:markme_teacher/core/models/academic_batch.dart';
import 'package:markme_teacher/core/models/branch.dart';
import 'package:markme_teacher/core/models/course.dart';
import 'package:markme_teacher/core/models/section.dart';

abstract class SectionState extends Equatable{
  const SectionState();
  @override
  List<Object?> get props => [];
}
class SectionInitial extends SectionState{

}
class SectionLoading extends SectionState{

}

class SectionAdded extends SectionState{

}
class SectionDeleted extends SectionState{

}
class SectionFailure extends SectionState{
  final String message;
  const SectionFailure(this.message);
  @override
  List<Object?> get props => [message];
}
class CoursesLoadedForSection extends SectionState{
  final List<Course> courses;
  const CoursesLoadedForSection(this.courses);
  @override
  // TODO: implement props
  List<Object?> get props => [courses];
}
class BranchesLoadedForSection extends SectionState{
  final List<Branch> branches;
  const BranchesLoadedForSection(this.branches);
  @override
  List<Object?> get props => [branches];
}
class BatchesLoadedForSection extends SectionState{
  final List<AcademicBatch> batches;
  const BatchesLoadedForSection(this.batches);
  @override
  List<Object?> get props => [batches];
}
class SectionsLoaded extends SectionState{
  final List<String> sections;
  const SectionsLoaded(this.sections);
  @override
  List<Object?> get props => [sections];
}
class SectionsOfTeacherLoaded extends SectionState{
  final List<String> sections;
  const SectionsOfTeacherLoaded(this.sections);
  @override
  List<Object?> get props => [sections];
}