//
//  DPLAppController.m
//  Displace
//
//  Created by Marcel Dierkes on 18.12.20.
//

#import "DPLAppController.h"
#import <DisplaceCommon/DisplaceCommon.h>
#import <DisplaceKit/DisplaceKit.h>
#import <DisplaceApplicationSupport/DisplaceApplicationSupport.h>
#import <ShortcutRecorder/ShortcutRecorder.h>
#import "DPLMenuController.h"
#import "DPLShortcutMonitor.h"
#import "DPLDisplayModeUserNotification.h"
#import "GeneratedAssetSymbols.h"

@interface DPLAppController () <DPLMenuControllerDataSource, DPLMenuControllerDelegate, DPLShortcutMonitorDelegate>
@property (nonatomic) NSArray<DPLDisplay *> *displays;
@property (nonatomic, readonly) DPLDisplay *activeDisplay;
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
        
        [DPLNotificationCenter.defaultCenter addObserver:NSApplication.sharedApplication
                                                selector:@selector(terminate:)
                                                    name:DPLAppShouldTerminateNotification];
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
    Auto image = [NSImage imageNamed:ACImageNameMenuBarIcon];
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

- (void)configureUserNotificationCenter
{
    Auto center = DPLUserNotificationCenter.sharedCenter;
    [center requestAuthorizationIfUndetermined];
    [center clearAllDeliveredNotifications];
}

- (DPLDisplay *)activeDisplay
{
    Auto app = NSApplication.sharedApplication;
    return app.dpl_activeDisplay ?: self.displays.firstObject;
}

- (void)screenParametersDidChange:(NSNotification *)notification
{
    DPLLog(@"Screen parameters did change, reload display list.");
    self.displays = DPLDisplay.allDisplays;
}

#pragma mark - Notifications

- (void)postNotificationForDisplay:(DPLDisplay *)display displayMode:(DPLDisplayMode *)displayMode direction:(NSComparisonResult)direction
{
    NSParameterAssert(displayMode);
    
    Auto center = DPLUserNotificationCenter.sharedCenter;
    
    BOOL increasing;
    switch(direction)
    {
        case NSOrderedAscending:
            increasing = YES;
            break;
        case NSOrderedDescending:
            increasing = NO;
            break;
        case NSOrderedSame:
            // don't post a notification
            return;
    }
    Auto notification = [[DPLDisplayModeUserNotification alloc] initWithDisplayName:display.localizedName
                                                                    displayModeName:displayMode.localizedName
                                                                         increasing:increasing];
    [center postNotification:notification];
}

- (void)postNotificationForDisplay:(DPLDisplay *)display newDisplayMode:(DPLDisplayMode *)newDisplayMode
{
    NSParameterAssert(display);
    NSParameterAssert(newDisplayMode);
    
    Auto currentDisplayMode = display.currentDisplayMode;
    if(currentDisplayMode == nil)
    {
        [self postNotificationForDisplay:display displayMode:newDisplayMode direction:NSOrderedAscending];
        return;
    }
    
    NSUInteger currentIndex = [display.displayModes indexOfObject:currentDisplayMode];
    NSUInteger newIndex = [display.displayModes indexOfObject:newDisplayMode];
    if(currentIndex > newIndex)
    {
        [self postNotificationForDisplay:display displayMode:newDisplayMode direction:NSOrderedAscending];
    }
    else if(currentIndex < newIndex)
    {
        [self postNotificationForDisplay:display displayMode:newDisplayMode direction:NSOrderedDescending];
    }
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

- (NSArray<NSString *> *)titlesForCurrentDisplayMode
{
    Auto displayModes = [NSMutableArray<NSString *> new];
    
    Auto displays = self.displays;
    for(DPLDisplay *display in displays)
    {
        Auto currentDisplayMode = display.currentDisplayMode;
        if(currentDisplayMode != nil)
        {
            [displayModes addObject:currentDisplayMode.localizedName];
        }
    }
    
    return [displayModes copy];
}

- (BOOL)displayAtIndexIsSidecar:(NSInteger)displayIndex
{
    return [self.displays[displayIndex] isSidecar];
}

- (NSImage *)imageForDisplayAtIndex:(NSInteger)displayIndex
{
    return self.displays[displayIndex].image;
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
    Auto settings = DPLSettings.sharedSettings;
    Auto shortcut = settings.increaseResolutionShortcut;
    if(shortcut != nil)
    {
        *key = [SRKeyEquivalentTransformer.sharedTransformer transformedValue:shortcut];
        *flags = shortcut.modifierFlags;
    }
}

- (void)keyEquivalentForDecrease:(NSString **)key modifierFlags:(NSEventModifierFlags *)flags
{
    Auto settings = DPLSettings.sharedSettings;
    Auto shortcut = settings.decreaseResolutionShortcut;
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
    
    [self postNotificationForDisplay:display newDisplayMode:displayMode];
    
    display.currentDisplayMode = displayMode;
    [display applyCurrentDisplayMode];
    
    [self.menuController reloadMenu];
}

- (void)menuControllerShouldIncreaseResolution:(DPLMenuController *)controller
{
    Auto display = self.activeDisplay;
    Auto next = display.nextDisplayMode;
    if(next != nil)
    {
        display.currentDisplayMode = next;
        [display applyCurrentDisplayMode];
        
        [self postNotificationForDisplay:display displayMode:next direction:NSOrderedAscending];
    }
}

- (void)menuControllerShouldDecreaseResolution:(DPLMenuController *)controller
{
    Auto display = self.activeDisplay;
    Auto previous = display.previousDisplayMode;
    if(previous != nil)
    {
        display.currentDisplayMode = previous;
        [display applyCurrentDisplayMode];
        
        [self postNotificationForDisplay:display displayMode:previous direction:NSOrderedDescending];
    }
}

#pragma mark - DPLShortcutMonitorDelegate

- (void)shortcutMonitorShouldIncreaseResolution:(DPLShortcutMonitor *)monitor
{
    Auto display = self.activeDisplay;
    Auto next = display.nextDisplayMode;
    if(next != nil)
    {
        display.currentDisplayMode = next;
        [display applyCurrentDisplayMode];

        [self postNotificationForDisplay:display displayMode:next direction:NSOrderedAscending];
    }
}

- (void)shortcutMonitorShouldDecreaseResolution:(DPLShortcutMonitor *)monitor
{
    Auto display = self.activeDisplay;
    Auto previous = display.previousDisplayMode;
    if(previous != nil)
    {
        display.currentDisplayMode = previous;
        [display applyCurrentDisplayMode];
        
        [self postNotificationForDisplay:display displayMode:previous direction:NSOrderedDescending];
    }
}

- (SRShortcut *)keyboardShortcutForIncreaseResolution
{
    Auto settings = DPLSettings.sharedSettings;
    return settings.increaseResolutionShortcut;
}

- (SRShortcut *)keyboardShortcutForDecreaseResolution
{
    Auto settings = DPLSettings.sharedSettings;
    return settings.decreaseResolutionShortcut;
}

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self configureUserNotificationCenter];
    
    [DPLSettings.sharedSettings performBlockOnFirstLaunch:^{
        Auto workspace = NSWorkspace.sharedWorkspace;
        [workspace dpl_openPreferencesWithCompletionHandler:nil];
    }];
    
    Auto center = NSNotificationCenter.defaultCenter;
    [center addObserver:self
               selector:@selector(screenParametersDidChange:)
                   name:NSApplicationDidChangeScreenParametersNotification
                 object:nil];
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
