//
//  DPLNotifications.m
//  DisplaceKit
//
//  Created by Marcel Dierkes on 09.01.21.
//

#import "DPLDistributedNotification.h"

const NSNotificationName DPLShortcutDidChangeNotification = @"DPLShortcutDidChangeNotification";
const NSNotificationName DPLShortcutWillEditNotification = @"DPLShortcutWillEditNotification";
const NSNotificationName DPLShortcutDidEditNotification = @"DPLShortcutDidEditNotification";

void DPLDistributedNotificationPostNotification(NSNotificationName notification)
{
    NSCParameterAssert(notification);
    
    auto center = NSDistributedNotificationCenter.defaultCenter;
    [center postNotificationName:notification
                          object:nil userInfo:nil
              deliverImmediately:YES];
}

void DPLDistributedNotificationAddObserver(id observer, SEL selector, NSNotificationName notification)
{
    NSCParameterAssert(observer);
    NSCParameterAssert(selector);
    NSCParameterAssert(notification);
    
    auto center = NSDistributedNotificationCenter.defaultCenter;
    [center addObserver:observer selector:selector name:notification object:nil];
}

void DPLDistributedNotificationRemoveObserver(id observer, NSNotificationName notification)
{
    NSCParameterAssert(observer);
    NSCParameterAssert(notification);
    
    auto center = NSDistributedNotificationCenter.defaultCenter;
    [center removeObserver:observer name:notification object:nil];
}
