import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:task_ng/blocs/user_list/user_list_event.dart';
import 'package:task_ng/blocs/user_list/user_list_state.dart';
import 'package:task_ng/repositories/user_repository.dart';

import '../../models/user_model.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final UserRepository userRepository;

  List<User> _users = [];
  final int _limit = 20;
  int _skip = 0;
  bool _hasMore = true;
  bool _isFetching = false;
  final _debounceDuration=Duration(milliseconds: 300);

  EventTransformer<T> debounce<T>(Duration duration){
    return(events,mapper)=>events.debounceTime(duration).switchMap(mapper);
  }

  UserListBloc(this.userRepository) : super(UserListInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<LoadMoreUsers>(_onLoadMoreUsers);
    on<SearchUsers>(_onSearchUsers,transformer: debounce(_debounceDuration));
    on<RefreshUsers>(_onRefreshUsers);
  }


  Future<void> _onLoadUsers(
    LoadUsers event,
    Emitter<UserListState> emit,
  ) async {
    emit(UserListLoading());
    try {
      _skip = 0;
      _users = await userRepository.fetchUsers(limit: _limit, skip: _skip);
      _hasMore = _users.length == _limit;
      emit(UserListLoadSuccess(_users, hasMore: _hasMore));
    } catch (e) {
      emit(UserListError(e.toString()));
    }
  }

  Future<void> _onLoadMoreUsers(
      LoadMoreUsers event, Emitter<UserListState> emit)async{
    if(_isFetching || !_hasMore) return;
    _isFetching=true;
    try{
      _skip+=_limit;
      final moreUsers= await userRepository.fetchUsers(limit: _limit,skip: _skip);
      _users.addAll(moreUsers);
      _hasMore=moreUsers.length==_limit;
      emit(UserListLoadSuccess(List.from(_users),hasMore: _hasMore));
    }catch(e){
      emit(UserListError(e.toString()));
    }
    _isFetching=false;
  }
  Future<void> _onRefreshUsers(
      RefreshUsers event, Emitter<UserListState> emit) async {
    try {
      _skip = 0;
      _users = await userRepository.fetchUsers(limit: _limit, skip: _skip);
      _hasMore = _users.length == _limit;
      emit(UserListLoadSuccess(List.from(_users), hasMore: _hasMore));
    } catch (e) {
      emit(UserListError(e.toString()));
    }
  }


  Future<void > _onSearchUsers(
      SearchUsers event,
      Emitter<UserListState> emit,
      )async{
    final query=event.query.trim();
    if(query.isEmpty){
      add(LoadUsers());
      return;
    }

    emit(UserListLoading());
    try{
      final results=await userRepository.searchUsersByUsername(query);
      emit(UserListLoadSuccess(results,hasMore: false));
    }catch(e){
      emit(UserListError(e.toString()));
    }
  }
}
