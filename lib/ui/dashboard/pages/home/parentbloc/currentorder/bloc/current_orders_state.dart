part of 'current_orders_bloc.dart';

@immutable
abstract class CurrentOrdersState {}

class CurrentOrdersInitial extends CurrentOrdersState {}
// class OnCurrentOrderLoaded extends CurrentOrdersState {}
class OnCurrentOrderLoaded extends CurrentOrdersState {
  final CurrentOrdersModel currentOrdersModel;

  OnCurrentOrderLoaded(this.currentOrdersModel);
}
class OnCurrentOrderLoading extends CurrentOrdersState {}
class OnErrorCurrentOrder extends CurrentOrdersState {}
