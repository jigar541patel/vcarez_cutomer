part of 'quotation_list_bloc.dart';

@immutable
abstract class QuotationListState {}

class QuotationReceivedListInitial extends QuotationListState {}

class OnQuotationReceivedListLoadedState extends QuotationListState {
  final QuotationReceivedListModel quotationReceivedListModel;

  OnQuotationReceivedListLoadedState(this.quotationReceivedListModel);
}
class OnQuotationListLoadedState extends QuotationListState {
  final QuotationHistoryListModel quotationHistoryListModel;

  OnQuotationListLoadedState(this.quotationHistoryListModel);
}

class ErrorQuotationReceivedListLoadingState extends QuotationListState {}
class ErrorQuotationListLoadingState extends QuotationListState {}
class QuotationReceivedListLoadingState extends QuotationListState {}
class QuotationListLoadingState extends QuotationListState {}

class AcceptQuoteSubmittingState extends QuotationListState {}
class AcceptQuoteSuccessState extends QuotationListState {}
class AcceptQuoteFailureState extends QuotationListState {}
