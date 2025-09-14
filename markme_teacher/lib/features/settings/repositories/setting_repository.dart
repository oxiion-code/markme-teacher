import 'package:dartz/dartz.dart';
import 'package:markme_teacher/core/error/failure.dart';
import 'package:markme_teacher/core/models/branch.dart';

abstract class SettingRepository{
  Future<Either<AppFailure,List<Branch>>> getBranches();

}