#import <React/RCTEventEmitter.h>
#import "Actions.h"

#ifdef RCT_NEW_ARCH_ENABLED
#import <RNAppQuickActionsSpec/RNAppQuickActionsSpec.h>

@interface AppQuickActions : RCTEventEmitter <NativeAppQuickActionsSpec, ActionsDelegate>
#else
#import <React/RCTBridgeModule.h>

@interface AppQuickActions : RCTEventEmitter <RCTBridgeModule, ActionsDelegate>
#endif

+ (void)performActionForQuickActionItem:(UIApplicationShortcutItem *)quickActionItem completionHandler:(void (^)(BOOL succeeded))completionHandler;

@end
