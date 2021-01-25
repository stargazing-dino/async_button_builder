# async_button_builder

## This is a pre release and I'd like suggestions on naming, usability, further improvments. Thank you!

A builder that adds loading, disabled, errored and completed states on top of buttons that perform asynchronous tasks. It can be used with most any button or even on top of a custom Material button. It includes fluid animation between states as well using `AnimatedSize` as well as the possibility to define your own transition builder.

<p>  
 <img src="https://github.com/Nolence/async_button_builder/blob/main/screenshots/ezgif-1-492fa074abc6.gif?raw=true"/>
</p>  

## Getting Started

Include the package:

```
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

The fourth value in the builder allows you listen to the loading state. This can be used to conditionally style the button. This package depends `freezed` in order to create a sealed union to better handle the possible states.

```dart
AsyncButtonBuilder(
  child: Text('Click Me'),
  onPressed: () async {
    await Future.delayed(Duration(seconds: 1));
  },
  builder: (context, child, callback, state) {
    return ElevatedButton(
      child: child,
      onPressed: callback,
      style: ElevatedButton.styleFrom(
        primary: state.when(
          idling: () => Colors.pink,
          loading: () => Colors.grey,
          completing: () => Colors.pinkAccent,
          erroring: () => Colors.red[100],
        ),
      ),
    );
  },
),
```

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
    // Value keys are important as otherwise our custom transitions
    // will have no way to differentiate between children. This is not
    // specific to this library but Flutter's `AnimatedSwitcher`.
    key: ValueKey('foo'),
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
    key: ValueKey('bar'),
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
    key: ValueKey('foobar'),
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
    // The loading indicator will come up from the button using a
    // `bounceInOut` curve.
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
```

Issues and PR's welcome