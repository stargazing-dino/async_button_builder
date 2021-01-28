import 'package:async_button_builder/async_button_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('displays child text', (WidgetTester tester) async {
    final textButton = MaterialApp(
      home: AsyncButtonBuilder(
        child: Text('click me'),
        onPressed: () async {
          await Future.delayed(Duration(seconds: 1));
        },
        builder: (context, child, callback, state) {
          return TextButton(onPressed: callback, child: child);
        },
      ),
    );

    await tester.pumpWidget(textButton);

    expect(find.text('click me'), findsOneWidget);
  });

  testWidgets('shows loading widget', (WidgetTester tester) async {
    final duration = Duration(milliseconds: 250);
    final textButton = MaterialApp(
      home: AsyncButtonBuilder(
        duration: duration,
        child: Text('click me'),
        loadingWidget: Text('loading'),
        onPressed: () async {
          await Future.delayed(Duration(seconds: 1));
        },
        builder: (context, child, callback, state) {
          return TextButton(onPressed: callback, child: child);
        },
      ),
    );

    await tester.pumpWidget(textButton);

    await tester.tap(find.byType(TextButton));

    // 1/10 of a second later, loading should be showing
    await tester.pump(Duration(milliseconds: 100));

    expect(find.text('loading'), findsOneWidget);

    // Let the widget continue to settle otherwise I won't dispose timers
    // correctly. TODO: Explain why .900 is the magic number
    await tester.pumpAndSettle(Duration(milliseconds: 900));
  });

  testWidgets('shows error widget', (WidgetTester tester) async {
    final duration = Duration(milliseconds: 250);
    final textButton = MaterialApp(
      home: AsyncButtonBuilder(
        duration: duration,
        child: Text('click me'),
        errorWidget: Text('error'),
        onPressed: () async {
          throw ArgumentError();
        },
        builder: (context, child, callback, state) {
          return TextButton(onPressed: callback, child: child);
        },
      ),
    );

    await tester.pumpWidget(textButton);
    final button =
        find.byType(TextButton).evaluate().first.widget as TextButton;

    expect(
      () => button.onPressed!.call(),
      throwsA(isInstanceOf<ArgumentError>()),
    );

    await tester.pump(Duration(milliseconds: 200));

    expect(find.text('error'), findsOneWidget);
  });

  testWidgets('Returns to child widget', (WidgetTester tester) async {
    final duration = Duration(milliseconds: 250);
    final textButton = MaterialApp(
      home: AsyncButtonBuilder(
        duration: duration,
        child: Text('click me'),
        loadingWidget: Text('loading'),
        onPressed: () async {
          await Future.delayed(Duration(seconds: 1));
        },
        builder: (context, child, callback, state) {
          return TextButton(onPressed: callback, child: child);
        },
      ),
    );

    await tester.pumpWidget(textButton);

    await tester.tap(find.byType(TextButton));

    await tester.pump(Duration(milliseconds: 1000));

    expect(find.text('loading'), findsNothing);

    expect(find.text('click me'), findsOneWidget);
  });
}
