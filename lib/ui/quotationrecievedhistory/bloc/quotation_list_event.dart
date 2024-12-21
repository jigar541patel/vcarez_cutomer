part of 'quotation_list_bloc.dart';

@immutable
abstract class QuotationListEvent {}


class GetQuotationDetailReceivedListList extends QuotationListEvent {
  String strOrderID;
  // String strTitle;

  GetQuotationDetailReceivedListList(this.strOrderID);
}
class GetQuotationList extends QuotationListEvent {
  GetQuotationList();
}


class AcceptQuoteSubmitEvent extends QuotationListEvent {
  final String strCustQuoteID;
  final List listQuotationID;

  AcceptQuoteSubmitEvent(this.strCustQuoteID, this.listQuotationID);
}
