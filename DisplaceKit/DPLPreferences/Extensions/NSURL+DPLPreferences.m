//
//  NSURL+DPLPreferences.m
//  DisplaceKit
//
//  Created by Marcel Dierkes on 26.12.20.
//

#import "NSURL+DPLPreferences.h"
#import "DPLDefines.h"

static NSString * const DPLPreferencesAppBundleName = @"Displace Preferences.app";

@implementation NSURL (DPLPreferences)

+ (NSURL *)dpl_preferencesAppURL
{
    Auto executableBaseURL = NSBundle.mainBundle.executableURL.URLByDeletingLastPathComponent;
    return [executableBaseURL URLByAppendingPathComponent:DPLPreferencesAppBundleName
                                              isDirectory:NO];
}

@end
