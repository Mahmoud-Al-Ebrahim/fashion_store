import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sensitive_connectivity_bloc.dart';

class ConnectivityObserver {
  static ConnectivityObserver? instance;
  static createInstance(BuildContext context) {
    instance ??= ConnectivityObserver();
    Connectivity().onConnectivityChanged.listen((event) {
      BlocProvider.of<SensitiveConnectivityBloc>(context).add(
        ChangeConnectivityEvent(connectivityResult: event.first),
      );
    });
  }
}
