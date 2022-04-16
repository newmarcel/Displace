//
//  NSWorkspace+DPLUserNotificationCenter.h
//  DisplaceUserNotifications
//
//  Created by Marcel Dierkes on 20.02.21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DPLOpenNotificationsCompletionHandler)(NSRunningApplication *_Nullable,
                                                     NSError *_Nullable);

@interface NSWorkspace (DPLUserNotificationCenter)

/// Opens the notifications pane in System Preferences.
/// @param completionHandler An optional completion handler, called on a private queue
- (void)dpl_openNotificationPreferencesWithCompletionHandler:(nullable DPLOpenNotificationsCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
