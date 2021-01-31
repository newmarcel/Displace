//
//  DPLPreferencesWindowController.mm
//  DPLPreferences
//
//  Created by Marcel Dierkes on 27.12.20.
//

#import "DPLPreferencesWindowController.h"

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

@end
