//
//  NSURL+DPLPreferences.m
//  DisplaceApplicationSupport
//
//  Created by Marcel Dierkes on 26.12.20.
//

#import <DisplaceApplicationSupport/NSURL+DPLPreferences.h>
#import <DisplaceCommon/DisplaceCommon.h>

static NSString * const DPLPreferencesAppBundleName = @"Displace Settings.app";

@implementation NSURL (DPLPreferences)

+ (NSURL *)dpl_preferencesAppURL
{
    Auto bundle = NSBundle.mainBundle;
    return [bundle URLForAuxiliaryExecutable:DPLPreferencesAppBundleName];
}

@end
