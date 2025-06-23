import 'package:bloc/bloc.dart';
import 'package:vipromi/models/user_data.dart';
import 'package:vipromi/repositories/auth_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent,HomeState>{
  final AuthRepository authRepository;
  HomeBloc({required this.authRepository}):super(HomeInitialState()){
    on<LoadUserData>((event,emit)async{
      emit(HomeLoadingData());
      try{
        final user=authRepository.getCurrentUser();
        if(user==null){
          emit(HomeLoadDataError('User is not logged in'));
          return;
        }
        final userData=await authRepository.getUserData(user.uid);
        if(userData!=null){
          emit(HomeDataLoadSuccess(userData));
        }else{
          emit(HomeLoadDataError('User data not found'));
        }
      }catch(e){
        emit(HomeLoadDataError('Something went wrong:$e'));
      }
    });
  }
}