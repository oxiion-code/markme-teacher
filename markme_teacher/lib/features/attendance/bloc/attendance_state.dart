import 'package:equatable/equatable.dart';
import 'package:markme_teacher/features/lesson_plan/models/lesson_topic.dart';

abstract class AttendanceState extends Equatable{
  const AttendanceState();
  @override
  List<Object?> get props => [];
}
class AttendanceInitial extends AttendanceState{
}
class AttendanceLoading extends AttendanceState{

}

class AttendanceCreationFailure extends AttendanceState{
  final String message;
  const AttendanceCreationFailure(this.message);
  @override
  List<Object?> get props => [message];
}
class AttendanceDeletionFailure extends AttendanceState{
  final String message;
  const AttendanceDeletionFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class AttendanceForClassCreated extends AttendanceState{
  final String attendanceId;
  const AttendanceForClassCreated(this.attendanceId);
  @override
  List<Object?> get props => [attendanceId];
}
class AttendanceAlreadyTaken extends AttendanceState{
  final Map<String,bool> presentStudents;
  final LessonTopic lessonTopic;
  const AttendanceAlreadyTaken(this.presentStudents,this.lessonTopic);
  @override
  List<Object?> get props => [presentStudents];
}

class AttendanceDeleted extends AttendanceState{

}

class AttendanceMarkedForLiveClass extends AttendanceState{}
class AttendanceMarkFailure extends AttendanceState{
  final String message;
  const AttendanceMarkFailure(this.message);
  @override
  List<Object?> get props => [message];
}
