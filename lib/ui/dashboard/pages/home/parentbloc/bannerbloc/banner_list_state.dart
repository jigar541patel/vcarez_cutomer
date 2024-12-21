part of 'banner_list_bloc.dart';

@immutable
abstract class BannerListState {}

class BannerListInitial extends BannerListState {}
class ErrorDataLoading extends BannerListState {}
class OnBannerLoaded extends BannerListState {
  final BannerListModel bannerListModel;

  OnBannerLoaded(this.bannerListModel);
}
