//
//  DPLShortcutMonitor.h
//  Displace
//
//  Created by Marcel Dierkes on 02.01.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DPLShortcutMonitorDelegate;
@class SRShortcut;

@interface DPLShortcutMonitor : NSObject
@property (weak, nonatomic, nullable) id<DPLShortcutMonitorDelegate> delegate;

- (void)startMonitoring;
- (void)stopMonitoring;

@end

@protocol DPLShortcutMonitorDelegate <NSObject>
@optional
- (void)shortcutMonitorShouldIncreaseResolution:(DPLShortcutMonitor *)monitor;
- (void)shortcutMonitorShouldDecreaseResolution:(DPLShortcutMonitor *)monitor;

- (nullable SRShortcut *)keyboardShortcutForIncreaseResolution;
- (nullable SRShortcut *)keyboardShortcutForDecreaseResolution;

@end

NS_ASSUME_NONNULL_END
