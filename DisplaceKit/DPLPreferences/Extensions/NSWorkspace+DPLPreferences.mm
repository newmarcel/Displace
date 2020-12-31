//
//  NSWorkspace+DPLPreferences.mm
//  Displace
//
//  Created by Marcel Dierkes on 27.12.20.
//

#import "NSWorkspace+DPLPreferences.h"
#import "NSURL+DPLPreferences.h"

@implementation NSWorkspace (DPLPreferences)

- (void)dpl_openPreferencesWithCompletionHandler:(void(^)(NSRunningApplication *app, NSError *error))completionHandler
{
    auto appURL = NSURL.dpl_preferencesAppURL;
    auto config = [NSWorkspaceOpenConfiguration configuration];
    config.addsToRecentItems = NO;
    
    [self openApplicationAtURL:appURL
                 configuration:config
             completionHandler:^(NSRunningApplication *app, NSError *error) {
        if(completionHandler != nil)
        {
            completionHandler(app, error);
        }
    }];
}

@end
