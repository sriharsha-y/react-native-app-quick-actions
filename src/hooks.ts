import { useEffect } from 'react';
import { NativeEventEmitter } from 'react-native';
import AppQuickActions from './quickActions';
import type { QuickActionEventData } from './types';

export const useAppQuickActionHandler = (
  handler: (data: QuickActionEventData) => void
) => {
  useEffect(() => {
    let isMounted = true;
    const eventEmitter = new NativeEventEmitter(AppQuickActions);
    const subscription = eventEmitter.addListener(
      'onQuickActionItemPressed',
      (payload) => {
        if (isMounted) {
          handler(payload);
        }
      }
    );
    return () => {
      isMounted = false;
      subscription.remove();
    };
  }, [handler]);
};
