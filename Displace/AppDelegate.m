//
//  AppDelegate.m
//  Displace
//
//  Created by Marcel Dierkes on 11.10.20.
//

#import "DPLAppDelegate.h"

@interface DPLAppDelegate ()
@property (nonatomic) IBOutlet NSWindow *window;
@end

@implementation DPLAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

@end
