//
//  NSURL+DPLPreferences.m
//  DisplaceApplicationSupport
//
//  Created by Marcel Dierkes on 26.12.20.
//

#import <DisplaceApplicationSupport/NSURL+DPLPreferences.h>
#import "DPLDefines.h"

static NSString * const DPLPreferencesAppBundleName = @"Displace Preferences.app";

@implementation NSURL (DPLPreferences)

+ (NSURL *)dpl_preferencesAppURL
{
    Auto bundle = NSBundle.mainBundle;
    return [bundle URLForAuxiliaryExecutable:DPLPreferencesAppBundleName];
}

@end
