import 'package:equatable/equatable.dart';
import 'package:markme_admin/features/academic_structure/models/section.dart';

class SectionEvent extends Equatable{
  const SectionEvent();
  @override
  List<Object?> get props => [];
}

class AddNewSectionEvent extends SectionEvent{
  final Section section;
  const AddNewSectionEvent(this.section);
  @override
  List<Object?> get props => [section];
}

class DeleteSectionEvent extends SectionEvent{
  final Section section;
  const DeleteSectionEvent(this.section);
  @override
  List<Object?> get props => [section];
}
class UpdateSectionEvent extends  SectionEvent{
  final Section section;
  const UpdateSectionEvent(this.section);
  @override
  List<Object?> get props => [section];
}
class LoadAllSectionEvent extends SectionEvent{

}
class LoadAllBatchesEvent extends SectionEvent{

}
class LoadAllBranchesEvent extends SectionEvent{

}