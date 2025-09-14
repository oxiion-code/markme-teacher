import 'package:equatable/equatable.dart';
import 'package:markme_teacher/core/models/subject.dart';

class SubjectEvent extends Equatable {
  const SubjectEvent();
  @override
  List<Object?> get props => [];
}

class AddSubjectEvent extends SubjectEvent {
  final Subject subject;
  final String teacherId;
  const AddSubjectEvent(this.subject, this.teacherId);
  @override
  List<Object?> get props => [subject, teacherId];
}

class UpdateSubjectEvent extends SubjectEvent {
  final Subject subject;
  final String teacherId;
  const UpdateSubjectEvent(this.subject, this.teacherId);
  @override
  List<Object?> get props => [subject, teacherId];
}

class DeleteSubjectEvent extends SubjectEvent {
  final Subject subject;
  final String teacherId;
  const DeleteSubjectEvent(this.subject, this.teacherId);
  @override
  List<Object?> get props => [subject, teacherId];
}
class GetAllSubjectsForTeacherEvent extends SubjectEvent{
  final String teacherId;
  const GetAllSubjectsForTeacherEvent(this.teacherId);
  @override
  // TODO: implement props
  List<Object?> get props => [teacherId];
}

class GetAllCoursesEvent extends SubjectEvent {

}

class GetBranchesForCourseEvent extends SubjectEvent {
  final String courseId;
  const GetBranchesForCourseEvent(this.courseId);
  @override
  List<Object?> get props => [courseId];
}

class GetBatchesForBranchEvent extends SubjectEvent {
  final String branchId;
  const GetBatchesForBranchEvent(this.branchId);
  @override
  List<Object?> get props => [branchId];
}

class GetSubjectsForBatchEvent extends SubjectEvent {
  final String batchId;
  const GetSubjectsForBatchEvent(this.batchId);
  @override
  // TODO: implement props
  List<Object?> get props => [batchId];
}
