import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:markme_teacher/core/models/teacher.dart';
import 'package:markme_teacher/features/home/repositories/home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {
  final FirebaseFirestore firestore;
  HomeRepositoryImpl(this.firestore);

  @override
  Stream<Teacher> listenToTeacher(String teacherId) {
    return firestore.collection('teachers').doc(teacherId).snapshots().map((
      snapshot,
    ) {
      if (!snapshot.exists || snapshot.data() == null) {
        throw Exception(" Teacher not found");
      }
      return Teacher.fromMap(snapshot.data()!);
    });
  }
}
