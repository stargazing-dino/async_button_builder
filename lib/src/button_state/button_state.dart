import 'package:freezed_annotation/freezed_annotation.dart';

part 'button_state.freezed.dart';

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
@freezed
abstract class ButtonState with _$ButtonState {
  const factory ButtonState.idle() = Idle;
  const factory ButtonState.loading() = Loading;
  const factory ButtonState.success() = Success;
  const factory ButtonState.error() = Error;
}
