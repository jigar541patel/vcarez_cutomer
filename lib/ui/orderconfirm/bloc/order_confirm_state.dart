part of 'order_confirm_bloc.dart';

@immutable
abstract class OrderConfirmState {}

class OrderConfirmInitial extends OrderConfirmState {}

class OrderConfirmSuccessState extends OrderConfirmState {
  final OrderAcceptSuccessModel orderAcceptSuccessModel;

  OrderConfirmSuccessState(this.orderAcceptSuccessModel);
}

class OrderConfirmProgressState extends OrderConfirmState {}

class OrderConfirmFailureState extends OrderConfirmState {}
