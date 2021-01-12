import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef _AsyncWidgetBuilder = Widget Function(
  BuildContext context,
  Widget child,
  AsyncCallback? callback,
);

class AsyncButtonBuilder extends StatefulWidget {
  final _AsyncWidgetBuilder builder;

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

  /// This is used to manually drive the state of the loading button.
  final bool? isLoading;

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

  /// This color changes the color of the default loading widget k-- a
  /// [CircularProgressIndicator].
  final Color? valueColor;

  /// Optional padding around the child. This is useful if you are creating
  /// your own button with [Material] and need padding around the inner child.
  final EdgeInsets? padding;

  /// Optional padding around the loading widget. This is useful if you are
  /// creating your own button with [Material] and need a seperate padding
  /// around the loading indicator unequal to the child's [padding].
  final EdgeInsets? loadingPadding;

  const AsyncButtonBuilder({
    Key? key,
    required this.builder,
    required this.child,
    required this.onPressed,
    this.duration = const Duration(milliseconds: 250),
    this.isLoading,
    this.loadingWidget,
    this.valueColor,
    this.padding,
    this.loadingPadding,
  }) : super(key: key);

  @override
  _AsyncButtonBuilderState createState() => _AsyncButtonBuilderState();
}

class _AsyncButtonBuilderState extends State<AsyncButtonBuilder>
    with SingleTickerProviderStateMixin {
  late bool isLoading;

  @override
  void initState() {
    isLoading = widget.isLoading ?? false;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AsyncButtonBuilder oldWidget) {
    if (widget.isLoading != oldWidget.isLoading) {
      final loading = widget.isLoading;

      if (loading != null) {
        setState(() {
          isLoading = loading;
        });
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.valueColor;
    final padding = widget.padding;
    final loadingPadding = widget.loadingPadding;
    final valueColor =
        color == null ? null : AlwaysStoppedAnimation<Color>(color);
    final child = padding == null
        ? widget.child
        : Padding(padding: padding, child: widget.child);
    var loadingWidget = widget.loadingWidget ??
        SizedBox(
          height: 16.0,
          width: 16.0,
          child: CircularProgressIndicator(
            valueColor: valueColor,
          ),
        );
    loadingWidget = loadingPadding == null
        ? loadingWidget
        : Padding(padding: loadingPadding, child: loadingWidget);

    return widget.builder(
      context,
      AnimatedSize(
        duration: widget.duration,
        vsync: this,
        child: isLoading ? loadingWidget : child,
      ),
      isLoading
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });

              try {
                await widget.onPressed();
              } catch (error) {
                rethrow;
              } finally {
                if (mounted) {
                  setState(() {
                    isLoading = false;
                  });
                }
              }
            },
    );
  }
}
