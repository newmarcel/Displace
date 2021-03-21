//
//  NSApplication+DPLDisplay.m
//  DisplaceKit
//
//  Created by Marcel Dierkes on 15.02.21.
//

#import "NSApplication+DPLDisplay.h"
#import "DPLDefines.h"
#import "NSScreen+DPLDisplay.h"
#import "DPLDisplayManager.h"

@implementation NSApplication (DPLDisplay)

- (DPLDisplay *)dpl_activeDisplay
{
    Auto statusWindow = self.windows.firstObject; // most likely NSStatusBarWindow
    Auto screen = statusWindow.screen;
    Auto displayID = screen.dpl_displayID;
    Auto manager = DPLDisplayManager.sharedManager;
    return [manager displayWithDisplayID:displayID
             usingInformationFromScreens:@[screen]];
}

@end
