//
//  NSWorkspace+DPLUserNotificationCenter.m
//  DisplaceKit
//
//  Created by Marcel Dierkes on 20.02.21.
//

#import <DisplaceKit/NSURL+DPLUserNotificationCenter.h>
#import <DisplaceKit/NSWorkspace+DPLUserNotificationCenter.h>
#import "../DPLDefines.h"

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
