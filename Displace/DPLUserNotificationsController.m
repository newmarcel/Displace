//
//  DPLUserNotificationsController.m
//  Displace
//
//  Created by Marcel Dierkes on 13.02.21.
//

#import "DPLUserNotificationsController.h"
#import <UserNotifications/UserNotifications.h>
#import "DPLDefines.h"

@interface DPLUserNotificationsController ()
@property (nonatomic, readwrite) DPLUserNotificationsAuthorizationStatus authorizationStatus;
@property (nonatomic) UNUserNotificationCenter *center;
@end

@interface DPLUserNotification ()
- (UNNotificationContent *)createNotificationContent;
@end

@implementation DPLUserNotificationsController

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

- (void)requestAuthorizationWithCompletion:(DPLUserNotificationsAuthorizationCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    UNAuthorizationOptions options = UNAuthorizationOptionAlert | UNAuthorizationOptionProvisional;
    [self.center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError *error) {
        DPLUserNotificationsAuthorizationStatus status;
        if(error != nil)
        {
            DPLLog(@"Failed to request notification access %@", error.userInfo);
            status = DPLUserNotificationsAuthorizationStatusDenied;
        }
        else if(granted == YES)
        {
            status = DPLUserNotificationsAuthorizationStatusGranted;
        }
        else
        {
            status = DPLUserNotificationsAuthorizationStatusUndetermined;
        }
        weakSelf.authorizationStatus = status;
        
        if(completion != nil)
        {
            completion(status, error);
        }
    }];
}

- (void)clearAllDeliveredNotifications
{
    [self.center removeAllDeliveredNotifications];
}

- (BOOL)postNotification:(__kindof DPLUserNotification *)notification
{
    NSParameterAssert(notification);
    
    if(self.authorizationStatus != DPLUserNotificationsAuthorizationStatusGranted)
    {
        DPLLog(@"Posting notifications has not been granted.");
        return NO;
    }
    
    Auto content = [notification createNotificationContent];
    Auto request = [UNNotificationRequest requestWithIdentifier:notification.identifier
                                                        content:content
                                                        trigger:nil];
    [self.center addNotificationRequest:request withCompletionHandler:^(NSError *error) {
        DPLLog(@"Added notification. (Error? %@)", error.userInfo);
    }];
    
    return YES;
}

@end

@implementation DPLUserNotification

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
