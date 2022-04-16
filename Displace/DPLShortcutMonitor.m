//
//  DPLShortcutMonitor.m
//  Displace
//
//  Created by Marcel Dierkes on 02.01.21.
//

#import "DPLShortcutMonitor.h"
#import <DisplaceApplicationSupport/DisplaceApplicationSupport.h>
#import <ShortcutRecorder/ShortcutRecorder.h>
#import "DPLDefines.h"

@interface DPLShortcutMonitor ()
@property (weak, nonatomic, nullable) SRShortcutAction *increaseAction;
@property (weak, nonatomic, nullable) SRShortcutAction *decreaseAction;
@end

@implementation DPLShortcutMonitor

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self registerNotifications];
    }
    return self;
}

- (void)dealloc
{
    [self unregisterNotifications];
}

- (void)registerNotifications
{
    Auto center = DPLNotificationCenter.defaultCenter;
    [center addObserver:self selector:@selector(keyboardShortcutsDidChange:)
                   name:DPLShortcutDidChangeNotification];
    [center addObserver:self selector:@selector(keyboardShortcutsWillEdit:)
                   name:DPLShortcutWillEditNotification];
    [center addObserver:self selector:@selector(keyboardShortcutsDidEdit:)
                   name:DPLShortcutDidEditNotification];
}

- (void)unregisterNotifications
{
    Auto center = DPLNotificationCenter.defaultCenter;
    [center removeObserver:self name:DPLShortcutDidChangeNotification];
    [center removeObserver:self name:DPLShortcutWillEditNotification];
    [center removeObserver:self name:DPLShortcutDidEditNotification];
}

- (void)keyboardShortcutsDidChange:(nullable NSNotification *)notification
{
    DPLLog(@"Keyboard shortcuts were changed: %@", notification);
    
    [self refreshShortcuts];
}

- (void)keyboardShortcutsWillEdit:(nullable NSNotification *)notification
{
    Auto monitor = SRGlobalShortcutMonitor.sharedMonitor;
    [monitor pause];
}


- (void)keyboardShortcutsDidEdit:(nullable NSNotification *)notification
{
    Auto monitor = SRGlobalShortcutMonitor.sharedMonitor;
    [monitor resume];
}

- (void)startMonitoring
{
    [self stopMonitoring];
    
    [self refreshShortcuts];
}

- (void)stopMonitoring
{
    Auto monitor = SRGlobalShortcutMonitor.sharedMonitor;
    [monitor removeAllActions];
}

#pragma mark - Shortcut Registration

- (void)refreshShortcuts
{
    Auto delegate = self.delegate;
    [self registerIncreaseShortcut:[delegate keyboardShortcutForIncreaseResolution]];
    [self registerDecreaseShortcut:[delegate keyboardShortcutForDecreaseResolution]];
}

- (void)registerIncreaseShortcut:(nullable SRShortcut *)increaseShortcut
{
    Auto monitor = SRGlobalShortcutMonitor.sharedMonitor;
    Auto sender = self;
    Auto delegate = sender.delegate;
    
    // Everything was de-registered
    if(increaseShortcut == nil)
    {
        if(self.increaseAction != nil)
        {
            [monitor removeAction:self.increaseAction];
        }
        return;
    }
    
    // There is an action already
    if(self.increaseAction != nil)
    {
        self.increaseAction.shortcut = increaseShortcut;
        return;
    }
    
    // Install a new action
    Auto increaseAction = [SRShortcutAction shortcutActionWithShortcut:increaseShortcut actionHandler:^BOOL(SRShortcutAction *action) {
        if([delegate respondsToSelector:@selector(shortcutMonitorShouldIncreaseResolution:)])
        {
            [delegate shortcutMonitorShouldIncreaseResolution:sender];
        }
        return YES;
    }];
    [monitor addAction:increaseAction forKeyEvent:SRKeyEventTypeUp];
    self.increaseAction = increaseAction;
}

- (void)registerDecreaseShortcut:(nullable SRShortcut *)decreaseShortcut
{
    Auto monitor = SRGlobalShortcutMonitor.sharedMonitor;
    Auto sender = self;
    Auto delegate = sender.delegate;
    
    // Everything was de-registered
    if(decreaseShortcut == nil)
    {
        if(self.decreaseAction != nil)
        {
            [monitor removeAction:self.decreaseAction];
        }
        return;
    }
    
    // There is an action already
    if(self.decreaseAction != nil)
    {
        self.decreaseAction.shortcut = decreaseShortcut;
        return;
    }
    
    // Install a new action
    Auto decreaseAction = [SRShortcutAction shortcutActionWithShortcut:decreaseShortcut actionHandler:^BOOL(SRShortcutAction *action) {
        if([delegate respondsToSelector:@selector(shortcutMonitorShouldDecreaseResolution:)])
        {
            [delegate shortcutMonitorShouldDecreaseResolution:sender];
        }
        return YES;
    }];
    [monitor addAction:decreaseAction forKeyEvent:SRKeyEventTypeUp];
    self.decreaseAction = decreaseAction;
}

@end
