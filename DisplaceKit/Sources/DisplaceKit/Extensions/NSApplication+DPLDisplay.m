//
//  NSApplication+DPLDisplay.m
//  DisplaceKit
//
//  Created by Marcel Dierkes on 15.02.21.
//

#import <DisplaceKit/NSApplication+DPLDisplay.h>
#import <DisplaceKit/NSScreen+DPLDisplay.h>
#import "../DPLDefines.h"
#import "../DPLDisplayManager/DPLDisplayManager.h"

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
