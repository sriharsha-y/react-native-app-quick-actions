#import <UIKit/UIKit.h>

@protocol ActionsDelegate <NSObject>
- (void)onQuickActionItemPressed:(id)data;
@end

@interface Actions : NSObject

@property(nonatomic, weak) id<ActionsDelegate> delegate;

+ (instancetype)shared;
- (void)performActionForQuickActionItem:(UIApplicationShortcutItem *)quickActionItem;
- (NSArray *)setQuickActions:(NSArray *)items;
- (void)getQuickActions:(void (^)(NSArray *))callback;
- (NSDictionary *)getInitialQuickAction;
- (void)clearQuickActions;

@end
