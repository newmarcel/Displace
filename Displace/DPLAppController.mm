//
//  DPLAppController.m
//  Displace
//
//  Created by Marcel Dierkes on 18.12.20.
//

#import "DPLAppController.h"
#import <DisplaceKit/DisplaceKit.h>
#import "DPLMenuController.h"
#import <ShortcutRecorder/ShortcutRecorder.h>

@interface DPLAppController () <DPLMenuControllerDataSource, DPLMenuControllerDelegate>
@property (nonatomic) NSArray<DPLDisplay *> *displays;
@property (nonatomic) DPLMenuController *menuController;
@property (nonatomic, readwrite) NSStatusItem *systemStatusItem;
@end

@implementation DPLAppController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.displays = DPLDisplay.allDisplays;
        [self configureMenuController];
        [self configureStatusItem];
        
        {
            auto shortcut = [SRShortcut shortcutWithKeyEquivalent:@"⌃⌥⌘↑"];
            auto action = [SRShortcutAction shortcutActionWithShortcut:shortcut actionHandler:^BOOL(SRShortcutAction *action) {
                NSLog(@"Yeah");
                if(auto dpl = self.displays.firstObject)
                {
                    dpl.currentDisplayMode = dpl.nextDisplayMode;
                    [dpl applyCurrentDisplayMode];
                }
                return YES;
            }];
            [SRGlobalShortcutMonitor.sharedMonitor addAction:action
                                                 forKeyEvent:SRKeyEventTypeDown];
        }
    }
    return self;
}

- (void)configureMenuController
{
    auto controller = [DPLMenuController new];
    controller.dataSource = self;
    controller.delegate = self;
    self.menuController = controller;
    
    [controller reloadMenu];
}

- (void)configureStatusItem
{
    auto statusItem = [NSStatusBar.systemStatusBar statusItemWithLength:NSVariableStatusItemLength];
    statusItem.behavior = NSStatusItemBehaviorTerminationOnRemoval;
    statusItem.visible = YES;
    
    auto button = statusItem.button;
    static_cast<NSButtonCell *>(button.cell).highlightsBy = YES;
    auto image = [NSImage imageNamed:@"MenuBarIcon"];
    button.image = image;
    
    statusItem.menu = self.menuController.menu;
    
    self.systemStatusItem = statusItem;
}

#pragma mark - DPLMenuControllerDataSource

- (NSInteger)numberOfDisplays
{
    return self.displays.count;
}

- (NSString *)titleForDisplayAtIndex:(NSInteger)displayIndex
{
    return self.displays[displayIndex].localizedName;
}

- (NSInteger)numberOfDisplayModesForDisplayAtIndex:(NSInteger)displayIndex
{
    return self.displays[displayIndex].displayModes.count;
}

- (NSInteger)currentDisplayModeIndexForDisplayAtIndex:(NSInteger)displayIndex
{
    auto display = self.displays[displayIndex];
    if(auto currentDisplayMode = display.currentDisplayMode)
    {
        return [display.displayModes indexOfObject:currentDisplayMode];
    }
    
    return -1;
}

- (NSString *)titleForDisplayModeAtIndexPath:(NSIndexPath *)indexPath
{
    auto displayIndex = indexPath.section;
    auto display = self.displays[displayIndex];
    auto index = indexPath.item;
    auto displayMode = display.displayModes[index];
    return displayMode.localizedName;
}

#pragma mark - DPLMenuControllerDelegate

- (void)menuControllerShouldShowPreferences:(DPLMenuController *)controller
{
    [NSWorkspace.sharedWorkspace dpl_openPreferencesWithCompletionHandler:nil];
}

- (void)menuControllerShouldTerminate:(DPLMenuController *)controller
{
    [NSApplication.sharedApplication terminate:controller];
}

- (void)menuController:(DPLMenuController *)controller didSelectDisplayModeAtIndexPath:(NSIndexPath *)indexPath
{
    auto displayIndex = indexPath.section;
    auto display = self.displays[displayIndex];
    auto index = indexPath.item;
    auto displayMode = display.displayModes[index];
    
    display.currentDisplayMode = displayMode;
    [display applyCurrentDisplayMode];
    
    [self.menuController reloadMenu];
}

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    [NSWorkspace.sharedWorkspace dpl_openPreferencesWithCompletionHandler:nil];
    return NO;
}

@end
