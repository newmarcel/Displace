//
//  NSURL+DPLUserNotificationCenter.h
//  DisplaceKit
//
//  Created by Marcel Dierkes on 20.02.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (DPLUserNotificationCenter)
@property (class, nonatomic, readonly) NSURL *dpl_notificationPreferencesURL;
@end

NS_ASSUME_NONNULL_END
