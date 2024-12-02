import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:toastification/toastification.dart';

part 'toast.g.dart';

@Riverpod(keepAlive: true)
class ToastNotifier extends _$ToastNotifier {
  @override
  ToastificationItem build() => toastification.showCustom(
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 15),
        builder: (_, ToastificationItem item) => const SizedBox(),
      );

  @override
  set state(ToastificationItem value) => super.state = value;

  dismiss() => toastification.dismiss(state);

  closingIfOpen() {
    if (state.isStarted) toastification.dismiss(state);
  }
}
