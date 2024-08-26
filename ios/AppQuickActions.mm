#import "AppQuickActions.h"

#define ON_QUICK_ACTION_ITEM_PRESSED @"onQuickActionItemPressed"

@implementation AppQuickActions
RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup {
    return NO;
}

- (NSArray<NSString *> *)supportedEvents {
    return @[ON_QUICK_ACTION_ITEM_PRESSED];
}

-(void)startObserving {
    Actions.shared.delegate = self;
}

-(void)stopObserving {
    Actions.shared.delegate = nil;
}

- (void)onQuickActionItemPressed:(id)data {
    [self sendEventWithName:ON_QUICK_ACTION_ITEM_PRESSED body:data];
}

+ (void)performActionForQuickActionItem:(UIApplicationShortcutItem *)quickActionItem completionHandler:(void (^__strong)(BOOL))completionHandler {
    [Actions.shared performActionForQuickActionItem:quickActionItem];
}

RCT_EXPORT_METHOD(setQuickActions:(NSArray *)items
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    if(items == nil) {
        NSError *error = [[NSError alloc] initWithDomain:@"QuickActions" code:1 userInfo:nil];
        reject(@"1", @"unable to set quick actions", error);
        return;
    }
    NSArray *quickActions = [Actions.shared setQuickActions:items];
    resolve(quickActions);
}

RCT_EXPORT_METHOD(getQuickActions:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    [Actions.shared getQuickActions:^(NSArray *quickActions) {
        resolve(quickActions);
    }];
}

RCT_EXPORT_METHOD(clearQuickActions) {
    [Actions.shared clearQuickActions];
}

// Don't compile this code when we build for the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
(const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeAppQuickActionsSpecJSI>(params);
}
#endif

@end
