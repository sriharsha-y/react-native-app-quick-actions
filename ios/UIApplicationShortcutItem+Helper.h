#import <UIKit/UIKit.h>

@interface UIApplicationShortcutItem (Helper)

- (NSDictionary *)asDictionary;
+ (UIApplicationShortcutItem *)from:(NSDictionary *)item;

@end
