import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_ng/blocs/user_detail/user_detail_event.dart';
import 'package:task_ng/blocs/user_detail/user_detail_state.dart';
import 'package:task_ng/repositories/user_repository.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  final UserRepository userRepository;
  UserDetailBloc(this.userRepository) : super(UserDetailInitial()) {
    on<LoadUserPosts>(_onLoadUserPosts);
    on<LoadUserTodos>(_onLoadUserTodos);
  }

  Future<void> _onLoadUserPosts(
    LoadUserPosts event,
    Emitter<UserDetailState> emit,
  ) async {
    emit(UserPostsLoading());
    try{
      final posts=await userRepository.fetchPostsByUser(event.userId);
      emit(UserPostsLoaded(posts));
    }catch(e){
      emit(UserDetailError(e.toString()));
    }
  }
  Future<void> _onLoadUserTodos(
      LoadUserTodos event, Emitter<UserDetailState> emit) async {
    emit(UserTodosLoading());
    try {
      final todos = await userRepository.fetchTodosByUser(event.userId);
      emit(UserTodosLoaded(todos));
    } catch (e) {
      emit(UserDetailError(e.toString()));
    }
  }
}
