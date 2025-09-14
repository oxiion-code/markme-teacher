import 'package:markme_teacher/core/models/teacher.dart';
import 'package:markme_teacher/features/lesson_plan/models/lesson_plan.dart';

class LessonPlanDetails{
  final Teacher teacher;
  final LessonPlan lessonPlan;
  const LessonPlanDetails({required this.teacher, required this.lessonPlan});
}