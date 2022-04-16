//
//  DPLNotificationCenter.h
//  DisplaceApplicationSupport
//
//  Created by Marcel Dierkes on 09.01.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSNotificationName DPLNotificationName NS_EXTENSIBLE_STRING_ENUM;

/// A distributed notification that gets fired when a
/// keyboard shortcut has been changed.
FOUNDATION_EXPORT const DPLNotificationName DPLShortcutDidChangeNotification;

/// A distributed notification that gets fired when keyboard shortcuts
/// are being edited.
/// It is recommended to pause global shortcut recognition.
FOUNDATION_EXPORT const DPLNotificationName DPLShortcutWillEditNotification;

/// A distributed notification that gets fired when keyboard shortcuts
/// have finished being edited.
/// It is recommended to resume global shortcut recognition.
FOUNDATION_EXPORT const DPLNotificationName DPLShortcutDidEditNotification;

@interface DPLNotificationCenter : NSObject
@property (class, nonatomic, readonly) DPLNotificationCenter *defaultCenter;

- (void)postNotification:(DPLNotificationName)notification;

- (void)addObserver:(id)observer selector:(SEL)selector name:(DPLNotificationName)notificationName;
- (void)removeObserver:(id)observer name:(DPLNotificationName)notificationName;

@end

NS_ASSUME_NONNULL_END
