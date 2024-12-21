part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class GetLocationState extends HomeState {}

class GetBannerState extends HomeState {}

class OnLocationLoadedState extends HomeState {
  final String? strLocation;

  OnLocationLoadedState(this.strLocation);
}

class DataLoading extends HomeState {}

class HomeCartLoadingState extends HomeState {}

class OnHomeCartListLoaded extends HomeState {
  final CartListModel cartListModel;

  OnHomeCartListLoaded(this.cartListModel);
}

class ErrorHomeCartLoading extends HomeState {}

class CartHomeLoadingState extends HomeState {}

class AddToCartSubmittingState extends HomeState {}
class AddToCartSuccessState extends HomeState {}

class AddToCartFailureState extends HomeState {}
