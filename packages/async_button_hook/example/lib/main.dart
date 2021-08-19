import 'package:async_button_hook/async_button_hook.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends HookWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textButtonResult = useAsyncButton(
      child: const Text('Click Me'),
      onPressed: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
    );
    final elevatedButtonResult = useAsyncButton(
      child: const Text('Click Me'),
      onPressed: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
    );
    final customButtonResult = useAsyncButton(
      child: const Text('Click Me'),
      loadingWidget: const Text('Loading...'),
      onPressed: () async {
        await Future.delayed(const Duration(seconds: 1));

        throw 'shucks';

        // If you want to add a timeout, use something similar to
        //
        // try {
        //   await Future.delayed(Duration(seconds: 1))
        //       .timeout(Duration(milliseconds: 500));
        // } on TimeoutException catch (_) {
        //   // Show a popup or something
        //   rethrow;
        // } on Exception catch (_) {
        //   // Show a dialog or something
        //   rethrow;
        // }
        //
        // We rethrow so that async_button_builder can handle the error
        // state
      },
    );
    final buttonColor = customButtonResult.buttonState.when(
      idle: () => Colors.yellow[200],
      loading: () => Colors.grey,
      success: () => Colors.orangeAccent,
      error: () => Colors.orange,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Async Buttons')),
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Divider(),
            const Text('Text Button:'),
            TextButton(
              child: textButtonResult.child,
              onPressed: textButtonResult.callback,
            ),
            const Divider(),
            const Text('Elevated Button:'),
            ElevatedButton(
              child: elevatedButtonResult.child,
              onPressed: elevatedButtonResult.callback,
            ),
            const Divider(),
            const Text('Custom Outlined Button (Error):'),
            OutlinedButton(
              child: customButtonResult.child,
              onPressed: customButtonResult.callback,
              style: OutlinedButton.styleFrom(
                primary: Colors.black,
                backgroundColor: buttonColor,
              ),
            ),
            const Divider(),
            const Text('Custom Material Button:'),
            const SizedBox(height: 6.0),
            HookBuilder(
              builder: (context) {
                final customButtonResult = useAsyncButton(
                  loadingSwitchInCurve: Curves.bounceInOut,
                  loadingTransitionBuilder: (child, animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1.0),
                        end: const Offset(0, 0),
                      ).animate(animation),
                      child: child,
                    );
                  },
                  child: const Text('Click Me'),
                  onPressed: () async {
                    await Future.delayed(const Duration(seconds: 2));
                  },
                  loadingWidget: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 16.0,
                      width: 16.0,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                  successWidget: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.check,
                      color: Colors.purpleAccent,
                    ),
                  ),
                );

                return Material(
                  color: customButtonResult.buttonState.maybeWhen(
                    success: () => Colors.purple[100],
                    orElse: () => Colors.blue,
                  ),
                  // This prevents the loading indicator showing below the
                  // button
                  clipBehavior: Clip.hardEdge,
                  shape: const StadiumBorder(),
                  child: InkWell(
                    child: customButtonResult.child,
                    onTap: customButtonResult.callback,
                  ),
                );
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
