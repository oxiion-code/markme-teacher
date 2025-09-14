import 'package:equatable/equatable.dart';
import 'package:markme_teacher/features/lesson_plan/models/lesson_plan.dart';

class LessonEvent extends Equatable{
  const LessonEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
 class LoadAllLessonsForTeacherEvent extends LessonEvent{
  final String teacherId;
   const LoadAllLessonsForTeacherEvent( this.teacherId);
   @override
  List<Object?> get props => [teacherId];
 }

 class AddLessonForSubjectEvent extends LessonEvent{
  final LessonPlan lessonPlan;
  final String teacherId;
  const AddLessonForSubjectEvent(this.lessonPlan,this.teacherId);
  @override
  List<Object?> get props => [lessonPlan,teacherId];
}

class DeleteLessonFoeSubjectEvent extends LessonEvent{
  final LessonPlan lessonPlan;
  final String teacherId;
  const DeleteLessonFoeSubjectEvent(this.teacherId,this.lessonPlan);
  @override
  List<Object?> get props => [teacherId,lessonPlan];
}

class LoadLessonPlanForAttendanceEvent extends LessonEvent{
  final String sectionId;
  final String subjectId;
  final String teacherId;
  const LoadLessonPlanForAttendanceEvent({required this.teacherId, required this.sectionId,required this.subjectId});
  @override
  List<Object?> get props => [teacherId,subjectId,sectionId];
}
