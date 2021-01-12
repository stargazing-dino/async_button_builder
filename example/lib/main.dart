import 'package:async_button_builder/async_button_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final isLoading = ValueNotifier(false);

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
              builder: (context, child, callback) {
                return TextButton(
                  child: child,
                  onPressed: callback,
                  style: ButtonStyle(),
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
              builder: (context, child, callback) {
                return ElevatedButton(
                  child: child,
                  onPressed: callback,
                );
              },
            ),
            Divider(),
            Text('Custom Outline Button:'),
            AsyncButtonBuilder(
              child: Text('Click Me'),
              isLoading: isLoading,
              loadingWidget: Text('Loading...'),
              onPressed: () async {
                await Future.delayed(Duration(seconds: 1));
              },
              builder: (context, child, callback) {
                // This value is only listened to inside of `builder`
                print(isLoading.value);

                return OutlinedButton(
                  child: child,
                  onPressed: callback,
                  style: ButtonStyle(
                    tapTargetSize: isLoading.value
                        ? MaterialTapTargetSize.shrinkWrap
                        : MaterialTapTargetSize.padded,
                  ),
                );
              },
            ),
            Divider(),
            Text('Custom Material Button:'),
            const SizedBox(height: 6.0),
            Material(
              color: Colors.lightBlue,
              shape: StadiumBorder(),
              child: AsyncButtonBuilder(
                valueColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                loadingPadding: const EdgeInsets.all(8.0),
                child: Text(
                  'Click Me',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  await Future.delayed(Duration(seconds: 1));
                },
                builder: (context, child, callback) {
                  return InkWell(
                    child: child,
                    onTap: callback,
                  );
                },
              ),
            ),
            Divider(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
