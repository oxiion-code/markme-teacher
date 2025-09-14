import 'package:equatable/equatable.dart';
import 'package:markme_teacher/features/class/models/class_start_data.dart';

import '../../../core/models/student.dart';
import '../models/class_session.dart';

abstract class ClassState extends Equatable{
  const ClassState();
  @override
  List<Object?> get props => [];
}
class ClassLoading extends ClassState{}
class ClassInitial extends ClassState{}
class ClassFailure extends ClassState{
  final String message;
  const ClassFailure(this.message);
  @override
  List<Object?> get props => [message];
}


class ClassStarted extends ClassState{
  final List<Student> students;
  final ClassSession classData;
  const ClassStarted({required this.students, required this.classData});
  @override
  List<Object?> get props => [students,classData];
}

class JoinedLiveClass extends ClassState{
  final ClassStartData classStartData;
  const JoinedLiveClass(this.classStartData);
  @override
  List<Object?> get props => [classStartData];
}
class EndedLiveClass extends ClassState{

}