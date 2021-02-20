//
//  NSURL+DPLUserNotificationCenter.m
//  DisplaceKit
//
//  Created by Marcel Dierkes on 20.02.21.
//

#import "NSURL+DPLUserNotificationCenter.h"
#import "DPLDefines.h"

@implementation NSURL (DPLUserNotificationCenter)

+ (NSURL *)dpl_notificationPreferencesURL
{
    return [self URLWithString:@"x-apple.systempreferences:com.apple.preference.notifications"];
}

@end
