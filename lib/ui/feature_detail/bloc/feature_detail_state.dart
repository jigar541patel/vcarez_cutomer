part of 'feature_detail_bloc.dart';

@immutable
abstract class FeatureDetailState {}

class FeatureDetailInitial extends FeatureDetailState {}
class FeaturedBrandDetailLoading extends FeatureDetailState {}
class FeaturedProductListLoading extends FeatureDetailState {}

class OnFeaturedBrandDetailLoaded extends FeatureDetailState {
  final FeaturedBrandDetailModel featuredBrandDetailModel;

  OnFeaturedBrandDetailLoaded(this.featuredBrandDetailModel);
}
class OnFeaturedProductListLoaded extends FeatureDetailState {
  final FeatureProductListModel featureProductListModel;

  OnFeaturedProductListLoaded(this.featureProductListModel);
}
class ErrorFeaturedProductListLoading extends FeatureDetailState {}
class ErrorFeaturedBrandLoading extends FeatureDetailState {}
