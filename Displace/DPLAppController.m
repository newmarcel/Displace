//
//  DPLAppController.m
//  Displace
//
//  Created by Marcel Dierkes on 18.12.20.
//

#import "DPLAppController.h"
#import <DisplaceKit/DisplaceKit.h>
#import <ShortcutRecorder/ShortcutRecorder.h>
#import "DPLDefines.h"
#import "DPLMenuController.h"
#import "DPLShortcutMonitor.h"
#import "DPLUserNotificationsController.h"
#import "DPLDisplayModeUserNotification.h"

@interface DPLAppController () <DPLMenuControllerDataSource, DPLMenuControllerDelegate, DPLShortcutMonitorDelegate>
@property (nonatomic) NSArray<DPLDisplay *> *displays;
@property (nonatomic, readwrite) NSStatusItem *systemStatusItem;
@property (nonatomic) DPLMenuController *menuController;
@property (nonatomic) DPLShortcutMonitor *shortcutMonitor;
@property (nonatomic) DPLUserNotificationsController *notificationsController;
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
        [self configureNotificationsController];
    }
    return self;
}

- (void)configureMenuController
{
    Auto controller = [DPLMenuController new];
    controller.dataSource = self;
    controller.delegate = self;
    self.menuController = controller;
    
    [controller reloadMenu];
}

- (void)configureStatusItem
{
    Auto statusItem = [NSStatusBar.systemStatusBar statusItemWithLength:NSVariableStatusItemLength];
    statusItem.behavior = NSStatusItemBehaviorTerminationOnRemoval;
    statusItem.visible = YES;
    
    Auto button = statusItem.button;
    ((NSButtonCell *)button.cell).highlightsBy = YES;
    Auto image = [NSImage imageNamed:@"MenuBarIcon"];
    button.image = image;
    
    statusItem.menu = self.menuController.menu;
    
    self.systemStatusItem = statusItem;
}

- (void)configureShortcutMonitor
{
    Auto monitor = [DPLShortcutMonitor new];
    monitor.delegate = self;
    self.shortcutMonitor = monitor;
    
    [monitor startMonitoring];
}

- (void)configureNotificationsController
{
    Auto controller = [DPLUserNotificationsController new];
    [controller requestAuthorization];
    [controller clearAllDeliveredNotifications];
    self.notificationsController = controller;
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
    Auto display = self.displays[displayIndex];
    Auto currentDisplayMode = display.currentDisplayMode;
    if(currentDisplayMode != nil)
    {
        return [display.displayModes indexOfObject:currentDisplayMode];
    }
    
    return -1;
}

- (NSString *)titleForDisplayModeAtIndexPath:(NSIndexPath *)indexPath
{
    Auto displayIndex = indexPath.section;
    Auto display = self.displays[displayIndex];
    Auto index = indexPath.item;
    Auto displayMode = display.displayModes[index];
    return displayMode.localizedName;
}

- (void)keyEquivalentForIncrease:(NSString **)key modifierFlags:(NSEventModifierFlags *)flags
{
    Auto preferences = DPLPreferences.sharedPreferences;
    Auto shortcut = preferences.increaseResolutionShortcut;
    if(shortcut != nil)
    {
        *key = [SRKeyEquivalentTransformer.sharedTransformer transformedValue:shortcut];
        *flags = shortcut.modifierFlags;
    }
}

- (void)keyEquivalentForDecrease:(NSString **)key modifierFlags:(NSEventModifierFlags *)flags
{
    Auto preferences = DPLPreferences.sharedPreferences;
    Auto shortcut = preferences.decreaseResolutionShortcut;
    if(shortcut != nil)
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
    Auto displayIndex = indexPath.section;
    Auto display = self.displays[displayIndex];
    Auto index = indexPath.item;
    Auto displayMode = display.displayModes[index];
    
    display.currentDisplayMode = displayMode;
    [display applyCurrentDisplayMode];
    
    [self.menuController reloadMenu];
}

- (void)menuControllerShouldIncreaseResolution:(DPLMenuController *)controller
{
#warning TODO: Get current display
    Auto display = self.displays.firstObject;
    Auto next = display.nextDisplayMode;
    if(next != nil)
    {
        display.currentDisplayMode = next;
        [display applyCurrentDisplayMode];
    }
}

- (void)menuControllerShouldDecreaseResolution:(DPLMenuController *)controller
{
#warning TODO: Get current display
    Auto display = self.displays.firstObject;
    Auto previous = display.previousDisplayMode;
    if(previous != nil)
    {
        display.currentDisplayMode = previous;
        [display applyCurrentDisplayMode];
    }
}

#pragma mark - DPLShortcutMonitorDelegate

- (void)shortcutMonitorShouldIncreaseResolution:(DPLShortcutMonitor *)monitor
{
#warning TODO: Get current display
    Auto display = self.displays.firstObject;
    Auto next = display.nextDisplayMode;
    if(next != nil)
    {
        display.currentDisplayMode = next;
        [display applyCurrentDisplayMode];
        
        Auto notification = [[DPLDisplayModeUserNotification alloc] initWithChangeType:DPLDisplayModeChangeTypeIncrease
                                                                              subtitle:next.localizedName];
        [self.notificationsController postNotification:notification];
    }
}

- (void)shortcutMonitorShouldDecreaseResolution:(DPLShortcutMonitor *)monitor
{
#warning TODO: Get current display
    Auto display = self.displays.firstObject;
    Auto previous = display.previousDisplayMode;
    if(previous != nil)
    {
        display.currentDisplayMode = previous;
        [display applyCurrentDisplayMode];
        
        Auto notification = [[DPLDisplayModeUserNotification alloc] initWithChangeType:DPLDisplayModeChangeTypeDecrease
                                                                              subtitle:previous.localizedName];
        [self.notificationsController postNotification:notification];
    }
}

- (SRShortcut *)keyboardShortcutForIncreaseResolution
{
    Auto preferences = DPLPreferences.sharedPreferences;
    return preferences.increaseResolutionShortcut;
}

- (SRShortcut *)keyboardShortcutForDecreaseResolution
{
    Auto preferences = DPLPreferences.sharedPreferences;
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
