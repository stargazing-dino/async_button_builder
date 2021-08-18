import 'package:async_button_core/async_button_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// The result of an asynchoous button
@immutable
class AsyncButtonResult {
  /// The child of the button
  final Widget child;

  /// Passed to the Button in place of the original onTap/onPressed variant
  final AsyncCallback? callback;

  /// The state the button is currently in
  final ButtonState buttonState;

  const AsyncButtonResult({
    required this.child,
    required this.callback,
    required this.buttonState,
  });
}
