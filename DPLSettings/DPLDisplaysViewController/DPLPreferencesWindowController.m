//
//  DPLPreferencesWindowController.m
//  DPLPreferences
//
//  Created by Marcel Dierkes on 27.12.20.
//

#import "DPLPreferencesWindowController.h"
#import <DisplaceCommon/DisplaceCommon.h>
#import <DisplaceApplicationSupport/DisplaceApplicationSupport.h>
#import "DPLPreferencesLocalizedStrings.h"
#import "DPLDisplaysViewController.h"

@interface DPLPreferencesWindowController ()
@end

@implementation DPLPreferencesWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Window auto save identifier
    self.windowFrameAutosaveName = @"DPLPreferencesWindow";
    
    // Split auto save identifier
    Auto splitViewController = (NSSplitViewController *)self.contentViewController;
    splitViewController.splitView.autosaveName = @"DPLPreferencesSplit";
    
    
    Auto center = NSNotificationCenter.defaultCenter;
    [center addObserver:self
               selector:@selector(screenParametersDidChange:)
                   name:NSApplicationDidChangeScreenParametersNotification
                 object:nil];
}

- (void)screenParametersDidChange:(NSNotification *)notification
{
    DPLLog(@"Screen parameters did change, reload display list.");
    
    Auto splitViewController = (NSSplitViewController *)self.contentViewController;
    Auto splitViewItems = splitViewController.splitViewItems;
    Auto controller = (DPLDisplaysViewController *)splitViewItems.firstObject.viewController;
    if([controller isKindOfClass:[DPLDisplaysViewController class]])
    {
        [controller reloadData];
    }
}

- (IBAction)completelyTerminate:(id)sender
{
    Auto center = DPLNotificationCenter.defaultCenter;
    [center postNotification:DPLAppShouldTerminateNotification];
    [NSApplication.sharedApplication terminate:sender];
}

- (IBAction)showAboutPanel:(nullable id)sender
{
    Auto appName = DPL_L10N_DISPLACE_APP_NAME;
    [NSApplication.sharedApplication orderFrontStandardAboutPanelWithOptions:@{
        NSAboutPanelOptionApplicationName: appName
    }];
}

@end
