import 'dart:async';

import 'package:async_button_builder/src/button_state/button_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef AsyncButtonBuilderCallback = Widget Function(
  BuildContext context,
  Widget child,
  AsyncCallback? callback,
  ButtonState buttonState,
);

/// A `builder` that wraps a button providing disabled, loading, success and
/// error states while retaining almost full access to the original Button's
/// API. This is useful for any long running operations and helps better
/// improve UX.
///
/// {@tool dartpad --template=stateful_widget_material}
///
/// ```dart
///
/// @override
/// Widget build(BuildContext context) {
///   return AsyncButtonBuilder(
///     child: Text('Click Me'),
///     loadingWidget: Text('Loading...'),
///     onPressed: () async {
///       await Future.delayed(Duration(seconds: 1));
///
///       throw 'shucks';
///     },
///     builder: (context, child, callback, buttonState) {
///       final buttonColor = buttonState.when(
///         idle: () => Colors.yellow[200],
///         loading: () => Colors.grey,
///         success: () => Colors.orangeAccent,
///         error: () => Colors.orange,
///       );
///
///       return OutlinedButton(
///         child: child,
///         onPressed: callback,
///         style: OutlinedButton.styleFrom(
///           primary: Colors.black,
///           backgroundColor: buttonColor,
///         ),
///       );
///     },
///   ),
/// }
/// ```
/// {@end-tool}
///
class AsyncButtonBuilder extends StatefulWidget {
  /// This builder provides the widget's [BuildContext], the variable [child]
  /// based on button state as well as the [callback] that should be passed to
  /// the button and the current [ButtonState]
  final AsyncButtonBuilderCallback builder;

  /// The child of the button. In the case of an [IconButton], this can be a an
  /// [Icon]. For a [TextButton], a [Text].
  ///
  /// This child will be animated between for the [loadingWidget] or default
  /// [CircularProgressIndicator] when the asynchronous [onPressed] is called.
  /// The animation will take place over [duration].
  final Widget child;

  /// The animation's duration between [child], [loadingWidget],
  /// [successWidget] and [errorWidget]. This same value is used for both the
  /// internal [AnimatedSize] and [TransitionBuilder].
  final Duration duration;

  /// The animation's reverse duration between [child], [loadingWidget],
  /// [successWidget] and [errorWidget]. This same value is used for both the
  /// internal [AnimatedSize] and [TransitionBuilder].
  final Duration reverseDuration;

  /// A callback that runs the async task. This is wrapped in order to begin
  /// the button's internal `isLoading` before and after the operation
  /// completes.
  final AsyncCallback onPressed;

  /// This is used to manually drive the state of the loading button thus
  /// initiating the corresponding animation and showing the correct button
  /// child.
  final ButtonState buttonState;

  /// This is used to manually drive the disabled state of the button.
  final bool disabled;

  /// The widget replaces the [child] when the button is in the loading state.
  /// If this is null the default widget is:
  ///
  /// SizedBox(
  ///   height: 16.0,
  ///   width: 16.0,
  ///   child: CircularProgressIndicator(),
  /// )
  final Widget? loadingWidget;

  /// The widget used to replace the [child] when the button is in a success
  /// state. If this is null the default widget is:
  ///
  /// Icon(
  ///   Icons.check,
  ///   color: Theme.of(context).accentColor,
  /// );
  final Widget? successWidget;

  /// The widget used to replace the [child] when the button is in a error
  /// state. If this is null the default widget is:
  ///
  /// Icon(
  ///   Icons.error,
  ///   color: Theme.of(context).errorColor,
  /// )
  final Widget? errorWidget;

  /// Whether to show the [successWidget] on success.
  final bool showSuccess;

  /// Whether to show the [errorWidget] on error.
  final bool showError;

  /// Optional [EdgeInsets] that will wrap around the [errorWidget]. This is a
  /// convenience field that can be replaced by defining your own [errorWidget]
  /// and wrapping it in a [Padding].
  final EdgeInsets? errorPadding;

  /// Optional [EdgeInsets] that will wrap around the [successWidget]. This is a
  /// convenience field that can be replaced by defining your own
  /// [successWidget] and wrapping it in a [Padding].
  final EdgeInsets? successPadding;

  /// Defines a custom transition when animating between any state and `idle`
  final AnimatedSwitcherTransitionBuilder idleTransitionBuilder;

  /// Defines a custom transition when animating between any state and `loading`
  final AnimatedSwitcherTransitionBuilder loadingTransitionBuilder;

  /// Defines a custom transition when animating between any state and `success`
  final AnimatedSwitcherTransitionBuilder successTransitionBuilder;

  /// Defines a custom transition when animating between any state and `error`
  final AnimatedSwitcherTransitionBuilder errorTransitionBuilder;

  /// The amount of idle time the [successWidget] shows
  final Duration successDuration;

  /// The amount of idle time the [errorWidget] shows
  final Duration errorDuration;

  /// Defines a curve for the custom transition. This used in in an
  /// [AnimatedSwitcher] and only takes effect when animating to `idle`
  final Curve idleSwitchInCurve;

  /// Defines a curve for the custom transition. This used in in an
  /// [AnimatedSwitcher] and only takes effect when animating to `loading`
  final Curve loadingSwitchInCurve;

  /// Defines a curve for the custom transition. This used in in an
  /// [AnimatedSwitcher] and only takes effect when animating to `success`
  final Curve successSwitchInCurve;

  /// Defines a curve for the custom transition. This used in in an
  /// [AnimatedSwitcher] and only takes effect when animating to `error`
  final Curve errorSwitchInCurve;

  /// Defines a curve for the custom transition. This used in in an
  /// [AnimatedSwitcher] and only takes effect when animating out of `idle`
  final Curve idleSwitchOutCurve;

  /// Defines a curve for the custom transition. This used in in an
  /// [AnimatedSwitcher] and only takes effect when animating out of `loading`
  final Curve loadingSwitchOutCurve;

  /// Defines a curve for the custom transition. This used in in an
  /// [AnimatedSwitcher] and only takes effect when animating out of `success`
  final Curve successSwitchOutCurve;

  /// Defines a curve for the custom transition. This used in in an
  /// [AnimatedSwitcher] and only takes effect when animating out of `error`
  final Curve errorSwitchOutCurve;

  /// Defines a curve for the internal [AnimatedSize]
  final Curve sizeCurve;

  /// Defines the [Clip] for the internal [AnimatedSize]
  final Clip sizeClipBehavior;

  /// Defines the [Alignment] for the internal [AnimatedSize]
  final Alignment sizeAlignment;

  /// Whether to animate the [Size] of the widget implicitly.
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
    final loadingWidget = widget.loadingWidget ??
        const SizedBox(
          height: 16.0,
          width: 16.0,
          child: CircularProgressIndicator(),
        );
    var successWidget = widget.successWidget ??
        Icon(
          Icons.check,
          color: theme.accentColor,
        );
    var errorWidget = widget.errorWidget ??
        Icon(
          Icons.error,
          color: theme.errorColor,
        );
    final successPadding = widget.successPadding;
    final errorPadding = widget.errorPadding;

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
        idle: () => widget.child,
        loading: () => loadingWidget,
        success: () => successWidget,
        error: () => errorWidget,
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
              child: switcher,
              duration: widget.duration,
              reverseDuration: widget.reverseDuration,
              alignment: widget.sizeAlignment,
              clipBehavior: widget.sizeClipBehavior,
              curve: widget.sizeCurve,
            )
          : switcher,
      widget.disabled
          ? null
          : buttonState.maybeWhen(
              idle: () => () async {
                // I might not want to set buttonState if we're being
                // driven by widget.buttonState...
                setState(() {
                  buttonState = ButtonState.loading();
                });

                timer?.cancel();

                try {
                  await widget.onPressed();

                  if (mounted) {
                    if (widget.showSuccess) {
                      setState(() {
                        buttonState = ButtonState.success();
                      });

                      timer = Timer(
                        widget.successDuration,
                        () {
                          timer?.cancel();

                          if (mounted) {
                            setState(() {
                              buttonState = ButtonState.idle();
                            });
                          }
                        },
                      );
                    } else {
                      setState(() {
                        buttonState = ButtonState.idle();
                      });
                    }
                  }
                } catch (error) {
                  if (mounted) {
                    if (widget.showError) {
                      setState(() {
                        buttonState = ButtonState.error();
                      });

                      timer = Timer(
                        widget.errorDuration,
                        () {
                          timer?.cancel();

                          if (mounted) {
                            setState(() {
                              buttonState = ButtonState.idle();
                            });
                          }
                        },
                      );
                    } else {
                      setState(() {
                        buttonState = ButtonState.idle();
                      });
                    }
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
