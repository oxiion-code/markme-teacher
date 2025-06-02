import 'package:task_ng/models/user_model.dart';

abstract class UserListState{}

class UserListInitial extends UserListState{}

class UserListLoading extends UserListState{}

class UserListLoadSuccess extends UserListState{
  final List<User> users;
  final bool hasMore;
  final bool isLoadingMore;
  UserListLoadSuccess(this.users,{this.hasMore=true,this.isLoadingMore=false});
}
class UserListError extends UserListState{
  final String message;
  UserListError(this.message);
}