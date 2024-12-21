part of 'privilege_plan_bloc.dart';

@immutable
abstract class PrivilegePlanEvent {}

class GetPrivilegePlanEvent extends PrivilegePlanEvent {}

class BuySubscriptionSubmittedEvent extends PrivilegePlanEvent {
  final String planID;
  final String planPurchaseToken;

  BuySubscriptionSubmittedEvent(this.planID,this.planPurchaseToken);
}

class VerifyPlanOrderIDEvent extends PrivilegePlanEvent {
  final String strOrderID;

  VerifyPlanOrderIDEvent(this.strOrderID);
}
