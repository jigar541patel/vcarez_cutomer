import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

enum InternetState { initialState, lostState, gainedState }

Connectivity _connectivity = Connectivity();
StreamSubscription? connectivitySubscription;

class InternetCubit extends Cubit<InternetState> {
  InternetCubit() : super(InternetState.initialState) {
    connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        emit(InternetState.gainedState);
      } else {
        emit(InternetState.lostState);
      }
    });
  }

  @override
  Future<void> close() {
    // TODO: implement close
    connectivitySubscription?.cancel();
    return super.close();
  }
}
