//
//  DPLPreferencesWindowController.mm
//  DPLPreferences
//
//  Created by Marcel Dierkes on 27.12.20.
//

#import "DPLPreferencesWindowController.h"
#import "DPLDefines.h"

@interface DPLPreferencesWindowController ()
@end

@implementation DPLPreferencesWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Window auto save identifier
    self.windowFrameAutosaveName = @"DPLPreferencesWindow";
    
    // Split auto save identifier
    auto splitViewController = (NSSplitViewController *)self.contentViewController;
    splitViewController.splitView.autosaveName = @"DPLPreferencesSplit";
}

- (IBAction)showAboutPanel:(nullable id)sender
{
    Auto appName = NSLocalizedString(@"Displace", @"Displace");
    [NSApplication.sharedApplication orderFrontStandardAboutPanelWithOptions:@{
        NSAboutPanelOptionApplicationName: appName
    }];
}

@end
