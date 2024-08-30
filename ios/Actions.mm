#import "Actions.h"
#import "UIApplicationShortcutItem+Helper.h"

@interface Actions ()
@property (nonatomic, strong) UIApplicationShortcutItem *unhandledQuickActionItem;
@end

@implementation Actions

+ (instancetype)shared {
    static Actions *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)init {
    if (self = [super init]) {
        // Initialise any properties
    }
    return self;
}

- (void)setDelegate:(id<ActionsDelegate>)delegate {
    _delegate = delegate;
    [self processUnhandledQuickActionItem];
}

- (void)processUnhandledQuickActionItem {
    if(self.unhandledQuickActionItem == nil || self.delegate == nil) {
        return;
    }
    [self.delegate onQuickActionItemPressed:@{
        @"item": self.unhandledQuickActionItem.asDictionary,
        @"initial": @YES
    }];
    self.unhandledQuickActionItem = nil;
}

- (NSArray<NSDictionary *> *)getQuickActionsForJS:(NSArray<UIApplicationShortcutItem *> *)items {
    NSMutableArray<NSDictionary *> *quickActions = [NSMutableArray array];
    for(UIApplicationShortcutItem *item in items) {
        NSDictionary *dict = [item asDictionary];
        if(dict != nil) {
            [quickActions addObject:dict];
        }
    }
    return [NSArray arrayWithArray:quickActions];
}

- (NSArray *)setQuickActions:(NSArray *)items {
    NSMutableArray<UIApplicationShortcutItem *> *quickActionItems = [NSMutableArray array];
    for(NSDictionary *dict in items) {
        UIApplicationShortcutItem *item = [UIApplicationShortcutItem from:dict];
        if(item != nil) {
            [quickActionItems addObject:item];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIApplication.sharedApplication.shortcutItems = quickActionItems;
    });
    
    return [self getQuickActionsForJS:quickActionItems];
}

- (void)getQuickActions:(void(^)(NSArray *))callback {
    __weak Actions *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        callback([weakSelf getQuickActionsForJS:UIApplication.sharedApplication.shortcutItems]);
    });
}

- (void)clearQuickActions {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIApplication.sharedApplication.shortcutItems = nil;
    });
}

- (void)performActionForQuickActionItem:(UIApplicationShortcutItem *)quickActionItem {
    if(self.delegate == nil) {
        _unhandledQuickActionItem = quickActionItem;
        return;
    }
    [self.delegate onQuickActionItemPressed:@{
        @"item": quickActionItem.asDictionary,
        @"initial": @NO
    }];
}

@end
