//
//  DPLUserNotificationCenter.h
//  Displace
//
//  Created by Marcel Dierkes on 13.02.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DPLUserNotification;

typedef NS_ENUM(NSUInteger, DPLUserNotificationAuthorizationStatus) {
    DPLUserNotificationAuthorizationStatusUndetermined = 0,
    DPLUserNotificationAuthorizationStatusGranted,
    DPLUserNotificationAuthorizationStatusDenied,
};

typedef void(^DPLUserNotificationsAuthorizationCompletion)(DPLUserNotificationAuthorizationStatus, NSError *_Nullable);

@interface DPLUserNotificationCenter : NSObject
@property (class, nonatomic, readonly) DPLUserNotificationCenter *sharedCenter;

- (void)getAuthorizationStatusWithCompletion:(void(NS_NOESCAPE ^)(DPLUserNotificationAuthorizationStatus))completion;
- (void)requestAuthorizationWithCompletion:(nullable NS_NOESCAPE DPLUserNotificationsAuthorizationCompletion)completion;
- (void)requestAuthorizationIfUndetermined;

- (void)postNotification:(__kindof DPLUserNotification *)notification;
- (void)clearAllDeliveredNotifications;

@end

@interface DPLUserNotification : NSObject
@property (copy, nonatomic) NSString *identifier;
@property (copy, nonatomic, nullable) NSString *title; // use the localized setter instead
@property (copy, nonatomic, nullable) NSString *subtitle; // use the localized setter instead
@property (copy, nonatomic, nullable) NSString *bodyText;
@property (copy, nonatomic, nullable) NSDictionary *userInfo;

- (void)setLocalizedTitleWithKey:(NSString *)key arguments:(nullable NSArray *)arguments;
- (void)setLocalizedSubtitleWithKey:(NSString *)key arguments:(nullable NSArray *)arguments;

@end

NS_ASSUME_NONNULL_END
