part of 'privilege_plan_bloc.dart';

@immutable
abstract class PrivilegePlanState {}

class PrivilegePlanInitial extends PrivilegePlanState {}

class BuySubscriptionLoadingState extends PrivilegePlanState {}

class BuySubscriptionSuccessState extends PrivilegePlanState {
  final BuyPlanSuccessModel buyPlanSuccessModel;

  BuySubscriptionSuccessState(this.buyPlanSuccessModel);
}

class BuySubscriptionErrorState extends PrivilegePlanState {}

class PrivilegePlanLoading extends PrivilegePlanState {}

class ErrorPrivilegePlanLoading extends PrivilegePlanState {}

class PrivilegePlanDataLoaded extends PrivilegePlanState {
  final PrivilegePlanModel privilegePlanModel;

  PrivilegePlanDataLoaded(this.privilegePlanModel);
}

class VerifyPlanOrderSubmittingState extends PrivilegePlanState {}

class VerifyPlanOrderSuccessState extends PrivilegePlanState {
  final VerifyCFModel verifyCFModel;

  VerifyPlanOrderSuccessState(this.verifyCFModel);
}

class VerifyPlanOrderFailureState extends PrivilegePlanState {}
