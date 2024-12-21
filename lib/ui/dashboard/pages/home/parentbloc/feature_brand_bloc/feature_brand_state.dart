part of 'feature_brand_bloc.dart';

@immutable
abstract class FeatureBrandState {}

class FeatureBrandInitial extends FeatureBrandState {}
class OnFeatureBrandLoaded extends FeatureBrandState {
  final FeatureBrandModel featureBrandModel;

  OnFeatureBrandLoaded(this.featureBrandModel);
}
class ErrorFeatureBrandLoading extends FeatureBrandState {}
class FeatureBrandLoading extends FeatureBrandState {}

