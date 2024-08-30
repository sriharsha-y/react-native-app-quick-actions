import { NativeModules, Platform } from 'react-native';
import type { Specification } from './types';

const LINKING_ERROR =
  `The package 'react-native-app-quick-actions' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

// @ts-expect-error
const isTurboModuleEnabled = global.__turboModuleProxy != null;

const AppQuickActionsModule = isTurboModuleEnabled
  ? require('./NativeAppQuickActions').default
  : NativeModules.AppQuickActions;

const AppQuickActions: Specification = AppQuickActionsModule
  ? AppQuickActionsModule
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export default AppQuickActions;
