import 'package:equatable/equatable.dart';
import 'package:markme_teacher/core/models/student.dart';
import 'package:markme_teacher/core/models/teacher.dart';
import 'package:markme_teacher/features/class/models/class_session.dart';

import '../../../core/models/section.dart';

abstract class HomeState extends Equatable{
  const HomeState();
  @override
  List<Object?> get props => [];
}
class TeacherDataLoadedForHome extends HomeState{
  final Teacher teacher;
  const TeacherDataLoadedForHome(this.teacher);
  @override
  List<Object?> get props => [teacher];
}
class SectionDataLoadedForHome extends HomeState{
  final Section section;
  const SectionDataLoadedForHome(this.section);
  @override
  List<Object?> get props => [section];
}
class ClassStarted extends HomeState{
  final List<Student> students;
  final ClassSession classData;
  const ClassStarted(this.students,this.classData);
}

class HomeInitial extends HomeState{

}
class HomeLoading extends HomeState{

}

class HomeSuccess extends HomeState{

}

class HomeFailure extends HomeState{
  final String message;
  const HomeFailure(this.message);
  @override
  List<Object?> get props => [message];
}
