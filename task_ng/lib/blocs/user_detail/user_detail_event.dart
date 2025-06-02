abstract class UserDetailEvent{}

class LoadUserPosts extends UserDetailEvent{
  final int userId;
  LoadUserPosts(this.userId);
}

class LoadUserTodos extends UserDetailEvent{
  final int userId;
  LoadUserTodos(this.userId);
}
