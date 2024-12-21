part of 'cart_list_bloc.dart';

@immutable
abstract class CartListEvent {}

class GetCartListEvent extends CartListEvent {
  GetCartListEvent();
}

class UpdateCartListEvent extends CartListEvent {
  final String strID;
  final String strQuantity;

  UpdateCartListEvent(this.strID, this.strQuantity);
}
class GetAddressListEvent extends CartListEvent {}


class PlaceOrderEvent extends CartListEvent {
  final String strDeliveryType;
  final int intAlternative;
  final String strDeliveryAddress;
  final double doubleLatitude;
  final double doubleLongitude;

  PlaceOrderEvent(this.strDeliveryType, this.intAlternative,
      this.strDeliveryAddress, this.doubleLatitude, this.doubleLongitude);
}
