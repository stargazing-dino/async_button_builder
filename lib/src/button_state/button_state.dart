// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'button_state.freezed.dart';

/// This union class represents the state of the button in either a [Idling],
/// [Loading], [Success] or [Error] state. This can be considered a enum with extra
/// utilities for ease of use.
///
/// {@tool snippet}
///
/// ```dart
/// final buttonColor = buttonState.when(
///   idle: () => Colors.pink,
///   loading: () => Colors.blue,
///   success: () => Colors.green,
///   error: () => Colors.red,
/// );
/// ```
/// {@end-tool}
///
/// You can also disregard other states and handle only those you'd like using
/// the `.maybeWhen` syntax.
///
/// /// {@tool snippet}
///
/// ```dart
/// final buttonColor = buttonState.maybeWhen(
///   idle: () => Colors.pink,
///   orElse: () => Colors.red,
/// );
/// ```
/// {@end-tool}
// @freezed
// class ButtonState with _$ButtonState {
//   const factory ButtonState.idle() = Idle;
//   const factory ButtonState.loading() = Loading;
//   const factory ButtonState.success() = Success;
//   const factory ButtonState.error() = Error;
// }

enum ButtonState {
  idle,
  loading,
  success,
  error;

  T when<T extends Object?>({
    required T Function() idle,
    required T Function() loading,
    required T Function() success,
    required T Function() error,
  }) {
    switch (this) {
      case ButtonState.idle:
        return idle();
      case ButtonState.loading:
        return loading();
      case ButtonState.success:
        return success();
      case ButtonState.error:
        return error();
    }
  }

  T maybeWhen<T extends Object?>({
    T Function()? idle,
    T Function()? loading,
    T Function()? success,
    T Function()? error,
    required T Function() orElse,
  }) {
    T functionOrElse(T Function()? function) {
      if (function != null) {
        return function();
      } else {
        return orElse();
      }
    }

    switch (this) {
      case ButtonState.idle:
        return functionOrElse(idle);
      case ButtonState.loading:
        return functionOrElse(loading);
      case ButtonState.success:
        return functionOrElse(success);
      case ButtonState.error:
        return functionOrElse(error);
    }
  }
}
