# async_button_builder

A builder that adds loading and disabled states on top of buttons that perform asynchronous tasks. It can be used with most any button or even on top of a custom Material button. It includes fluid animation between states as well using `AnimatedSize`.

<p>  
 <img src="https://github.com/Nolence/async_button_builder/blob/main/screenshots/ezgif-2-22348353c16f.gif?raw=true"/>
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

The fourth value in the builder allows you listen to the loading state. This can be used to conditionally style the button.

```dart
AsyncButtonBuilder(
  child: Text('Click Me'),
  onPressed: () async {
    await Future.delayed(Duration(seconds: 1));
  },
  builder: (context, child, callback, isLoading) {
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
```

You can also change the loading indicator with anything you prefer using the `loadingWidget` field. By default it uses a `CircularProgressIndicator`.

For a custom button, you can also specify properties such as `padding` and `loadingPadding`. These are convenience fields and the same result can be achieved by instead wrapping `child` and `loadingWidget` in `Padding`s.


```dart
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
    builder: (context, child, callback, _) {
      return InkWell(
        child: child,
        onTap: callback,
      );
    },
  ),
),
```

If you need to drive the value of isLoading externally you can pass your value to the field `isLoading`.

```dart
AsyncButtonBuilder(
  child: Text('Click Me'),
  isLoading: false,
  onPressed: () async {
    await Future.delayed(Duration(seconds: 1));
  },
  builder: (context, child, callback, _) {
    return OutlinedButton(
      child: child,
      onPressed: callback,
    );
  },
),
```

Issues and PR's welcome