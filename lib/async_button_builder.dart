import 'dart:async';

import 'package:async_button_builder/src/button_state/button_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A `builder` that wraps a button automatically providing disabled and loading
/// states while retaining full access to a Button's API. Useful for any long
/// running operations or to prevent the user from clicking multiple times
/// while an asynchronous task is running.
class AsyncButtonBuilder extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    Widget child,
    AsyncCallback? callback,
    ButtonState buttonState,
  ) builder;

  /// The child of the button. In the case of an [IconButton], this can be a an
  /// [Icon]. For a [TextButton], a [Text].
  ///
  /// This child will be animated between for the [loadingWidget] or default
  /// [CircularProgressIndicator] when the asynchronous [onPressed] is called.
  /// The animation will take place over [duration].
  final Widget child;

  /// The animation's duration between [child] and [loadingWidget] using
  /// [AnimatedSize].
  final Duration duration;

  /// A callback that runs the async task. This is wrapped in order to begin
  /// the button's internal `isLoading` before and after the operation
  /// completes.
  final AsyncCallback onPressed;

  /// This is used to manually drive the state of the loading button thus
  /// initiating the corresponding animation and button state
  ///
  /// Until otherwise requested, if the button is not loading it will still
  /// respond to presses and change the internal `isLoading`. In that case,
  /// this `isLoading` will not match the actual one of the widget.
  final ButtonState buttonState;

  /// This is used to manually drive the disabled state of the button.
  final bool disabled;

  /// The widget used to replace the [child] when the button is in a loading
  /// state. If this is null the default widget is:
  ///
  /// SizedBox(
  ///   height: 16.0,
  ///   width: 16.0,
  ///   child: CircularProgressIndicator(
  ///     valueColor: valueColor,
  ///   ),
  /// )
  final Widget loadingWidget;

  final AnimatedSwitcherTransitionBuilder idlingTransitionBuilder;

  final AnimatedSwitcherTransitionBuilder loadingTransitionBuilder;

  final AnimatedSwitcherTransitionBuilder completingTransitionBuilder;

  final AnimatedSwitcherTransitionBuilder erroringTransitionBuilder;

  /// The widget used to replace the [child] when the button is in a completing
  /// state. If this is null the default widget is:
  ///
  /// SizedBox(
  ///   height: 16.0,
  ///   width: 16.0,
  ///   child: Icons(Icon.check)
  /// )
  final Widget completingWidget;

  final Duration completingIdleTime;

  final Duration erroringIdleTime;

  final Widget erroringWidget;

  final Curve switchInCurve;

  final Curve switchOutCurve;

  const AsyncButtonBuilder({
    Key? key,
    required this.child,
    required this.onPressed,
    required this.builder,
    this.duration = const Duration(milliseconds: 250),
    this.buttonState = const ButtonState.idling(),
    this.disabled = false,
    this.completingIdleTime = const Duration(seconds: 1),
    this.erroringIdleTime = const Duration(seconds: 1),
    this.loadingWidget = const SizedBox(
      height: 16.0,
      width: 16.0,
      child: CircularProgressIndicator(),
    ),
    this.completingWidget = const Icon(
      Icons.check,
      color: Colors.green,
    ),
    this.erroringWidget = const Icon(
      Icons.error,
      color: Colors.red,
    ),
    this.loadingTransitionBuilder = AnimatedSwitcher.defaultTransitionBuilder,
    this.idlingTransitionBuilder = AnimatedSwitcher.defaultTransitionBuilder,
    this.completingTransitionBuilder =
        AnimatedSwitcher.defaultTransitionBuilder,
    this.erroringTransitionBuilder = AnimatedSwitcher.defaultTransitionBuilder,
    this.switchInCurve = Curves.linear,
    this.switchOutCurve = Curves.linear,
  }) : super(key: key);

  @override
  _AsyncButtonBuilderState createState() => _AsyncButtonBuilderState();
}

class _AsyncButtonBuilderState extends State<AsyncButtonBuilder>
    with SingleTickerProviderStateMixin {
  late ButtonState buttonState;
  late final AnimationController controller;
  Timer? timer;

  @override
  void initState() {
    buttonState = widget.buttonState;
    // am I going to need a different controller for each animation?
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
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      AnimatedSize(
        duration: widget.duration,
        vsync: this,
        child: AnimatedSwitcher(
          switchInCurve: widget.switchInCurve,
          duration: widget.duration,
          transitionBuilder: buttonState.when(
            idling: () => widget.idlingTransitionBuilder,
            loading: () => widget.loadingTransitionBuilder,
            completing: () => widget.completingTransitionBuilder,
            erroring: () => widget.erroringTransitionBuilder,
          ),
          child: buttonState.when(
            idling: () => widget.child,
            loading: () => widget.loadingWidget,
            completing: () => widget.completingWidget,
            erroring: () => widget.erroringWidget,
          ),
        ),
      ),
      widget.disabled
          ? null
          : buttonState.maybeWhen(
              idling: () => () async {
                // FIXME: I might not want to set buttonState if we're being
                // driven by widget.buttonState...
                setState(() {
                  buttonState = ButtonState.loading();
                });

                try {
                  await widget.onPressed();

                  timer?.cancel();

                  if (mounted) {
                    setState(() {
                      buttonState = ButtonState.completing();
                    });

                    timer = Timer(
                      widget.completingIdleTime,
                      () {
                        timer?.cancel();

                        if (mounted) {
                          setState(() {
                            buttonState = ButtonState.idling();
                          });
                        }
                      },
                    );
                  }
                } catch (error) {
                  timer?.cancel();

                  if (mounted) {
                    setState(() {
                      buttonState = ButtonState.erroring();
                    });

                    timer = Timer(
                      widget.erroringIdleTime,
                      () {
                        timer?.cancel();

                        if (mounted) {
                          setState(() {
                            buttonState = ButtonState.idling();
                          });
                        }
                      },
                    );
                  }

                  rethrow;
                }
              },
              orElse: () => null,
            ),
      buttonState,
    );
  }
}
