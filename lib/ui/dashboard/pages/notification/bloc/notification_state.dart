part of 'notification_bloc.dart';

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}
class NotificationLoadingState extends NotificationState {}
class NotificationErrorState extends NotificationState {}
class OnNotificationLoadedState extends NotificationState {
  final NotificationListModel notificationListModel;

  OnNotificationLoadedState(this.notificationListModel);
}