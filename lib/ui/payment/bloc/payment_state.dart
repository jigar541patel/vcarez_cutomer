part of 'payment_bloc.dart';

@immutable
abstract class PaymentState {}

class PaymentInitial extends PaymentState {}
class CreateOrderCompletedState extends PaymentState {
  final CreateOrderModel createOrderModel;

  CreateOrderCompletedState(this.createOrderModel);
}

class CreateOrderInProgressState extends PaymentState {}

class CreateOrderInValidCompletedState extends PaymentState {}
