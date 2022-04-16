//
//  DPLNotificationCenter.m
//  DisplaceApplicationSupport
//
//  Created by Marcel Dierkes on 09.01.21.
//

#import <DisplaceApplicationSupport/DPLNotificationCenter.h>
#import "DPLDefines.h"

const DPLNotificationName DPLShortcutDidChangeNotification = @"DPLShortcutDidChangeNotification";
const DPLNotificationName DPLShortcutWillEditNotification = @"DPLShortcutWillEditNotification";
const DPLNotificationName DPLShortcutDidEditNotification = @"DPLShortcutDidEditNotification";

@interface DPLNotificationCenter ()
@property (nonatomic) NSDistributedNotificationCenter *distributedCenter;
@end

@implementation DPLNotificationCenter

+ (instancetype)defaultCenter
{
    static dispatch_once_t once;
    static DPLNotificationCenter *defaultCenter;
    dispatch_once(&once, ^{
        defaultCenter = [self new];
    });
    return defaultCenter;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.distributedCenter = NSDistributedNotificationCenter.defaultCenter;
    }
    return self;
}

- (void)postNotification:(DPLNotificationName)notification
{
    NSParameterAssert(notification);
    
    [self.distributedCenter postNotificationName:notification
                                          object:nil userInfo:nil
                              deliverImmediately:YES];
}

- (void)addObserver:(id)observer selector:(SEL)selector name:(DPLNotificationName)notificationName
{
    NSParameterAssert(observer);
    NSParameterAssert(selector);
    NSParameterAssert(notificationName);
    
    [self.distributedCenter addObserver:observer
                               selector:selector
                                   name:notificationName
                                 object:nil];
}

- (void)removeObserver:(id)observer name:(DPLNotificationName)notificationName
{
    NSParameterAssert(observer);
    NSParameterAssert(notificationName);
    
    [self.distributedCenter removeObserver:observer name:notificationName object:nil];
}

@end
