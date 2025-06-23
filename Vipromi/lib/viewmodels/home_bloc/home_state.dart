part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState{
}

class HomeLoadingData extends HomeState{

}
class HomeDataLoadSuccess extends HomeState{
  final UserData userData;
  HomeDataLoadSuccess(this.userData);
}
class HomeLoadDataError extends HomeState{
  final String errorMessage;
  HomeLoadDataError(this.errorMessage);
}