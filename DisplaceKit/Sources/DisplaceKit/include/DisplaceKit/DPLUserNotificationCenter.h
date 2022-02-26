//
//  DPLUserNotificationCenter.h
//  Displace
//
//  Created by Marcel Dierkes on 13.02.21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DPLUserNotification;

/// Represents the current authorization status
/// for posting user notifications.
typedef NS_ENUM(NSUInteger, DPLUserNotificationAuthorizationStatus)
{
    /// The user has not been prompted for confirming the
    /// user notification authorization status.
    DPLUserNotificationAuthorizationStatusUndetermined = 0,
    
    /// The user has granted authorization for posting
    /// user notifications.
    DPLUserNotificationAuthorizationStatusGranted,
    
    /// The user denied authorization for posting user
    /// notifications.
    DPLUserNotificationAuthorizationStatusDenied,
};

typedef void(^DPLUserNotificationsAuthorizationCompletion)(DPLUserNotificationAuthorizationStatus, NSError *_Nullable);

/// Manages authorization and posting of user notifications.
@interface DPLUserNotificationCenter : NSObject

/// The primary user notification center.
/// @note Prefer using this object instead of creating new instances.
@property (class, nonatomic, readonly) DPLUserNotificationCenter *sharedCenter;

/// Retrieves the current user notification authorization status.
/// @param completion A completion handler with the user's current
///                   authorization status; returns on the main queue
- (void)getAuthorizationStatusWithCompletion:(void(^)(DPLUserNotificationAuthorizationStatus))completion;

/// Requests authorization for posting user notifications.
/// @param completion An optional completion handler with the user's
///                   authorization status; returns on the main queue
- (void)requestAuthorizationWithCompletion:(nullable DPLUserNotificationsAuthorizationCompletion)completion;

/// A convenience method to request authorization for posting user
/// notifications when the user's authorization status is
/// `KYAUserNotificationAuthorizationStatusUndetermined`.
- (void)requestAuthorizationIfUndetermined;

/// Posts a user notification if the user has granted authorization.
/// @param notification A user notification
- (void)postNotification:(__kindof DPLUserNotification *)notification;

/// Removes all previously delivered user notifications from the
/// notification center.
- (void)clearAllDeliveredNotifications;

@end

/// A generic user notification object usable for creating
/// custom dedicated user notification subclasses.
@interface DPLUserNotification : NSObject

/// A unique notification identifier, used for grouping purposes.
@property (copy, nonatomic) NSString *identifier;


/// A short reason description.
/// @note Use the custom `-setLocalizedTitleWithKey:arguments:`
///       instead for setting this property.
@property (copy, nonatomic, nullable) NSString *title;

/// A short secondary reason description.
/// @note Use the custom `-setLocalizedSubtitleWithKey:arguments:`
///       instead for setting this property.
@property (copy, nonatomic, nullable) NSString *subtitle;

/// The user notification message.
/// @note Use the custom `-setLocalizedBodyTextWithKey:arguments:`
///       instead for setting this property.
@property (copy, nonatomic, nullable) NSString *bodyText;

/// Arbitrary custom information related to the user notification.
@property (copy, nonatomic, nullable) NSDictionary *userInfo;


/// Sets the `title` value with a localization-aware string and arguments.
/// @param key A localized string key
/// @param arguments Optional localized string arguments
- (void)setLocalizedTitleWithKey:(NSString *)key
                       arguments:(nullable NSArray *)arguments;

/// Sets the `subtitle` value with a localization-aware string and arguments.
/// @param key A localized string key
/// @param arguments Optional localized string arguments
- (void)setLocalizedSubtitleWithKey:(NSString *)key
                          arguments:(nullable NSArray *)arguments;

/// Sets the `bodyText` value with a localization-aware string and arguments.
/// @param key A localized string key
/// @param arguments Optional localized string arguments
- (void)setLocalizedBodyTextWithKey:(NSString *)key
                          arguments:(nullable NSArray *)arguments;

@end

NS_ASSUME_NONNULL_END
