part of 'shop_quotation_detail_bloc.dart';

@immutable
abstract class ShopQuotationDetailEvent {}

class GetQuotationDetail extends ShopQuotationDetailEvent {
  String strQuotedID;

  // String strTitle;

  GetQuotationDetail(this.strQuotedID);
}

class AcceptQuoteSubmitEvent extends ShopQuotationDetailEvent {
  final String strCustQuoteID;
  final List listQuotationID;

  AcceptQuoteSubmitEvent(this.strCustQuoteID, this.listQuotationID);
}

class VerifyOrderIDEvent extends ShopQuotationDetailEvent {
  final String strOrderID;

  VerifyOrderIDEvent(this.strOrderID);
}

class SaveQuoteSubmitEvent extends ShopQuotationDetailEvent {
  final String strCustQuoteID;
  final String strCfOrderID;
  final String strPaymentMethod;
  final String strPaymentStatus;
  final List listQuotationID;

  SaveQuoteSubmitEvent(this.strCustQuoteID, this.listQuotationID,
      this.strCfOrderID, this.strPaymentMethod, this.strPaymentStatus);
}
