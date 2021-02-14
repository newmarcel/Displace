//
//  DPLDisplayModeUserNotification.h
//  Displace
//
//  Created by Marcel Dierkes on 13.02.21.
//

#import <Foundation/Foundation.h>
#import <DisplaceKit/DisplaceKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const DPLDisplayModeUserNotificationIdentifier;

typedef NS_CLOSED_ENUM(NSUInteger, DPLDisplayModeChangeType)
{
    DPLDisplayModeChangeTypeIncrease = 0,
    DPLDisplayModeChangeTypeDecrease
};

@interface DPLDisplayModeUserNotification : DPLUserNotification
@property (nonatomic, readonly) DPLDisplayModeChangeType changeType;

- (instancetype)initWithChangeType:(DPLDisplayModeChangeType)changeType
                          subtitle:(nullable NSString *)subtitle NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
