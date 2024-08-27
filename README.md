# react-native-app-quick-actions

> [IN DEVELOPMENT]

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

## Usage

### import

```js
import AppQuickActions from 'react-native-app-quick-actions';
```

you can also import the `QuickActionItem` type if required.

```js
import AppQuickActions, { type QuickActionItem } from 'react-native-app-quick-actions';
```

### setQuickActions

```javascript
const quickActionItems: QuickActionItem[] = [
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
    AppQuickActions.setQuickActions(quickActionItems)
        .then((values: QuickActionItem[]) => {
            console.log(`---> Quick Action Items Set: ${JSON.stringify(values)}`);
        });
}, []);
```

### getQuickActions

```js
AppQuickActions.getQuickActions()
    .then((values: QuickActionItem[]) =>
        console.log(`---> Current Quick Action Items: ${JSON.stringify(values)}`)
    );
```

### clearQuickActions

```js
AppQuickActions.clearQuickActions();
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
