import 'package:hive/hive.dart';

part 'local_post.g.dart';

@HiveType(typeId: 0)
class LocalPost extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String body;

  LocalPost({required this.title, required this.body});
}
