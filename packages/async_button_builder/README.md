# async_button

[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/invertase/melos)

AsyncButton offers a simple way to extend any type of button with an asynchronous aspect. It comes in two flavors that are independent (so no additional dependencies) of `builder` or `hook` pattern. Note, the hook version does rely on `flutter_hooks` for use. Either method allows adding loading, disabled, errored and completed states (with fluid animation between each) on top of buttons that perform asynchronous tasks.

## Getting Started

Include the package:

```yaml
  async_button_builder: <latest_version>
```

Wrap the builder around a button, passing the onPressed and child element to builder instead of the button directly. These two are the only required fields.

```dart
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
```

<p>  
 <img src="https://github.com/Nolence/async_button_builder/blob/main/screenshots/ezgif-7-61c436edaec2.gif?raw=true"/>
</p>

The fourth value in the builder allows you listen to the loading state. This can be used to conditionally style the button. This package depends `freezed` in order to create a sealed union to better handle the possible states.

```dart
AsyncButtonBuilder(
  child: Text('Click Me'),
  loadingWidget: Text('Loading...'),
  onPressed: () async {
    await Future.delayed(Duration(seconds: 1));

    // See the examples file for a way to handle timeouts
    throw 'shucks';
  },
  builder: (context, child, callback, buttonState) {
    final buttonColor = buttonState.when(
      idle: () => Colors.yellow[200],
      loading: () => Colors.grey,
      success: () => Colors.orangeAccent,
      error: () => Colors.orange,
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
```

<p>  
 <img src="https://github.com/Nolence/async_button_builder/blob/main/screenshots/ezgif-7-a971c6afaabf.gif?raw=true"/>
</p>

You can also drive the state of the button yourself using the  `buttonState` field:

```dart
AsyncButtonBuilder(
  buttonState: ButtonState.completing(),
  // ...
),
```

`async_button_builder` even works for custom buttons. You can define your own widgets for loading, error, and completion as well as define the transitions between them. This example is a little verbose but shows some of what's possible.


```dart
AsyncButtonBuilder(
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
        child: child,
        onTap: callback,
      ),
    );
  },
),
```

<p>  
 <img src="https://github.com/Nolence/async_button_builder/blob/main/screenshots/ezgif-7-4088c909ba83.gif?raw=true"/>
</p>

Issues and PR's welcome