//
//  DPLShortcutMonitor.mm
//  Displace
//
//  Created by Marcel Dierkes on 02.01.21.
//

#import "DPLShortcutMonitor.h"
#import <ShortcutRecorder/ShortcutRecorder.h>

@interface DPLShortcutMonitor ()
@end

@implementation DPLShortcutMonitor

- (instancetype)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (void)startMonitoring
{
    [self stopMonitoring];
    
    auto monitor = SRGlobalShortcutMonitor.sharedMonitor;
    auto delegate = self.delegate;
    auto sender = self;
    
    auto increaseShortcut = self.increaseResolutionShortcut;
    auto increaseAction = [SRShortcutAction shortcutActionWithShortcut:increaseShortcut actionHandler:^BOOL(SRShortcutAction *action) {
        if([delegate respondsToSelector:@selector(shortcutMonitorShouldIncreaseResolution:)])
        {
            [delegate shortcutMonitorShouldIncreaseResolution:sender];
        }
        return YES;
    }];
    [monitor addAction:increaseAction forKeyEvent:SRKeyEventTypeUp];
    
    auto decreaseShortcut = self.decreaseResolutionShortcut;
    auto decreaseAction = [SRShortcutAction shortcutActionWithShortcut:decreaseShortcut actionHandler:^BOOL(SRShortcutAction *action) {
        if([delegate respondsToSelector:@selector(shortcutMonitorShouldDecreaseResolution:)])
        {
            [delegate shortcutMonitorShouldDecreaseResolution:sender];
        }
        return YES;
    }];
    [monitor addAction:decreaseAction forKeyEvent:SRKeyEventTypeUp];
}

- (void)stopMonitoring
{
    auto monitor = SRGlobalShortcutMonitor.sharedMonitor;
    [monitor removeAllActions];
}

@end
