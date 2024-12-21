part of 'current_orders_bloc.dart';

@immutable
abstract class CurrentOrdersEvent {}
class GetCurrentOrderList extends CurrentOrdersEvent {}
