//
//  NSWorkspace+DPLUserNotificationCenter.m
//  DisplaceUserNotifications
//
//  Created by Marcel Dierkes on 20.02.21.
//

#import <DisplaceUserNotifications/NSWorkspace+DPLUserNotificationCenter.h>
#import <DisplaceUserNotifications/NSURL+DPLUserNotificationCenter.h>
#import "DPLDefines.h"

@implementation NSWorkspace (DPLUserNotificationCenter)

- (void)dpl_openNotificationPreferencesWithCompletionHandler:(DPLOpenNotificationsCompletionHandler)completionHandler
{
    Auto prefURL = NSURL.dpl_notificationPreferencesURL;
    Auto config = [NSWorkspaceOpenConfiguration configuration];
    config.addsToRecentItems = NO;
    
    [self openApplicationAtURL:prefURL
                 configuration:config
             completionHandler:^(NSRunningApplication *app, NSError *error) {
        if(completionHandler != nil)
        {
            completionHandler(app, error);
        }
    }];
}

@end
