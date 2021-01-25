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
  /// initiating the corresponding animation and showing the correct button
  /// child
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
  final Widget? loadingWidget;

  /// The widget used to replace the [child] when the button is in a completing
  /// state. If this is null the default widget is:
  ///
  /// SizedBox(
  ///   height: 16.0,
  ///   width: 16.0,
  ///   child: Icons(Icon.check)
  /// )
  final Widget? completingWidget;

  final Widget? erroringWidget;

  final AnimatedSwitcherTransitionBuilder idlingTransitionBuilder;

  final AnimatedSwitcherTransitionBuilder loadingTransitionBuilder;

  final AnimatedSwitcherTransitionBuilder completingTransitionBuilder;

  final AnimatedSwitcherTransitionBuilder erroringTransitionBuilder;

  final Duration completingIdleTime;

  final Duration erroringIdleTime;

  final Curve idlingSwitchInCurve;

  final Curve loadingSwitchInCurve;

  final Curve completingSwitchInCurve;

  final Curve erroringSwitchInCurve;

  final Curve idlingSwitchOutCurve;

  final Curve loadingSwitchOutCurve;

  final Curve completingSwitchOutCurve;

  final Curve erroringSwitchOutCurve;

  const AsyncButtonBuilder({
    Key? key,
    required this.child,
    required this.onPressed,
    required this.builder,
    this.loadingWidget,
    this.completingWidget,
    this.erroringWidget,
    this.duration = const Duration(milliseconds: 250),
    this.buttonState = const ButtonState.idling(),
    this.disabled = false,
    this.completingIdleTime = const Duration(seconds: 1),
    this.erroringIdleTime = const Duration(seconds: 1),
    this.loadingTransitionBuilder = AnimatedSwitcher.defaultTransitionBuilder,
    this.idlingTransitionBuilder = AnimatedSwitcher.defaultTransitionBuilder,
    this.completingTransitionBuilder =
        AnimatedSwitcher.defaultTransitionBuilder,
    this.erroringTransitionBuilder = AnimatedSwitcher.defaultTransitionBuilder,
    this.idlingSwitchInCurve = Curves.linear,
    this.loadingSwitchInCurve = Curves.linear,
    this.completingSwitchInCurve = Curves.linear,
    this.erroringSwitchInCurve = Curves.linear,
    this.idlingSwitchOutCurve = Curves.linear,
    this.loadingSwitchOutCurve = Curves.linear,
    this.completingSwitchOutCurve = Curves.linear,
    this.erroringSwitchOutCurve = Curves.linear,
  }) : super(key: key);
  // TODO: I need asserts that will assert the keys are different for child,
  // loading, error, etc. because otherwise transitions won't work as expected

  // assert(widget.child.key != loadingWidget.key &&
  //       loadingWidget.key != completingWidget.key &&
  //       completingWidget.key != erroringWidget.key);

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
    final theme = Theme.of(context);
    final loadingWidget = widget.loadingWidget ??
        const SizedBox(
          height: 16.0,
          width: 16.0,
          child: CircularProgressIndicator(),
        );
    final completingWidget = widget.completingWidget ??
        Icon(
          Icons.check,
          color: theme.accentColor,
        );
    final erroringWidget = widget.erroringWidget ??
        Icon(
          Icons.error,
          color: theme.errorColor,
        );

    return widget.builder(
      context,
      AnimatedSize(
        // TODO: Expose these fields
        duration: widget.duration,
        vsync: this,
        child: AnimatedSwitcher(
          duration: widget.duration,
          switchInCurve: buttonState.when(
            idling: () => widget.idlingSwitchInCurve,
            loading: () => widget.loadingSwitchInCurve,
            completing: () => widget.completingSwitchInCurve,
            erroring: () => widget.erroringSwitchInCurve,
          ),
          switchOutCurve: buttonState.when(
            idling: () => widget.idlingSwitchOutCurve,
            loading: () => widget.loadingSwitchOutCurve,
            completing: () => widget.completingSwitchOutCurve,
            erroring: () => widget.erroringSwitchOutCurve,
          ),
          transitionBuilder: buttonState.when(
            idling: () => widget.idlingTransitionBuilder,
            loading: () => widget.loadingTransitionBuilder,
            completing: () => widget.completingTransitionBuilder,
            erroring: () => widget.erroringTransitionBuilder,
          ),
          child: buttonState.when(
            idling: () => widget.child,
            loading: () => loadingWidget,
            completing: () => completingWidget,
            erroring: () => erroringWidget,
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
