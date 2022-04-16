//
//  DPLDisplayModeUserNotification.h
//  Displace
//
//  Created by Marcel Dierkes on 13.02.21.
//

#import <Foundation/Foundation.h>
#import <DisplaceUserNotifications/DisplaceUserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const DPLDisplayModeUserNotificationIdentifier;

@interface DPLDisplayModeUserNotification : DPLUserNotification
@property (nonatomic, getter=isIncreasing, readonly) BOOL increasing;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithDisplayName:(NSString *)displayName
                    displayModeName:(NSString *)displayModeName
                         increasing:(BOOL)increasing NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
