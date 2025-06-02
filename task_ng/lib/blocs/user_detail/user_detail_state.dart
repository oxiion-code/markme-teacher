import 'package:task_ng/models/post_model.dart';
import 'package:task_ng/models/todo_model.dart';

abstract class UserDetailState{}

class UserDetailInitial extends UserDetailState{}

class UserPostsLoading extends UserDetailState{

}
class UserTodosLoading extends UserDetailState{

}
class UserPostsLoaded extends UserDetailState{
  final List<Post> posts;
  UserPostsLoaded(this.posts);
}
class UserTodosLoaded extends UserDetailState{
  final List<Todo> todos;
  UserTodosLoaded(this.todos);
}
class UserDetailError extends UserDetailState{
  final String message;
  UserDetailError(this.message);
}
