part of 'feature_detail_bloc.dart';

@immutable
abstract class FeatureDetailEvent {}

class GetFeaturedBrandDetail extends FeatureDetailEvent {}
class GetFeaturedDetailProductList extends FeatureDetailEvent {}
