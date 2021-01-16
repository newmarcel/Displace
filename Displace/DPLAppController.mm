//
//  DPLAppController.m
//  Displace
//
//  Created by Marcel Dierkes on 18.12.20.
//

#import "DPLAppController.h"
#import <DisplaceKit/DisplaceKit.h>
#import <ShortcutRecorder/ShortcutRecorder.h>
#import "DPLMenuController.h"
#import "DPLShortcutMonitor.h"

@interface DPLAppController () <DPLMenuControllerDataSource, DPLMenuControllerDelegate, DPLShortcutMonitorDelegate>
@property (nonatomic) NSArray<DPLDisplay *> *displays;
@property (nonatomic, readwrite) NSStatusItem *systemStatusItem;
@property (nonatomic) DPLMenuController *menuController;
@property (nonatomic) DPLShortcutMonitor *shortcutMonitor;
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
        [self configureShortcutMonitor];
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

- (void)configureShortcutMonitor
{
    auto monitor = [DPLShortcutMonitor new];
    monitor.delegate = self;
    self.shortcutMonitor = monitor;
    
    [monitor startMonitoring];
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

- (void)keyEquivalentForIncrease:(NSString **)key modifierFlags:(NSEventModifierFlags *)flags
{
    auto preferences = DPLPreferences.sharedPreferences;
    if(auto shortcut = preferences.increaseResolutionShortcut)
    {
        *key = [SRKeyEquivalentTransformer.sharedTransformer transformedValue:shortcut];
        *flags = shortcut.modifierFlags;
    }
}

- (void)keyEquivalentForDecrease:(NSString **)key modifierFlags:(NSEventModifierFlags *)flags
{
    auto preferences = DPLPreferences.sharedPreferences;
    if(auto shortcut = preferences.decreaseResolutionShortcut)
    {
        *key = [SRKeyEquivalentTransformer.sharedTransformer transformedValue:shortcut];
        *flags = shortcut.modifierFlags;
    }
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

- (void)menuControllerShouldIncreaseResolution:(DPLMenuController *)controller
{
#warning TODO: Get current display
    auto display = self.displays.firstObject;
    if(auto next = display.nextDisplayMode)
    {
        display.currentDisplayMode = next;
        [display applyCurrentDisplayMode];
    }
}

- (void)menuControllerShouldDecreaseResolution:(DPLMenuController *)controller
{
#warning TODO: Get current display
    auto display = self.displays.firstObject;
    if(auto previous = display.previousDisplayMode)
    {
        display.currentDisplayMode = previous;
        [display applyCurrentDisplayMode];
    }
}

#pragma mark - DPLShortcutMonitorDelegate

- (void)shortcutMonitorShouldIncreaseResolution:(DPLShortcutMonitor *)monitor
{
#warning TODO: Get current display
    auto display = self.displays.firstObject;
    if(auto next = display.nextDisplayMode)
    {
        display.currentDisplayMode = next;
        [display applyCurrentDisplayMode];
    }
}

- (void)shortcutMonitorShouldDecreaseResolution:(DPLShortcutMonitor *)monitor
{
#warning TODO: Get current display
    auto display = self.displays.firstObject;
    if(auto previous = display.previousDisplayMode)
    {
        display.currentDisplayMode = previous;
        [display applyCurrentDisplayMode];
    }
}

- (SRShortcut *)keyboardShortcutForIncreaseResolution
{
    auto preferences = DPLPreferences.sharedPreferences;
    return preferences.increaseResolutionShortcut;
}

- (SRShortcut *)keyboardShortcutForDecreaseResolution
{
    auto preferences = DPLPreferences.sharedPreferences;
    return preferences.decreaseResolutionShortcut;
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
