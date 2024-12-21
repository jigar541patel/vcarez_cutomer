import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../shopquotationdetail/model/order_accept_success_model.dart';

part 'order_confirm_event.dart';
part 'order_confirm_state.dart';

class OrderConfirmBloc extends Bloc<OrderConfirmEvent, OrderConfirmState> {
  OrderConfirmBloc() : super(OrderConfirmInitial()) {
    on<GetOrderConfirmEvent>((event, emit) {
      // TODO: implement event handler

     emit.call(OrderConfirmSuccessState(event.orderAcceptSuccessModel));
    });
  }
}
