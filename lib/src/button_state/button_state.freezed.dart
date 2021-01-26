// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'button_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$ButtonStateTearOff {
  const _$ButtonStateTearOff();

  Idling idle() {
    return const Idling();
  }

  Loading loading() {
    return const Loading();
  }

  Succeding success() {
    return const Succeding();
  }

  Failing error() {
    return const Failing();
  }
}

/// @nodoc
const $ButtonState = _$ButtonStateTearOff();

/// @nodoc
mixin _$ButtonState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function() success,
    required TResult Function() error,
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function()? success,
    TResult Function()? error,
    required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idling value) idle,
    required TResult Function(Loading value) loading,
    required TResult Function(Succeding value) success,
    required TResult Function(Failing value) error,
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idling value)? idle,
    TResult Function(Loading value)? loading,
    TResult Function(Succeding value)? success,
    TResult Function(Failing value)? error,
    required TResult orElse(),
  });
}

/// @nodoc
abstract class $ButtonStateCopyWith<$Res> {
  factory $ButtonStateCopyWith(
          ButtonState value, $Res Function(ButtonState) then) =
      _$ButtonStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$ButtonStateCopyWithImpl<$Res> implements $ButtonStateCopyWith<$Res> {
  _$ButtonStateCopyWithImpl(this._value, this._then);

  final ButtonState _value;
  // ignore: unused_field
  final $Res Function(ButtonState) _then;
}

/// @nodoc
abstract class $IdlingCopyWith<$Res> {
  factory $IdlingCopyWith(Idling value, $Res Function(Idling) then) =
      _$IdlingCopyWithImpl<$Res>;
}

/// @nodoc
class _$IdlingCopyWithImpl<$Res> extends _$ButtonStateCopyWithImpl<$Res>
    implements $IdlingCopyWith<$Res> {
  _$IdlingCopyWithImpl(Idling _value, $Res Function(Idling) _then)
      : super(_value, (v) => _then(v as Idling));

  @override
  Idling get _value => super._value as Idling;
}

/// @nodoc
class _$Idling implements Idling {
  const _$Idling();

  @override
  String toString() {
    return 'ButtonState.idle()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Idling);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function() success,
    required TResult Function() error,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function()? success,
    TResult Function()? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idling value) idle,
    required TResult Function(Loading value) loading,
    required TResult Function(Succeding value) success,
    required TResult Function(Failing value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idling value)? idle,
    TResult Function(Loading value)? loading,
    TResult Function(Succeding value)? success,
    TResult Function(Failing value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class Idling implements ButtonState {
  const factory Idling() = _$Idling;
}

/// @nodoc
abstract class $LoadingCopyWith<$Res> {
  factory $LoadingCopyWith(Loading value, $Res Function(Loading) then) =
      _$LoadingCopyWithImpl<$Res>;
}

/// @nodoc
class _$LoadingCopyWithImpl<$Res> extends _$ButtonStateCopyWithImpl<$Res>
    implements $LoadingCopyWith<$Res> {
  _$LoadingCopyWithImpl(Loading _value, $Res Function(Loading) _then)
      : super(_value, (v) => _then(v as Loading));

  @override
  Loading get _value => super._value as Loading;
}

/// @nodoc
class _$Loading implements Loading {
  const _$Loading();

  @override
  String toString() {
    return 'ButtonState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Loading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function() success,
    required TResult Function() error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function()? success,
    TResult Function()? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idling value) idle,
    required TResult Function(Loading value) loading,
    required TResult Function(Succeding value) success,
    required TResult Function(Failing value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idling value)? idle,
    TResult Function(Loading value)? loading,
    TResult Function(Succeding value)? success,
    TResult Function(Failing value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class Loading implements ButtonState {
  const factory Loading() = _$Loading;
}

/// @nodoc
abstract class $SuccedingCopyWith<$Res> {
  factory $SuccedingCopyWith(Succeding value, $Res Function(Succeding) then) =
      _$SuccedingCopyWithImpl<$Res>;
}

/// @nodoc
class _$SuccedingCopyWithImpl<$Res> extends _$ButtonStateCopyWithImpl<$Res>
    implements $SuccedingCopyWith<$Res> {
  _$SuccedingCopyWithImpl(Succeding _value, $Res Function(Succeding) _then)
      : super(_value, (v) => _then(v as Succeding));

  @override
  Succeding get _value => super._value as Succeding;
}

/// @nodoc
class _$Succeding implements Succeding {
  const _$Succeding();

  @override
  String toString() {
    return 'ButtonState.success()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Succeding);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function() success,
    required TResult Function() error,
  }) {
    return success();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function()? success,
    TResult Function()? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idling value) idle,
    required TResult Function(Loading value) loading,
    required TResult Function(Succeding value) success,
    required TResult Function(Failing value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idling value)? idle,
    TResult Function(Loading value)? loading,
    TResult Function(Succeding value)? success,
    TResult Function(Failing value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class Succeding implements ButtonState {
  const factory Succeding() = _$Succeding;
}

/// @nodoc
abstract class $FailingCopyWith<$Res> {
  factory $FailingCopyWith(Failing value, $Res Function(Failing) then) =
      _$FailingCopyWithImpl<$Res>;
}

/// @nodoc
class _$FailingCopyWithImpl<$Res> extends _$ButtonStateCopyWithImpl<$Res>
    implements $FailingCopyWith<$Res> {
  _$FailingCopyWithImpl(Failing _value, $Res Function(Failing) _then)
      : super(_value, (v) => _then(v as Failing));

  @override
  Failing get _value => super._value as Failing;
}

/// @nodoc
class _$Failing implements Failing {
  const _$Failing();

  @override
  String toString() {
    return 'ButtonState.error()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Failing);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function() success,
    required TResult Function() error,
  }) {
    return error();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function()? success,
    TResult Function()? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idling value) idle,
    required TResult Function(Loading value) loading,
    required TResult Function(Succeding value) success,
    required TResult Function(Failing value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idling value)? idle,
    TResult Function(Loading value)? loading,
    TResult Function(Succeding value)? success,
    TResult Function(Failing value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class Failing implements ButtonState {
  const factory Failing() = _$Failing;
}
