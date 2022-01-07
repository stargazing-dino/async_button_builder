import 'package:async_button_builder/async_button_builder.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Async Buttons')),
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Divider(),
            Text('Text Button:'),
            AsyncButtonBuilder(
              child: Text('Click Me'),
              onPressed: () async {
                await Future.delayed(Duration(seconds: 1));
              },
              builder: (context, child, callback, _) {
                return TextButton(
                  onPressed: callback,
                  child: child,
                );
              },
            ),
            Divider(),
            Text('Elevated Button:'),
            AsyncButtonBuilder(
              child: Text('Click Me'),
              onPressed: () async {
                await Future.delayed(Duration(seconds: 1));
              },
              builder: (context, child, callback, _) {
                return ElevatedButton(
                  onPressed: callback,
                  child: child,
                );
              },
            ),
            Divider(),
            Text('Custom Outlined Button (Error):'),
            AsyncButtonBuilder(
              loadingWidget: Text('Loading...'),
              onPressed: () async {
                await Future.delayed(Duration(seconds: 1));

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
              builder: (context, child, callback, buttonState) {
                final buttonColor = buttonState.when(
                  idle: () => Colors.yellow[200],
                  loading: () => Colors.grey,
                  success: () => Colors.orangeAccent,
                  error: () => Colors.orange,
                );

                return OutlinedButton(
                  onPressed: callback,
                  style: OutlinedButton.styleFrom(
                    primary: Colors.black,
                    backgroundColor: buttonColor,
                  ),
                  child: child,
                );
              },
              child: Text('Click Me'),
            ),
            Divider(),
            Text('Custom Material Button:'),
            const SizedBox(height: 6.0),
            AsyncButtonBuilder(
              loadingWidget: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 16.0,
                  width: 16.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
              successWidget: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.check,
                  color: Colors.purpleAccent,
                ),
              ),
              onPressed: () async {
                await Future.delayed(Duration(seconds: 2));
              },
              loadingSwitchInCurve: Curves.bounceInOut,
              loadingTransitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(0, 1.0),
                    end: Offset(0, 0),
                  ).animate(animation),
                  child: child,
                );
              },
              builder: (context, child, callback, state) {
                return Material(
                  color: state.maybeWhen(
                    success: () => Colors.purple[100],
                    orElse: () => Colors.blue,
                  ),
                  // This prevents the loading indicator showing below the
                  // button
                  clipBehavior: Clip.hardEdge,
                  shape: StadiumBorder(),
                  child: InkWell(
                    onTap: callback,
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                  'Click Me',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
