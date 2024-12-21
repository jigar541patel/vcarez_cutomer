part of 'cart_list_bloc.dart';

@immutable
abstract class CartListState {}

class CartListInitial extends CartListState {}

class OnCartListLoaded extends CartListState {
  final CartListModel cartListModel;

  OnCartListLoaded(this.cartListModel);
}

class ErrorCartLoading extends CartListState {}
class CartLoadingState extends CartListState {}
class PlaceOrderLoadingState extends CartListState {}
class PlaceOrderSuccessState extends CartListState {}
class PlaceOrderErrorState extends CartListState {}

class UpdateCartLoadingState extends CartListState {}

class UpdateCartSuccessState extends CartListState {}

class ErrorUpdateCartLoading extends CartListState {}

class CartUpdateLoadingState extends CartListState {}
class OnAddressLoading extends CartListState {}

class OnAddressLoaded extends CartListState {
  //final
  AddressListModel addressListModel;

  OnAddressLoaded(this.addressListModel);
}

class ErrorAddressLoading extends CartListState {}

class AddToCartSubmittingState extends CartListState {}

class AddToCartSuccessState extends CartListState {}

class AddToCartFailureState extends CartListState {}

