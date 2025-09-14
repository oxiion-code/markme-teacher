import 'package:equatable/equatable.dart';
import 'package:markme_teacher/core/models/teacher.dart';
import 'package:markme_teacher/features/class/models/class_session.dart';

abstract class HomeEvent extends Equatable{
  const HomeEvent();
  @override
  List<Object?> get props => [];
}
class HomeStarted extends HomeEvent{
  final String teacherId;
  const HomeStarted(this.teacherId);
  @override
  List<Object?> get props => [teacherId];
}
class HomeUpdated extends HomeEvent{
  final Teacher teacher;

  const HomeUpdated(this.teacher);
  @override
  List<Object?> get props => [teacher];
}
class GetSectionDetailsForHome extends HomeEvent{
  final String sectionId;
  const GetSectionDetailsForHome(this.sectionId);
  @override
  List<Object?> get props => [sectionId];
}
class StartClassEvent extends HomeEvent{
  final ClassSession classSession;
  const StartClassEvent(this.classSession);
}


