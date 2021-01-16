//
//  NSScreen+DPLDisplay.m
//  DisplaceKit
//
//  Created by Marcel Dierkes on 16.01.21.
//

#import "NSScreen+DPLDisplay.h"
static const NSDeviceDescriptionKey DPLScreenNumberKey = @"NSScreenNumber";

@implementation NSScreen (DPLDisplay)

- (CGDirectDisplayID)dpl_displayID
{
    NSDictionary<NSDeviceDescriptionKey, id> *deviceDescription = self.deviceDescription;
    NSNumber *screenNumber = (NSNumber *)deviceDescription[DPLScreenNumberKey];
    return (CGDirectDisplayID)screenNumber.integerValue;
}

@end
