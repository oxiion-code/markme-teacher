import 'package:equatable/equatable.dart';
import 'package:markme_teacher/core/models/academic_batch.dart';
import 'package:markme_teacher/core/models/branch.dart';
import 'package:markme_teacher/core/models/course.dart';
import 'package:markme_teacher/core/models/subject.dart';

class SubjectState extends Equatable{
  const SubjectState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class SubjectInitial extends SubjectState{

}
enum SubjectAction { add, update, delete }

class SubjectSuccess extends SubjectState {
  final SubjectAction action;
  final Subject? subject; // optional, the affected subject

  const SubjectSuccess({required this.action, this.subject});

  @override
  List<Object?> get props => [action, subject];
}
class SubjectLoading extends SubjectState{

}
class SubjectFailure extends SubjectState{
  final String message;
  const SubjectFailure(this.message);
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class CoursesLoadedForSubject extends SubjectState{
  final List<Course> courses;
  const CoursesLoadedForSubject(this.courses);
  @override
  List<Object?> get props => [courses];
}
class BranchesLoadedForSubject extends SubjectState{
  final List<Branch> branches;
  const BranchesLoadedForSubject(this.branches);
  @override
  // TODO: implement props
  List<Object?> get props => [branches];
}
class BatchesLoadedForSubject extends SubjectState{
  final List<AcademicBatch> batches;
  const BatchesLoadedForSubject(this.batches);
  @override
  List<Object?> get props => [batches];
}
class SubjectsLoaded extends SubjectState{
  final List<Subject> subjects;
  const SubjectsLoaded(this.subjects);
  @override
  // TODO: implement props
  List<Object?> get props => [subjects];
}
class SubjectsLoadedForTeacher extends SubjectState {
  final List<Subject> subjects;
  final SubjectAction? action; // 👈 add this for UI snackbars

  const SubjectsLoadedForTeacher(this.subjects, {this.action});

  @override
  List<Object?> get props => [subjects, action];
}