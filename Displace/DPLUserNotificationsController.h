//
//  DPLUserNotificationsController.h
//  Displace
//
//  Created by Marcel Dierkes on 13.02.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DPLUserNotification;

typedef NS_ENUM(NSUInteger, DPLUserNotificationsAuthorizationStatus) {
    DPLUserNotificationsAuthorizationStatusUndetermined = 0,
    DPLUserNotificationsAuthorizationStatusGranted,
    DPLUserNotificationsAuthorizationStatusDenied,
};

typedef void(^DPLUserNotificationsAuthorizationCompletion)(DPLUserNotificationsAuthorizationStatus, NSError *_Nullable);

@interface DPLUserNotificationsController : NSObject
@property (nonatomic, readonly) DPLUserNotificationsAuthorizationStatus authorizationStatus;

- (void)requestAuthorizationWithCompletion:(nullable DPLUserNotificationsAuthorizationCompletion)completion;

- (BOOL)postNotification:(__kindof DPLUserNotification *)notification;

- (void)clearAllDeliveredNotifications;

@end

@interface DPLUserNotification : NSObject
@property (copy, nonatomic) NSString *identifier;
@property (copy, nonatomic, nullable) NSString *title; // use [NSString localizedUserNotificationStringForKey…]
@property (copy, nonatomic, nullable) NSString *subtitle; // use [NSString localizedUserNotificationStringForKey…]
@property (copy, nonatomic, nullable) NSString *bodyText;
@property (copy, nonatomic, nullable) NSDictionary *userInfo;
@end

NS_ASSUME_NONNULL_END
