part of 'my_address_bloc.dart';

@immutable
abstract class MyAddressEvent {}

class GetAddressListEvent extends MyAddressEvent {}

class GetStateListEvent extends MyAddressEvent {}

class GetCityListEvent extends MyAddressEvent {
  final String strCityID;

  GetCityListEvent(this.strCityID);
}

class DeleteAddressEvent extends MyAddressEvent {
  final String strAddressID;

  DeleteAddressEvent(this.strAddressID);
}

class SaveAddressSubmittedEvent extends MyAddressEvent {
  final String strAddress;
  final String strCity;
  final String strState;
  final String strLocation;
  final String strPincode;
  final String strLatitude;
  final String strLongitude;

  SaveAddressSubmittedEvent(this.strAddress, this.strCity, this.strState,
      this.strLocation, this.strLatitude, this.strLongitude, this.strPincode);
}

class UpdateAddressSubmittedEvent extends MyAddressEvent {
  final String strAddressID;
  final String strAddress;
  final String strCity;
  final String strState;
  final String strLocation;
  final String strPincode;
  final String strLatitude;
  final String strLongitude;

  UpdateAddressSubmittedEvent(
      this.strAddressID,
      this.strAddress,
      this.strCity,
      this.strState,
      this.strLocation,
      this.strLatitude,
      this.strLongitude,
      this.strPincode);
}
