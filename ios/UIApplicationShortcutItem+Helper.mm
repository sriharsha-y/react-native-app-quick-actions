#import "UIApplicationShortcutItem+Helper.h"

static NSDictionary<NSString *, NSNumber *> *iconTypeMap = @{
    @"compose": @(UIApplicationShortcutIconTypeCompose),
    @"play": @(UIApplicationShortcutIconTypePlay),
    @"pause": @(UIApplicationShortcutIconTypePause),
    @"add": @(UIApplicationShortcutIconTypeAdd),
    @"location": @(UIApplicationShortcutIconTypeLocation),
    @"search": @(UIApplicationShortcutIconTypeSearch),
    @"share": @(UIApplicationShortcutIconTypeShare),
    @"prohibit": @(UIApplicationShortcutIconTypeProhibit),
    @"contact": @(UIApplicationShortcutIconTypeContact),
    @"home": @(UIApplicationShortcutIconTypeHome),
    @"markLocation": @(UIApplicationShortcutIconTypeMarkLocation),
    @"favorite": @(UIApplicationShortcutIconTypeFavorite),
    @"love": @(UIApplicationShortcutIconTypeLove),
    @"cloud": @(UIApplicationShortcutIconTypeCloud),
    @"invitation": @(UIApplicationShortcutIconTypeInvitation),
    @"confirmation": @(UIApplicationShortcutIconTypeConfirmation),
    @"mail": @(UIApplicationShortcutIconTypeMail),
    @"message": @(UIApplicationShortcutIconTypeMessage),
    @"date": @(UIApplicationShortcutIconTypeDate),
    @"time": @(UIApplicationShortcutIconTypeTime),
    @"capturePhoto": @(UIApplicationShortcutIconTypeCapturePhoto),
    @"captureVideo": @(UIApplicationShortcutIconTypeCaptureVideo),
    @"task": @(UIApplicationShortcutIconTypeTask),
    @"taskCompleted": @(UIApplicationShortcutIconTypeTaskCompleted),
    @"alarm": @(UIApplicationShortcutIconTypeAlarm),
    @"bookmark": @(UIApplicationShortcutIconTypeBookmark),
    @"shuffle": @(UIApplicationShortcutIconTypeShuffle),
    @"audio": @(UIApplicationShortcutIconTypeAudio),
    @"update": @(UIApplicationShortcutIconTypeUpdate),
};

@implementation UIApplicationShortcutItem (Helper)

- (NSDictionary *)asDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.type forKey:@"type"];
    [dict setObject:self.localizedTitle forKey:@"title"];
    if(self.localizedSubtitle != nil) {
        [dict setObject:self.localizedSubtitle forKey:@"subtitle"];
    }
    if(self.userInfo != nil) {
        [dict setObject:self.userInfo forKey:@"data"];
    }
    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (UIApplicationShortcutItem *)from:(NSDictionary *)item {
    if(item == nil || [item objectForKey:@"type"] == nil || [item objectForKey:@"title"] == nil) {
        return nil;
    }
    UIApplicationShortcutIcon *icon;
    if([item objectForKey:@"iconName"] != nil) {
        NSString *iconName = [item objectForKey:@"iconName"];
        if(iconName != nil && [iconName length] != 0) {
            NSArray *iconNameComponents = [iconName componentsSeparatedByString:@":"];
            if([[iconNameComponents firstObject] isEqualToString:[iconNameComponents lastObject]]) {
                icon = [UIApplicationShortcutIcon iconWithTemplateImageName: [iconNameComponents firstObject]];
            } else if ([[iconNameComponents firstObject] isEqualToString:@"symbol"]) {
                icon = [UIApplicationShortcutIcon iconWithSystemImageName: [iconNameComponents lastObject]];
            } else if ([[iconNameComponents firstObject] isEqualToString:@"system"]) {
                NSNumber *iconType = [iconTypeMap objectForKey:[iconNameComponents lastObject]];
                //                icon = [UIApplicationShortcutIcon iconWithType: [iconType integerValue]];
            }
        }
    }
    return [[UIApplicationShortcutItem alloc] initWithType:[item objectForKey:@"type"] localizedTitle:[item objectForKey:@"title"] localizedSubtitle:[item objectForKey:@"subtitle"] icon:icon userInfo:[item objectForKey:@"data"]];
}

@end
