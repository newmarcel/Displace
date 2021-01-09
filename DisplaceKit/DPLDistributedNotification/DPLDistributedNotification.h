//
//  DPLDistributedNotification.h
//  DisplaceKit
//
//  Created by Marcel Dierkes on 09.01.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// A distributed notification that gets fired when a
/// keyboard shortcut has been changed.
FOUNDATION_EXPORT const NSNotificationName DPLShortcutDidChangeNotification;

FOUNDATION_EXPORT const NSNotificationName DPLShortcutWillEditNotification;
FOUNDATION_EXPORT const NSNotificationName DPLShortcutDidEditNotification;

FOUNDATION_EXPORT void DPLDistributedNotificationPostNotification(NSNotificationName);

FOUNDATION_EXPORT void DPLDistributedNotificationAddObserver(id observer, SEL selector, NSNotificationName);
FOUNDATION_EXPORT void DPLDistributedNotificationRemoveObserver(id observer, NSNotificationName);


NS_ASSUME_NONNULL_END
