//
//  NSURL+DPLUserNotificationCenter.m
//  DisplaceUserNotifications
//
//  Created by Marcel Dierkes on 20.02.21.
//

#import <DisplaceUserNotifications/NSURL+DPLUserNotificationCenter.h>
#import <DisplaceCommon/DisplaceCommon.h>

@implementation NSURL (DPLUserNotificationCenter)

+ (NSURL *)dpl_notificationPreferencesURL
{
    return [self URLWithString:@"x-apple.systempreferences:com.apple.preference.notifications"];
}

@end
