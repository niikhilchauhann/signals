import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/legacy.dart';
import '/core/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectionStatus { connected, disconnected }

final connectivityProvider =
    StateNotifierProvider<ConnectivityNotifier, ConnectionStatus>(
      (ref) => ConnectivityNotifier(),
    );

class ConnectivityNotifier extends StateNotifier<ConnectionStatus> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityNotifier() : super(ConnectionStatus.connected) {
    _checkInitialConnection();
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      state = (result.first == ConnectivityResult.none)
          ? ConnectionStatus.disconnected
          : ConnectionStatus.connected;
    });
  }

  Future<void> _checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    state = (result.first == ConnectivityResult.none)
        ? ConnectionStatus.disconnected
        : ConnectionStatus.connected;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class ConnectivityWrapper extends ConsumerWidget {
  final Widget child;

  const ConnectivityWrapper({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<ConnectionStatus>(connectivityProvider, (previous, next) {
      if (next == ConnectionStatus.disconnected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No Internet Connection."),
            backgroundColor: AppColors.secondaryViolet,
            duration: Duration(minutes: 5),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    });
    return child;
  }
}
