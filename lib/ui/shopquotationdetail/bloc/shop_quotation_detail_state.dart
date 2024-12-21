part of 'shop_quotation_detail_bloc.dart';

@immutable
abstract class ShopQuotationDetailState {}

class ShopQuotationDetailInitial extends ShopQuotationDetailState {}

class ShopQuotationDetailLoaded extends ShopQuotationDetailState {
  final ShopQuotationDetailModel shopQuotationDetailModel;

  ShopQuotationDetailLoaded(this.shopQuotationDetailModel);
}

class ErrorShopQuotationDetailLoading extends ShopQuotationDetailState {}

class ShopQuotationDetailLoading extends ShopQuotationDetailState {}

class AcceptQuoteSubmittingState extends ShopQuotationDetailState {}

class AcceptQuoteSuccessState extends ShopQuotationDetailState {}

class AcceptQuoteFailureState extends ShopQuotationDetailState {}

class VerifyOrderSubmittingState extends ShopQuotationDetailState {}

class VerifyOrderSuccessState extends ShopQuotationDetailState {
  final VerifyCFModel verifyCFModel;

  VerifyOrderSuccessState(this.verifyCFModel);
}

class VerifyOrderFailureState extends ShopQuotationDetailState {}

class SaveOrderSubmittingState extends ShopQuotationDetailState {}

class SaveOrderSuccessState extends ShopQuotationDetailState {
  final OrderAcceptSuccessModel orderAcceptSuccessModel;

  SaveOrderSuccessState(this.orderAcceptSuccessModel);
}

class SaveOrderFailureState extends ShopQuotationDetailState {}
