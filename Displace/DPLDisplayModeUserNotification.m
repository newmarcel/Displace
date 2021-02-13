//
//  DPLDisplayModeUserNotification.m
//  Displace
//
//  Created by Marcel Dierkes on 13.02.21.
//

#import "DPLDisplayModeUserNotification.h"
#import "DPLDefines.h"

NSString * const DPLDisplayModeUserNotificationIdentifier = @"DPLDisplayModeChangeIdentifier";

@interface DPLDisplayModeUserNotification ()
@property (nonatomic, readwrite) DPLDisplayModeChangeType changeType;
@end

@implementation DPLDisplayModeUserNotification

- (instancetype)init
{
    return [self initWithChangeType:DPLDisplayModeChangeTypeIncrease subtitle:nil];
}

- (instancetype)initWithChangeType:(DPLDisplayModeChangeType)changeType subtitle:(nullable NSString *)subtitle
{
    self = [super init];
    if(self)
    {
        self.identifier = DPLDisplayModeUserNotificationIdentifier;
        
        self.changeType = changeType;
        switch(changeType)
        {
            case DPLDisplayModeChangeTypeIncrease:
                self.title = @"Increased Resolution";
                break;
            case DPLDisplayModeChangeTypeDecrease:
                self.title = @"Decreased Resolution";
                break;
        }
        
        self.subtitle = subtitle;
    }
    return self;
}

@end
