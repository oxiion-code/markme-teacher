import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:markme_teacher/core/error/failure.dart';
import 'package:markme_teacher/core/models/branch.dart';
import 'package:markme_teacher/features/settings/repositories/setting_repository.dart';

class SettingRepositoryImpl extends SettingRepository{
  FirebaseFirestore firestore;
  SettingRepositoryImpl(this.firestore);
  @override
  Future<Either<AppFailure, List<Branch>>> getBranches() async {
    try{
      final snapshot= await firestore.collection("branches").get();
      final branches= snapshot.docs.map((branch)=>Branch.fromMap(branch.data()) ).toList();
      return Right(branches);
    }catch(e){
      return Left(AppFailure(message: e.toString()));
    }
  }
}