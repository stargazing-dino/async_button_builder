import 'package:freezed_annotation/freezed_annotation.dart';

part 'button_state.freezed.dart';

/// This union class represents the state of the button in either a [Normal],
/// [Loading] or [Completing] state. This can be considered a enum with extra
/// utilities for ease of use.
///
/// {@tool snippet}
///
/// ```dart
/// final buttonColor = buttonState.when(
///   idling: () => Colors.pink,
///   loading: () => Colors.blue,
///   completing: () => Colors.green,
///   erroring: () => Colors.red,
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
///   idling: () => Colors.pink,
///   orElse: () => Colors.red,
/// );
/// ```
/// {@end-tool}
@freezed
abstract class ButtonState with _$ButtonState {
  const factory ButtonState.idling() = Idling;
  const factory ButtonState.loading() = Loading;
  const factory ButtonState.completing() = Completing;
  const factory ButtonState.erroring() = Erroring;
}
