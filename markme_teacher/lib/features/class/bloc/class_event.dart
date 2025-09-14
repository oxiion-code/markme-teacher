import 'package:equatable/equatable.dart';

import '../models/class_session.dart';

abstract class ClassEvent extends Equatable{
  const ClassEvent();
  @override
  List<Object?> get props => [];
}
class StartClassEvent extends ClassEvent{
  final ClassSession classSession;
  const StartClassEvent(this.classSession);
  @override
  List<Object?> get props => [classSession];
}
class JoinLiveClassEvent extends ClassEvent{
  final String classId;
  const JoinLiveClassEvent(this.classId);
  @override
  List<Object?> get props => [classId];
}
class EndClassEvent extends ClassEvent{
  final  String classId;
  final String teacherId;
  const EndClassEvent(this.classId,this.teacherId);
  @override
  List<Object?> get props => [classId,teacherId];
}