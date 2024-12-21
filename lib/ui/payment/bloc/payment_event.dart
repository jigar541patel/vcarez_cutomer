part of 'payment_bloc.dart';

@immutable
abstract class PaymentEvent {}

class CreateOrderSubmittedEvent extends PaymentEvent {
  final String strAmount;

   CreateOrderSubmittedEvent(this.strAmount);
}
