
import 'package:flutter/material.dart';
import 'package:focus/src/shared/utils/custom_exception.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
  });
  final AsyncValue<T> value;
  final Widget Function(T) data;
  final Widget? loading;
  final Widget Function(Object, StackTrace)? error;
  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: (e, st) => error != null
          ? error!(e, st)
          : Center(
              child: e is CustomException
                  ? Text((e).translations['en'].toString())
                  : const Text('Error')),
      loading: () =>
          loading ?? const Center(child: CircularProgressIndicator()),
    );
  }
}
