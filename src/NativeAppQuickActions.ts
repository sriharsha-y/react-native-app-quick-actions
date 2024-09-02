import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';
import type { QuickActionItem } from './types';

export interface Spec extends TurboModule {
  /**
   * Set the quick action items.
   * @returns a promise with the items that were set
   */
  setQuickActions(items: QuickActionItem[]): Promise<QuickActionItem[]>;

  /**
   * @returns a promise with the quick action items that were set
   */
  getQuickActions(): Promise<QuickActionItem[]>;

  getInitialShortcut(): Promise<QuickActionItem>;
  

  /**
   * Removes all the quick action items
   */
  clearQuickActions(): void;

  /**
   * Required for NativeEventEmitter when using Turbo Module
   * Implementation will be already provided by ReactNative.
   */
  addListener: (eventType: string) => void;
  removeListeners: (count: number) => void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('AppQuickActions');
