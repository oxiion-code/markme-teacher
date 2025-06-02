abstract class UserListEvent{}
class LoadUsers extends UserListEvent{}
class LoadMoreUsers extends UserListEvent{}
class RefreshUsers extends UserListEvent {}

class SearchUsers extends UserListEvent{
  final String query;
  SearchUsers(this.query);
}