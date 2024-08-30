import { useEffect } from 'react';
import { StyleSheet, View, Text, NativeEventEmitter } from 'react-native';
import AppQuickActions, {
  type QuickActionItem,
} from 'react-native-app-quick-actions';

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

export default function App() {
  useEffect(() => {
    AppQuickActions.setQuickActions(quickActionItems)
      .then((items) => {
        console.log(`---> Quick Action Items Set: ${JSON.stringify(items)}`);
        return AppQuickActions.getQuickActions();
      })
      .then((items) =>
        console.log(`---> Quick Action Items Get: ${JSON.stringify(items)}`)
      );
  }, []);

  useEffect(() => {
    const eventEmitter = new NativeEventEmitter(AppQuickActions);
    const eventSubscription = eventEmitter.addListener(
      'onQuickActionItemPressed',
      (item) => {
        const { type, data } = item;
        console.log(
          `---> Quick Action Item Clicked type:${type}, data:${JSON.stringify(data)}`
        );
      }
    );
    return () => eventSubscription.remove();
  }, []);

  return (
    <View style={styles.container}>
      <Text>Reqct Native Quick Actions</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
