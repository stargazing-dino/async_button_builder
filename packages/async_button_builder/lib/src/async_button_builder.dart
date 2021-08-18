import 'dart:async';

import 'package:async_button_core/async_button_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AsyncButtonBuilder extends StatefulWidget implements AsyncButton {
  @override
  final AsyncButtonBuilderCallback builder;

  @override
  final Widget child;

  @override
  final Duration duration;

  @override
  final Duration reverseDuration;

  @override
  final AsyncCallback? onPressed;

  @override
  final ButtonState buttonState;

  @override
  final bool disabled;

  @override
  final Widget? loadingWidget;

  @override
  final Widget? successWidget;

  @override
  final Widget? errorWidget;

  @override
  final bool showSuccess;

  @override
  final bool showError;

  @override
  final EdgeInsets? errorPadding;

  @override
  final EdgeInsets? successPadding;

  @override
  final AnimatedSwitcherTransitionBuilder idleTransitionBuilder;

  @override
  final AnimatedSwitcherTransitionBuilder loadingTransitionBuilder;

  @override
  final AnimatedSwitcherTransitionBuilder successTransitionBuilder;

  @override
  final AnimatedSwitcherTransitionBuilder errorTransitionBuilder;

  @override
  final Duration successDuration;

  @override
  final Duration errorDuration;

  @override
  final Curve idleSwitchInCurve;

  @override
  final Curve loadingSwitchInCurve;

  @override
  final Curve successSwitchInCurve;

  @override
  final Curve errorSwitchInCurve;

  @override
  final Curve idleSwitchOutCurve;

  @override
  final Curve loadingSwitchOutCurve;

  @override
  final Curve successSwitchOutCurve;

  @override
  final Curve errorSwitchOutCurve;

  @override
  final Curve sizeCurve;

  @override
  final Clip sizeClipBehavior;

  @override
  final Alignment sizeAlignment;

  @override
  final bool animateSize;

  const AsyncButtonBuilder({
    Key? key,
    required this.child,
    required this.onPressed,
    required this.builder,
    this.loadingWidget,
    this.successWidget,
    this.errorWidget,
    this.showSuccess = true,
    this.showError = true,
    this.errorPadding,
    this.successPadding,
    this.buttonState = const ButtonState.idle(),
    this.duration = const Duration(milliseconds: 250),
    this.reverseDuration = const Duration(milliseconds: 250),
    this.disabled = false,
    this.successDuration = const Duration(seconds: 1),
    this.errorDuration = const Duration(seconds: 1),
    this.loadingTransitionBuilder = AnimatedSwitcher.defaultTransitionBuilder,
    this.idleTransitionBuilder = AnimatedSwitcher.defaultTransitionBuilder,
    this.successTransitionBuilder = AnimatedSwitcher.defaultTransitionBuilder,
    this.errorTransitionBuilder = AnimatedSwitcher.defaultTransitionBuilder,
    this.idleSwitchInCurve = Curves.linear,
    this.loadingSwitchInCurve = Curves.linear,
    this.successSwitchInCurve = Curves.linear,
    this.errorSwitchInCurve = Curves.linear,
    this.idleSwitchOutCurve = Curves.linear,
    this.loadingSwitchOutCurve = Curves.linear,
    this.successSwitchOutCurve = Curves.linear,
    this.errorSwitchOutCurve = Curves.linear,
    this.sizeCurve = Curves.linear,
    this.sizeClipBehavior = Clip.hardEdge,
    this.sizeAlignment = Alignment.center,
    this.animateSize = true,
  }) : super(key: key);
  // TODO: I need asserts that will assert the keys are different for child,
  // loading, error, etc. because otherwise transitions won't work as expected
  // and I'll get user issues

  @override
  _AsyncButtonBuilderState createState() => _AsyncButtonBuilderState();
}

class _AsyncButtonBuilderState extends State<AsyncButtonBuilder>
    with SingleTickerProviderStateMixin {
  late ButtonState buttonState;
  Timer? timer;

  @override
  void initState() {
    buttonState = widget.buttonState;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AsyncButtonBuilder oldWidget) {
    if (widget.buttonState != oldWidget.buttonState) {
      setState(() {
        buttonState = buttonState;
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onPressed = widget.onPressed;
    final widgetKey = widget.key;
    final loadingWidget = widget.loadingWidget ??
        const SizedBox(
          height: 16.0,
          width: 16.0,
          child: CircularProgressIndicator(),
        );
    var successWidget = widget.successWidget ??
        Icon(
          Icons.check,
          color: theme.colorScheme.secondary,
        );
    var errorWidget = widget.errorWidget ??
        Icon(
          Icons.error,
          color: theme.errorColor,
        );
    final successPadding = widget.successPadding;
    final errorPadding = widget.errorPadding;

    // This is necessary in the case of nested async button builders.
    // We cannot have the same __idle__, __loading__, etc. keys as they might
    // conflict with one another.
    String parentKeyValue = '';

    if (widgetKey != null && widgetKey is ValueKey) {
      parentKeyValue = widgetKey.value.toString();
    }

    if (successPadding != null) {
      successWidget = Padding(
        padding: successPadding,
        child: successWidget,
      );
    }

    if (errorPadding != null) {
      errorWidget = Padding(
        padding: errorPadding,
        child: errorWidget,
      );
    }

    final switcher = AnimatedSwitcher(
      // TODO: This duration is same as size's duration. That's okay right?
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
      switchInCurve: buttonState.when(
        idle: () => widget.idleSwitchInCurve,
        loading: () => widget.loadingSwitchInCurve,
        success: () => widget.successSwitchInCurve,
        error: () => widget.errorSwitchInCurve,
      ),
      switchOutCurve: buttonState.when(
        idle: () => widget.idleSwitchOutCurve,
        loading: () => widget.loadingSwitchOutCurve,
        success: () => widget.successSwitchOutCurve,
        error: () => widget.errorSwitchOutCurve,
      ),
      transitionBuilder: buttonState.when(
        idle: () => widget.idleTransitionBuilder,
        loading: () => widget.loadingTransitionBuilder,
        success: () => widget.successTransitionBuilder,
        error: () => widget.errorTransitionBuilder,
      ),
      child: buttonState.when(
        idle: () => KeyedSubtree(
          key: ValueKey('__idle__' + parentKeyValue),
          child: widget.child,
        ),
        loading: () => KeyedSubtree(
          key: ValueKey('__loading__' + parentKeyValue),
          child: loadingWidget,
        ),
        success: () => KeyedSubtree(
          key: ValueKey('__success__' + parentKeyValue),
          child: successWidget,
        ),
        error: () => KeyedSubtree(
          key: ValueKey('__error__' + parentKeyValue),
          child: errorWidget,
        ),
      ),
    );

    return widget.builder(
      context,
      // TODO: I really just wanted an AnimatedSwitcher and the default
      // transitionBuilder to be a SizedTransition but it was impossible
      // to figure out how to reproduce the exact behaviour of AnimatedSize
      widget.animateSize
          ? AnimatedSize(
              vsync: this,
              duration: widget.duration,
              reverseDuration: widget.reverseDuration,
              alignment: widget.sizeAlignment,
              clipBehavior: widget.sizeClipBehavior,
              curve: widget.sizeCurve,
              child: switcher,
            )
          : switcher,
      widget.disabled
          ? null
          : onPressed == null
              ? null
              : buttonState.maybeWhen(
                  idle: () => () {
                    final completer = Completer<void>();
                    // I might not want to set buttonState if we're being
                    // driven by widget.buttonState...
                    setState(() {
                      buttonState = const ButtonState.loading();
                    });

                    timer?.cancel();

                    onPressed.call().then((_) {
                      completer.complete();

                      if (mounted) {
                        if (widget.showSuccess) {
                          setState(() {
                            buttonState = const ButtonState.success();
                          });

                          setTimer(widget.successDuration);
                        } else {
                          setState(() {
                            buttonState = const ButtonState.idle();
                          });
                        }
                      }
                    }).catchError((Object error, StackTrace stackTrace) {
                      completer.completeError(error, stackTrace);

                      if (mounted) {
                        if (widget.showError) {
                          setState(() {
                            buttonState = const ButtonState.error();
                          });

                          setTimer(widget.errorDuration);
                        } else {
                          setState(() {
                            buttonState = const ButtonState.idle();
                          });
                        }
                      }
                    });

                    return completer.future;
                  },
                  orElse: () => null,
                ),
      buttonState,
    );
  }

  void setTimer(Duration duration) {
    timer = Timer(
      duration,
      () {
        timer?.cancel();

        if (mounted) {
          setState(() {
            buttonState = const ButtonState.idle();
          });
        }
      },
    );
  }
}
