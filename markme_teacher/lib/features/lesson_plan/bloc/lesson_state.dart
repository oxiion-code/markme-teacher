import 'package:equatable/equatable.dart';
import 'package:markme_teacher/features/lesson_plan/models/lesson_plan.dart';

abstract class LessonState extends Equatable{
  const LessonState();
  @override
  List<Object?> get props => [];
}

class LessonInitial extends LessonState{

}
class LessonLoading extends LessonState{

}
class LessonsLoadedForTeacher extends LessonState{
  final List<LessonPlan> lessons;
  const LessonsLoadedForTeacher(this.lessons);
  @override
  List<Object?> get props => [lessons];
}
class LessonAddedForSubject extends LessonState{

}
class LessonDeletedForSubject extends LessonState{

}
class LessonPlanLoadedForAttendance extends LessonState{
  final LessonPlan lessonPlan;
  const LessonPlanLoadedForAttendance(this.lessonPlan);
  @override
  List<Object?> get props => [lessonPlan];
}
class LessonFailure extends LessonState{
  final String message;
  const LessonFailure(this.message);
  @override
  List<Object?> get props => [message];
}
