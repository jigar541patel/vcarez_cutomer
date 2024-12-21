part of 'order_confirm_bloc.dart';

@immutable
abstract class OrderConfirmEvent {}

class GetOrderConfirmEvent extends OrderConfirmEvent {
  final OrderAcceptSuccessModel orderAcceptSuccessModel;

  GetOrderConfirmEvent(this.orderAcceptSuccessModel);
}
