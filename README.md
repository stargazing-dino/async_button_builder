# async_button_builder

A builder that adds loading and disabled states on top of buttons that perform asynchronous. It can be used with most any button or even on top of a custom Material button. It includes fluid animation between states as well using `AnimatedSize`.

<p>  
 <img src="https://github.com/Nolence/async_button_builder/screenshots/ezgif-2-22348353c16f.gif?raw=true"/>
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
  builder: (context, child, callback) {
    return TextButton(
      child: child,
      onPressed: callback,
    );
  },
),
```

You can also change the loading indicator with anything you prefer using the `loadingWidget` field. By default it uses a `CircularProgressIndicator`.

For a custom button, you can specify properties such as `padding` and `loadingPadding`.


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
    builder: (context, child, callback) {
      return InkWell(
        child: child,
        onTap: callback,
      );
    },
  ),
),
```

