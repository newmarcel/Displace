//
//  DPLShortcutMonitor.mm
//  Displace
//
//  Created by Marcel Dierkes on 02.01.21.
//

#import "DPLShortcutMonitor.h"
#import <DisplaceKit/DisplaceKit.h>
#import <ShortcutRecorder/ShortcutRecorder.h>

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
    DPLDistributedNotificationAddObserver(self,
                                          @selector(keyboardShortcutsDidChange:),
                                          DPLShortcutDidChangeNotification);
    DPLDistributedNotificationAddObserver(self,
                                          @selector(keyboardShortcutsWillEdit:),
                                          DPLShortcutWillEditNotification);
    DPLDistributedNotificationAddObserver(self,
                                          @selector(keyboardShortcutsDidEdit:),
                                          DPLShortcutDidEditNotification);
}

- (void)unregisterNotifications
{
    DPLDistributedNotificationRemoveObserver(self, DPLShortcutDidChangeNotification);
    DPLDistributedNotificationRemoveObserver(self, DPLShortcutWillEditNotification);
    DPLDistributedNotificationRemoveObserver(self, DPLShortcutDidEditNotification);
}

- (void)keyboardShortcutsDidChange:(nullable NSNotification *)notification
{
    NSLog(@"Keyboard shortcuts were changed: %@", notification);
    
    [self refreshShortcuts];
}

- (void)keyboardShortcutsWillEdit:(nullable NSNotification *)notification
{
    auto monitor = SRGlobalShortcutMonitor.sharedMonitor;
    [monitor pause];
}


- (void)keyboardShortcutsDidEdit:(nullable NSNotification *)notification
{
    auto monitor = SRGlobalShortcutMonitor.sharedMonitor;
    [monitor resume];
}

- (void)startMonitoring
{
    [self stopMonitoring];
    
    [self refreshShortcuts];
}

- (void)stopMonitoring
{
    auto monitor = SRGlobalShortcutMonitor.sharedMonitor;
    [monitor removeAllActions];
}

#pragma mark - Shortcut Registration

- (void)refreshShortcuts
{
    auto delegate = self.delegate;
    [self registerIncreaseShortcut:[delegate keyboardShortcutForIncreaseResolution]];
    [self registerDecreaseShortcut:[delegate keyboardShortcutForDecreaseResolution]];
}

- (void)registerIncreaseShortcut:(nullable SRShortcut *)increaseShortcut
{
    auto monitor = SRGlobalShortcutMonitor.sharedMonitor;
    auto sender = self;
    auto delegate = sender.delegate;
    
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
    auto increaseAction = [SRShortcutAction shortcutActionWithShortcut:increaseShortcut actionHandler:^BOOL(SRShortcutAction *action) {
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
    auto monitor = SRGlobalShortcutMonitor.sharedMonitor;
    auto sender = self;
    auto delegate = sender.delegate;
    
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
    auto decreaseAction = [SRShortcutAction shortcutActionWithShortcut:decreaseShortcut actionHandler:^BOOL(SRShortcutAction *action) {
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
