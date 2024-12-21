part of 'my_order_list_bloc.dart';

@immutable
abstract class MyOrderListState {}

class MyOrderListInitial extends MyOrderListState {}

class OnMyOrderListLoadedState extends MyOrderListState {
  final MyOrderListModel myOrderListModel;

  OnMyOrderListLoadedState(this.myOrderListModel);
}

class ErrorMyOrderListLoadingState extends MyOrderListState {}

class MyOrderListLoadingState extends MyOrderListState {}
