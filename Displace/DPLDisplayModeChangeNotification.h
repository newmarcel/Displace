//
//  DPLDisplayModeUserNotification.h
//  Displace
//
//  Created by Marcel Dierkes on 13.02.21.
//

#import <Foundation/Foundation.h>
#import "DPLUserNotificationsController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_CLOSED_ENUM(NSUInteger, DPLDisplayModeChangeType)
{
    DPLDisplayModeChangeTypeIncrease = 0,
    DPLDisplayModeChangeTypeDecrease
};

@interface DPLDisplayModeChangeNotification : DPLUserNotification
@property (nonatomic, readonly) DPLDisplayModeChangeType changeType;

- (instancetype)initWithChangeType:(DPLDisplayModeChangeType)changeType NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
