import 'package:async_button_core/async_button_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef AsyncButtonBuilderCallback = Widget Function(
  BuildContext context,
  Widget child,
  AsyncCallback? callback,
  ButtonState buttonState,
);

// TODO: I created this class so I can do dartdoc stuff and use it in both
// the builder and the hook. Currently not paying off.

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
abstract class AsyncButton {
  /// This builder provides the widget's [BuildContext], the variable [child]
  /// based on button state as well as the [callback] that should be passed to
  /// the button and the current [ButtonState]
  AsyncButtonBuilderCallback get builder;

  /// {@template asyncButton.interface.child}
  /// The child of the button. In the case of an [IconButton], this can be a an
  /// [Icon]. For a [TextButton], a [Text].
  ///
  /// This child will be animated between for the [loadingWidget] or default
  /// [CircularProgressIndicator] when the asynchronous [onPressed] is called.
  /// The animation will take place over [duration].
  /// {@endtemplate}
  Widget get child;

  /// The animation's duration between [child], [loadingWidget],
  /// [successWidget] and [errorWidget]. This same value is used for both the
  /// internal [AnimatedSize] and [TransitionBuilder].
  Duration get duration;

  /// The animation's reverse duration between [child], [loadingWidget],
  /// [successWidget] and [errorWidget]. This same value is used for both the
  /// internal [AnimatedSize] and [TransitionBuilder].
  Duration get reverseDuration;

  /// A callback that runs the async task. This is wrapped in order to begin
  /// the button's internal `isLoading` before and after the operation
  /// completes.
  AsyncCallback? get onPressed;

  /// This is used to manually drive the state of the loading button thus
  /// initiating the corresponding animation and showing the correct button
  /// child.
  ButtonState get buttonState;

  /// This is used to manually drive the disabled state of the button.
  bool get disabled;

  /// The widget replaces the [child] when the button is in the loading state.
  /// If this is null the default widget is:
  ///
  /// SizedBox(
  ///   height: 16.0,
  ///   width: 16.0,
  ///   child: CircularProgressIndicator(),
  /// )
  Widget? get loadingWidget;

  /// The widget used to replace the [child] when the button is in a success
  /// state. If this is null the default widget is:
  ///
  /// Icon(
  ///   Icons.check,
  ///   color: Theme.of(context).accentColor,
  /// );
  Widget? get successWidget;

  /// The widget used to replace the [child] when the button is in a error
  /// state. If this is null the default widget is:
  ///
  /// Icon(
  ///   Icons.error,
  ///   color: Theme.of(context).errorColor,
  /// )
  Widget? get errorWidget;

  /// Whether to show the [successWidget] on success.
  bool get showSuccess;

  /// Whether to show the [errorWidget] on error.
  bool get showError;

  /// Optional [EdgeInsets] that will wrap around the [errorWidget]. This is a
  /// convenience field that can be replaced by defining your own [errorWidget]
  /// and wrapping it in a [Padding].
  EdgeInsets? get errorPadding;

  /// Optional [EdgeInsets] that will wrap around the [successWidget]. This is a
  /// convenience field that can be replaced by defining your own
  /// [successWidget] and wrapping it in a [Padding].
  EdgeInsets? get successPadding;

  /// Defines a custom transition when animating between any state and `idle`
  AnimatedSwitcherTransitionBuilder get idleTransitionBuilder;

  /// Defines a custom transition when animating between any state and `loading`
  AnimatedSwitcherTransitionBuilder get loadingTransitionBuilder;

  /// Defines a custom transition when animating between any state and `success`
  AnimatedSwitcherTransitionBuilder get successTransitionBuilder;

  /// Defines a custom transition when animating between any state and `error`
  AnimatedSwitcherTransitionBuilder get errorTransitionBuilder;

  /// The amount of idle time the [successWidget] shows
  Duration get successDuration;

  /// The amount of idle time the [errorWidget] shows
  Duration get errorDuration;

  /// Defines a curve for the custom transition. This used in in an
  /// [AnimatedSwitcher] and only takes effect when animating to `idle`
  Curve get idleSwitchInCurve;

  /// Defines a curve for the custom transition. This used in in an
  /// [AnimatedSwitcher] and only takes effect when animating to `loading`
  Curve get loadingSwitchInCurve;

  /// Defines a curve for the custom transition. This used in in an
  /// [AnimatedSwitcher] and only takes effect when animating to `success`
  Curve get successSwitchInCurve;

  /// Defines a curve for the custom transition. This used in in an
  /// [AnimatedSwitcher] and only takes effect when animating to `error`
  Curve get errorSwitchInCurve;

  /// Defines a curve for the custom transition. This used in in an
  /// [AnimatedSwitcher] and only takes effect when animating out of `idle`
  Curve get idleSwitchOutCurve;

  /// Defines a curve for the custom transition. This used in in an
  /// [AnimatedSwitcher] and only takes effect when animating out of `loading`
  Curve get loadingSwitchOutCurve;

  /// Defines a curve for the custom transition. This used in in an
  /// [AnimatedSwitcher] and only takes effect when animating out of `success`
  Curve get successSwitchOutCurve;

  /// Defines a curve for the custom transition. This used in in an
  /// [AnimatedSwitcher] and only takes effect when animating out of `error`
  Curve get errorSwitchOutCurve;

  /// Defines a curve for the internal [AnimatedSize]
  Curve get sizeCurve;

  /// Defines the [Clip] for the internal [AnimatedSize]
  Clip get sizeClipBehavior;

  /// Defines the [Alignment] for the internal [AnimatedSize]
  Alignment get sizeAlignment;

  /// Whether to animate the [Size] of the widget implicitly.
  bool get animateSize;
}
