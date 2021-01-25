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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Divider(),
            Text('Text Button:'),
            AsyncButtonBuilder(
              child: Text('Click Me'),
              onPressed: () async {
                await Future.delayed(Duration(seconds: 1));
              },
              builder: (context, child, callback, _) {
                return TextButton(
                  child: child,
                  onPressed: callback,
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
                  child: child,
                  onPressed: callback,
                );
              },
            ),
            Divider(),
            Text('Custom Outlined Button (Error):'),
            AsyncButtonBuilder(
              child: Text('Click Me'),
              loadingWidget: Text('Loading...'),
              onPressed: () async {
                await Future.delayed(Duration(seconds: 1));

                throw 'shucks';
              },
              builder: (context, child, callback, buttonState) {
                final buttonColor = buttonState.when(
                  idling: () => Colors.yellow[200],
                  loading: () => Colors.grey,
                  completing: () => Colors.orangeAccent,
                  erroring: () => Colors.orange,
                );

                return OutlinedButton(
                  child: child,
                  onPressed: callback,
                  style: OutlinedButton.styleFrom(
                    primary: Colors.black,
                    backgroundColor: buttonColor,
                  ),
                );
              },
            ),
            Divider(),
            Text('Custom Material Button:'),
            const SizedBox(height: 6.0),
            AsyncButtonBuilder(
              child: Padding(
                // Value keys are important as otherwise our custom transitions
                // will have no way to differentiate between children.
                key: ValueKey('lust'),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                  'Click Me',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              loadingWidget: Padding(
                key: ValueKey('envy'),
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 16.0,
                  width: 16.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
              completingWidget: Padding(
                key: ValueKey('sloth'),
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
                    completing: () => Colors.purple[100],
                    orElse: () => Colors.blue,
                  ),
                  // This prevents the loading indicator showing below the
                  // button
                  clipBehavior: Clip.hardEdge,
                  shape: StadiumBorder(),
                  child: InkWell(
                    child: child,
                    onTap: callback,
                  ),
                );
              },
            ),
            Divider(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
