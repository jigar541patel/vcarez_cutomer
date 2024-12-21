part of 'my_address_bloc.dart';

@immutable
abstract class MyAddressState {}

class MyAddressInitial extends MyAddressState {}
class OnAddressLoading extends MyAddressState{}
class AddingAddressInProgressState extends MyAddressState{}
class DeleteAddressInProgressState extends MyAddressState{}
class AddingAddressValidCompletedState extends MyAddressState{}
class DeleteAddressValidCompletedState extends MyAddressState{}

class OnAddressLoaded extends MyAddressState {
  //final
  AddressListModel addressListModel;

  OnAddressLoaded(this.addressListModel);
}
class OnStateListLoaded extends MyAddressState {
  //final
  StateListModel stateListModel;

  OnStateListLoaded(this.stateListModel);
}
class OnCityListLoaded extends MyAddressState {
  //final
  CityListModel cityListModel;

  OnCityListLoaded(this.cityListModel);
}

class ErrorAddressLoading extends MyAddressState {}
class ErrorSaveAddressState extends MyAddressState {}
class ErrorDeleteAddressState extends MyAddressState {}
