# react-native-app-quick-actions

ReactNative App Quick Actions for Android & iOS. Inspired by [Expo Quick Actions](https://github.com/EvanBacon/expo-quick-actions) & [react-native-actions-shortcuts](https://github.com/mouselangelo/react-native-actions-shortcuts). Supports both Old (Native Module) and New (Turbo Module) Architecture of ReactNative

## Installation

```sh
yarn install react-native-app-quick-actions
```

or

```sh
npm install react-native-app-quick-actions
```

### iOS

iOS Requires one additional step to capture the quick action data when app is launched with a quick action.
In the `AppDelegate.m` or `AppDelegate.mm` file of the integrating project, below code needs to be placed.

```objectivec
#import "AppQuickActions.h"

-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
  [AppQuickActions performActionForQuickActionItem:shortcutItem completionHandler:completionHandler];
}
```

### Android

No specific setup required

## Summary

### API

| method                                  | Description                    |
| --------------------------------------- | ------------------------------ |
| [setQuickActions](#setquickactions)     | sets the quick actions         |
| [getQuickActions](#getquickactions)     | gets the current quick actions |
| [clearQuickActions](#clearquickactions) | clears existing quick actions  |

### QuickActionItem

| Key        | Android | iOS | Description                                                                     |
| ---------- | :-----: | :-: | ------------------------------------------------------------------------------- |
| type       |   ✅    | ✅  | unique string for the quick action                                              |
| title      |   ✅    | ✅  | title string for the quick action                                               |
| shortTitle |   ✅    | ❌  | shortTitle string which will be shown when there is space constraint in Android |
| subtitle   |   ❌    | ✅  | subtitle string which will be shown below title in iOS                          |
| iconName   |   ✅    | ✅  | iconName string                                                                 |
| data       |   ✅    | ✅  | object to have user defined values                                              |

## Usage

### import

```js
import AppQuickActions from 'react-native-app-quick-actions';
```

you can also import the `QuickActionItem` type if working with typescript for defining the Quick Action Item.

```js
import AppQuickActions, { type QuickActionItem } from 'react-native-app-quick-actions';
```

### setQuickActions

```javascript
const quickActionItems = [
  {
    type: 'com.quickactions1',
    title: 'Quick Action 1',
    subtitle: 'Simple Quick Action',
    iconName: 'shortcut',
    data: {
      link: '/test',
    },
  },
  {
    type: 'com.quickactions2',
    title: 'Quick Action 2',
    data: {
      link: '/test2',
    },
  },
];

useEffect(() => {
  AppQuickActions.setQuickActions(quickActionItems).then((items) => {
    console.log(`---> Quick Action Items Set: ${JSON.stringify(items)}`);
  });
}, []);
```

### getQuickActions

```js
AppQuickActions.getQuickActions().then((items) =>
  console.log(`---> Current Quick Action Items: ${JSON.stringify(items)}`)
);
```

### getInitialQuickAction

```js
AppQuickActions.getInitialQuickAction().then((item) =>
  console.log(`---> App Launched with QUick Action: ${JSON.stringify(item)}`)
);
```

> When app launched with quick action this method can be used besides listening for event. On iOS subsequent calls to this method will result in null.

### clearQuickActions

```js
AppQuickActions.clearQuickActions();
```

### Listen for events

```js
useEffect(() => {
  const eventEmitter = new NativeEventEmitter(AppQuickActions);
  const sub = eventEmitter.addListener(
    'onQuickActionItemPressed',
    ({ item, initial }) => {
      const { type, data } = item;
      console.log(
        `---> Quick Action Item Clicked type:${type}, data:${JSON.stringify(data)}, isInitial: ${initial}`
      );
    }
  );
  return () => sub.remove();
}, []);
```

> Either the app is launched with a quick action or when the app is brought to foreground using a quick action, In both cases event is emitted and the `initial` flag is set accordingly in the callback.

### Hooks

For convenience there is hook for handling quick action events.

#### useAppQuickActionHandler

```js
useAppQuickActionHandler(({ item, initial }) => {
  const { type, data } = item;
  console.log(
    `---> Quick Action Item Clicked type:${type}, data:${JSON.stringify(data)}, isInitial: ${initial}`
  );
});
```

## Icons

### Android

Icons needs to be in drawables folder. For guidelines on shortcut icons you can [follow this guide](https://commondatastorage.googleapis.com/androiddevelopers/shareables/design/app-shortcuts-design-guidelines.pdf)

### iOS

Icons in iOS needs to be inside Asset Catalogue. For icon guidelines you can [follow this guide](https://developer.apple.com/design/human-interface-guidelines/home-screen-quick-actions#Best-practices)

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
