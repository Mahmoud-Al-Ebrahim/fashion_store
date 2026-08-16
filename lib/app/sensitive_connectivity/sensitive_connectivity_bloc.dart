import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/utils/show_message.dart';


part 'sensitive_connectivity_event.dart';
part 'sensitive_connectivity_state.dart';

class SensitiveConnectivityBloc extends Bloc<SensitiveConnectivityEvent, SensitiveConnectivityState> {
  SensitiveConnectivityBloc() : super(ConnectivityOfflineState()) {
    on<ChangeConnectivityEvent>(_onCheckConnectivity);
  }

  void _onCheckConnectivity(
    ChangeConnectivityEvent event,
    Emitter<SensitiveConnectivityState> emit,
  ) async {


    if (event.connectivityResult == ConnectivityResult.mobile) {
      showMessage("The Internet Connection has been restored",foreGroundColor: Colors.green,showInRelease: true,timeShowing: Toast.LENGTH_SHORT);
      emit(ConnectivityCellularState());
    } else if (event.connectivityResult == ConnectivityResult.wifi) {
      showMessage("The Internet Connection has been restored",foreGroundColor: Colors.green,showInRelease: true,timeShowing: Toast.LENGTH_SHORT);
      emit(ConnectivityWifiState());
    } else if(event.connectivityResult == ConnectivityResult.none){
      showMessage("You Lost The internet Connection",showInRelease: true,timeShowing: Toast.LENGTH_LONG);
      emit(ConnectivityOfflineState());
    }
  }
}
