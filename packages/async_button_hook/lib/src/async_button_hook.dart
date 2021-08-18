import 'dart:async';

import 'package:async_button_core/async_button_core.dart';
import 'package:async_button_hook/src/models/async_button_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A button that can be used to perform an asynchronous operation.
AsyncButtonResult useAsyncButton({
  required Widget child,
  required AsyncCallback? onPressed,
  Widget? loadingWidget,
  Widget? successWidget,
  Widget? errorWidget,
  bool showSuccess = true,
  bool showError = true,
  EdgeInsets? errorPadding,
  EdgeInsets? successPadding,
  ButtonState buttonState = const ButtonState.idle(),
  Duration duration = const Duration(milliseconds: 250),
  Duration reverseDuration = const Duration(milliseconds: 250),
  bool disabled = false,
  Duration successDuration = const Duration(seconds: 1),
  Duration errorDuration = const Duration(seconds: 1),
  AnimatedSwitcherTransitionBuilder loadingTransitionBuilder =
      AnimatedSwitcher.defaultTransitionBuilder,
  AnimatedSwitcherTransitionBuilder idleTransitionBuilder =
      AnimatedSwitcher.defaultTransitionBuilder,
  AnimatedSwitcherTransitionBuilder successTransitionBuilder =
      AnimatedSwitcher.defaultTransitionBuilder,
  AnimatedSwitcherTransitionBuilder errorTransitionBuilder =
      AnimatedSwitcher.defaultTransitionBuilder,
  Curve idleSwitchInCurve = Curves.linear,
  Curve loadingSwitchInCurve = Curves.linear,
  Curve successSwitchInCurve = Curves.linear,
  Curve errorSwitchInCurve = Curves.linear,
  Curve idleSwitchOutCurve = Curves.linear,
  Curve loadingSwitchOutCurve = Curves.linear,
  Curve successSwitchOutCurve = Curves.linear,
  Curve errorSwitchOutCurve = Curves.linear,
  Curve sizeCurve = Curves.linear,
  Clip sizeClipBehavior = Clip.hardEdge,
  Alignment sizeAlignment = Alignment.center,
  bool animateSize = true,
}) {
  final _buttonState = useState(buttonState);
  Timer? timer;

  useEffect(
    () {
      if (_buttonState.value != buttonState) {
        _buttonState.value = buttonState;
      }

      return () {
        timer?.cancel();
      };
    },
    [buttonState],
  );

  final ticker = useSingleTickerProvider();
  final isMounted = useIsMounted();
  final context = useContext();
  final theme = Theme.of(context);
  final _loadingWidget = loadingWidget ??
      const SizedBox(
        height: 16.0,
        width: 16.0,
        child: CircularProgressIndicator(),
      );
  var _successWidget = successWidget ??
      Icon(
        Icons.check,
        color: theme.colorScheme.secondary,
      );
  var _errorWidget = errorWidget ??
      Icon(
        Icons.error,
        color: theme.errorColor,
      );

  if (successPadding != null) {
    _successWidget = Padding(
      padding: successPadding,
      child: successWidget,
    );
  }

  if (errorPadding != null) {
    _errorWidget = Padding(
      padding: errorPadding,
      child: errorWidget,
    );
  }

  final switcher = AnimatedSwitcher(
    // TODO: This duration is same as size's duration. That's okay right?
    duration: duration,
    reverseDuration: reverseDuration,
    switchInCurve: buttonState.when(
      idle: () => idleSwitchInCurve,
      loading: () => loadingSwitchInCurve,
      success: () => successSwitchInCurve,
      error: () => errorSwitchInCurve,
    ),
    switchOutCurve: buttonState.when(
      idle: () => idleSwitchOutCurve,
      loading: () => loadingSwitchOutCurve,
      success: () => successSwitchOutCurve,
      error: () => errorSwitchOutCurve,
    ),
    transitionBuilder: buttonState.when(
      idle: () => idleTransitionBuilder,
      loading: () => loadingTransitionBuilder,
      success: () => successTransitionBuilder,
      error: () => errorTransitionBuilder,
    ),
    child: buttonState.when(
      idle: () => KeyedSubtree(
        key: const ValueKey('__idle__'),
        child: child,
      ),
      loading: () => KeyedSubtree(
        key: const ValueKey('__loading__'),
        child: _loadingWidget,
      ),
      success: () => KeyedSubtree(
        key: const ValueKey('__success__'),
        child: _successWidget,
      ),
      error: () => KeyedSubtree(
        key: const ValueKey('__error__'),
        child: _errorWidget,
      ),
    ),
  );

  void setTimer(Duration duration) {
    timer = Timer(
      duration,
      () {
        timer?.cancel();

        if (isMounted()) {
          _buttonState.value = const ButtonState.idle();
        }
      },
    );
  }

  return AsyncButtonResult(
    child: animateSize
        ? AnimatedSize(
            vsync: ticker,
            duration: duration,
            reverseDuration: reverseDuration,
            alignment: sizeAlignment,
            clipBehavior: sizeClipBehavior,
            curve: sizeCurve,
            child: switcher,
          )
        : switcher,
    callback: disabled
        ? null
        : onPressed == null
            ? null
            : buttonState.maybeWhen(
                idle: () => () {
                  final completer = Completer<void>();
                  // I might not want to set buttonState if we're being
                  // driven by buttonState...
                  _buttonState.value = const ButtonState.loading();

                  timer?.cancel();

                  onPressed.call().then((_) {
                    completer.complete();

                    if (isMounted()) {
                      if (showSuccess) {
                        _buttonState.value = const ButtonState.success();

                        setTimer(successDuration);
                      } else {
                        _buttonState.value = const ButtonState.idle();
                      }
                    }
                  }).catchError((Object error, StackTrace stackTrace) {
                    completer.completeError(error, stackTrace);

                    if (isMounted()) {
                      if (showError) {
                        _buttonState.value = const ButtonState.error();

                        setTimer(errorDuration);
                      } else {
                        _buttonState.value = const ButtonState.idle();
                      }
                    }
                  });

                  return completer.future;
                },
                orElse: () => null,
              ),
    buttonState: _buttonState.value,
  );
}
