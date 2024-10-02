//
//  DPLUserNotificationCenter.m
//  DisplaceUserNotifications
//
//  Created by Marcel Dierkes on 13.02.21.
//

#import <DisplaceUserNotifications/DPLUserNotificationCenter.h>
#import <UserNotifications/UserNotifications.h>
#import <DisplaceCommon/DisplaceCommon.h>

@interface DPLUserNotificationCenter ()
@property (nonatomic) UNUserNotificationCenter *center;
@end

@interface DPLUserNotification ()
- (UNNotificationContent *)createNotificationContent;
@end

@implementation DPLUserNotificationCenter

+ (instancetype)sharedCenter
{
    static dispatch_once_t once;
    static DPLUserNotificationCenter *sharedCenter;
    dispatch_once(&once, ^{
        sharedCenter = [self new];
    });
    return sharedCenter;
}

- (instancetype)init
{
    return [self initWithUserNotificationCenter:UNUserNotificationCenter.currentNotificationCenter];
}

- (instancetype)initWithUserNotificationCenter:(UNUserNotificationCenter *)center
{
    NSParameterAssert(center);
    self = [super init];
    if(self)
    {
        self.center = center;
    }
    return self;
}

#pragma mark - Authorization Status

- (void)getAuthorizationStatusWithCompletion:(void(NS_NOESCAPE ^)(DPLUserNotificationAuthorizationStatus))completion
{
    NSParameterAssert(completion);
    
    [self.center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
        DPLUserNotificationAuthorizationStatus authStatus;
        switch(settings.authorizationStatus)
        {
            case UNAuthorizationStatusNotDetermined:
                authStatus = DPLUserNotificationAuthorizationStatusUndetermined;
                break;
            case UNAuthorizationStatusProvisional:
                // fallthrough
            case DPLUserNotificationAuthorizationStatusGranted:
                authStatus = DPLUserNotificationAuthorizationStatusGranted;
                break;
            default:
                authStatus = DPLUserNotificationAuthorizationStatusDenied;
                break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(authStatus);
        });
    }];
}

- (void)requestAuthorizationWithCompletion:(NS_NOESCAPE DPLUserNotificationsAuthorizationCompletion)completion
{
    UNAuthorizationOptions options = UNAuthorizationOptionAlert | UNAuthorizationOptionProvisional;
    [self.center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError *error) {
        DPLUserNotificationAuthorizationStatus status;
        if(error != nil)
        {
            DPLLog(@"Failed to request notification access %@", error.userInfo);
            status = DPLUserNotificationAuthorizationStatusDenied;
        }
        else if(granted == YES)
        {
            status = DPLUserNotificationAuthorizationStatusGranted;
        }
        else
        {
            status = DPLUserNotificationAuthorizationStatusUndetermined;
        }
        
        if(completion != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(status, error);
            });
        }
    }];
}

- (void)requestAuthorizationIfUndetermined
{
    [self.center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
        if(settings.authorizationStatus == UNAuthorizationStatusNotDetermined)
        {
            [self requestAuthorizationWithCompletion:nil];
        }
    }];
}

#pragma mark - Notification Handling

- (void)clearAllDeliveredNotifications
{
    [self.center removeAllDeliveredNotifications];
}

- (void)postNotification:(__kindof DPLUserNotification *)notification
{
    NSParameterAssert(notification);
    
    Auto content = [notification createNotificationContent];
    Auto identifier = notification.identifier;
    
    Auto request = [UNNotificationRequest requestWithIdentifier:identifier
                                                        content:content
                                                        trigger:nil];
    [self.center addNotificationRequest:request withCompletionHandler:^(NSError *error) {
        if(error != nil)
        {
            DPLLog(@"Failed to add notification request. %@", error.userInfo);
        }
    }];
}

@end

@implementation DPLUserNotification

- (void)setLocalizedTitleWithKey:(NSString *)key arguments:(nullable NSArray *)arguments
{
    self.title = [NSString localizedUserNotificationStringForKey:key arguments:arguments];
}

- (void)setLocalizedSubtitleWithKey:(NSString *)key arguments:(nullable NSArray *)arguments
{
    self.subtitle = [NSString localizedUserNotificationStringForKey:key arguments:arguments];
}

- (void)setLocalizedBodyTextWithKey:(NSString *)key arguments:(nullable NSArray *)arguments
{
    self.bodyText = [NSString localizedUserNotificationStringForKey:key arguments:arguments];
}

- (UNNotificationContent *)createNotificationContent
{
    Auto content = [UNMutableNotificationContent new];
    content.title = self.title;
    content.subtitle = self.subtitle;
    content.body = self.bodyText;
    if(self.userInfo != nil)
    {
        content.userInfo = self.userInfo;
    }
    return [content copy];
}

@end
