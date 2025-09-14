import 'package:equatable/equatable.dart';

abstract class SectionEvent extends Equatable {
  const SectionEvent();
  @override
  List<Object?> get props => [];
}

class AddSectionEvent extends SectionEvent {
  final String teacherId;
  final String sectionId;
  const AddSectionEvent(this.teacherId, this.sectionId);
  @override
  List<Object?> get props => [teacherId, sectionId];
}

class DeleteSectionEvent extends SectionEvent {
  final String teacherId;
  final String sectionId;
  const DeleteSectionEvent(this.teacherId, this.sectionId);
  @override
  // TODO: implement props
  List<Object?> get props => [teacherId, sectionId];
}

class GetCoursesEvent extends SectionEvent {

}

class GetBranchesForSectionEvent extends SectionEvent {
  final String courseId;
  const GetBranchesForSectionEvent(this.courseId);
  @override
  List<Object?> get props => [courseId];
}

class GetBatchesForSectionEvent extends SectionEvent {
  final String branchId;
  const GetBatchesForSectionEvent(this.branchId);
  @override
  List<Object?> get props => [branchId];
}

class GetSectionsEvent extends SectionEvent {
  final String sectionId;
  const GetSectionsEvent(this.sectionId);
  @override
  List<Object?> get props => [sectionId];
}

class GetSectionsOfTeacherEvent extends SectionEvent {
  final String teacherId;
  const GetSectionsOfTeacherEvent(this.teacherId);
  @override
  List<Object?> get props => [teacherId];
}

class GetSectionsByFilterEvent extends SectionEvent{
  final String branchId;
  final String batchId;
  final String courseId;
  const GetSectionsByFilterEvent(this.courseId,this.branchId,this.batchId);
  @override
  List<Object?> get props => [courseId,branchId,batchId];
}
