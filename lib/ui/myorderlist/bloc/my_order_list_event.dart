part of 'my_order_list_bloc.dart';

@immutable
abstract class MyOrderListEvent {}

class GetMyOrderList extends MyOrderListEvent {
  GetMyOrderList();
}
