export type IDictionary = {
  [key: string]: IAny;
};

export type IAny =
  | boolean
  | number
  | string
  | Object
  | IDictionary
  | Array<IAny>;

export interface QuickActionItem {
  /**
   * Unique string used to identify the type of the action
   */
  type: string;

  /**
   * On Android - it's recommended to keep this under 25 characters. If there
   * isn't enough space to display this, fallsback to `shortTitle`
   */
  title: string;

  /**
   * Android only, max 10 characters recommended. This is displayed instead of
   * `title` when there is not enough space to display the title.
   */
  shortTitle?: string;

  /**
   * iOS only, ignored on Android
   */
  subtitle?: string;

  /**
   * The name of the iOS Asset or Android drawable
   */
  iconName?: string;

  /**
   * Custom payload for the action
   */
  data?: IDictionary;
}
