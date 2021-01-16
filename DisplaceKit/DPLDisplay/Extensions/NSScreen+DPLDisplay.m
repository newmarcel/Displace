//
//  NSScreen+DPLDisplay.m
//  DisplaceKit
//
//  Created by Marcel Dierkes on 16.01.21.
//

#import "NSScreen+DPLDisplay.h"
const NSDeviceDescriptionKey DPLScreenNumberKey = @"NSScreenNumber";

@implementation NSScreen (DPLDisplay)

- (CGDirectDisplayID)dpl_displayID
{
    NSDictionary<NSDeviceDescriptionKey, id> *deviceDescription = self.deviceDescription;
    NSNumber *screenNumber = (NSNumber *)deviceDescription[DPLScreenNumberKey];
    return (CGDirectDisplayID)screenNumber.integerValue;
}

@end

@interface DPLDisplay (LocalizedName)
@property (copy, nonatomic, readwrite) NSString *localizedName;
@end

@implementation DPLDisplay (NSScreen)

+ (NSArray<DPLDisplay *> *)allDisplaysWithInformationFromScreens:(NSArray<NSScreen *> *)screens
{
    NSArray<DPLDisplay *> *allDisplays = [self allDisplays];
    if(screens == nil) { return allDisplays; }
    
    for(DPLDisplay *display in allDisplays)
    {
        for(NSScreen *screen in screens)
        {
            if(screen.dpl_displayID == display.displayID)
            {
                display.localizedName = screen.localizedName;
            }
        }
    }
    
    return allDisplays;
}

@end
