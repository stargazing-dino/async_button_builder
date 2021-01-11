import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef _AsyncWidgetBuilder = Widget Function(
  BuildContext context,
  Widget child,
  AsyncCallback? callback,
);

class AsyncButtonBuilder extends StatefulWidget {
  final _AsyncWidgetBuilder builder;

  final Widget child;

  final Duration duration;

  final AsyncCallback onPressed;

  final bool? _isLoading;

  final Widget? _loadingWidget;

  final Color? _valueColor;

  final EdgeInsets? _padding;

  final EdgeInsets? _loadingPadding;

  const AsyncButtonBuilder({
    Key? key,
    required this.builder,
    required this.child,
    required this.onPressed,
    this.duration = const Duration(milliseconds: 250),
    bool? isLoading,
    Widget? loadingWidget,
    Color? valueColor,
    EdgeInsets? padding,
    EdgeInsets? loadingPadding,
  })  : _loadingWidget = loadingWidget,
        _isLoading = isLoading,
        _valueColor = valueColor,
        _padding = padding,
        _loadingPadding = loadingPadding,
        super(key: key);

  @override
  _AsyncButtonBuilderState createState() => _AsyncButtonBuilderState();
}

class _AsyncButtonBuilderState extends State<AsyncButtonBuilder>
    with SingleTickerProviderStateMixin {
  late bool isLoading;

  @override
  void initState() {
    isLoading = widget._isLoading ?? false;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AsyncButtonBuilder oldWidget) {
    if (widget._isLoading != oldWidget._isLoading) {
      final loading = widget._isLoading;

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
    final color = widget._valueColor;
    final padding = widget._padding;
    final loadingPadding = widget._loadingPadding;
    final valueColor =
        color == null ? null : AlwaysStoppedAnimation<Color>(color);
    final child = padding == null
        ? widget.child
        : Padding(padding: padding, child: widget.child);
    var loadingWidget = widget._loadingWidget ??
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
