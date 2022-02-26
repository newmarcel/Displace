//
//  NSScreen+DPLDisplay.m
//  DisplaceKit
//
//  Created by Marcel Dierkes on 16.01.21.
//

#import <DisplaceKit/NSScreen+DPLDisplay.h>
#import "../../DPLDefines.h"

static const NSDeviceDescriptionKey DPLScreenNumberKey = @"NSScreenNumber";

@implementation NSScreen (DPLDisplay)

- (CGDirectDisplayID)dpl_displayID
{
    Auto deviceDescription = self.deviceDescription;
    Auto screenNumber = (NSNumber *)deviceDescription[DPLScreenNumberKey];
    return (CGDirectDisplayID)screenNumber.integerValue;
}

@end
