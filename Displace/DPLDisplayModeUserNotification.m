//
//  DPLDisplayModeUserNotification.m
//  Displace
//
//  Created by Marcel Dierkes on 13.02.21.
//

#import "DPLDisplayModeUserNotification.h"
#import <DisplaceCommon/DisplaceCommon.h>

NSString * const DPLDisplayModeUserNotificationIdentifier = @"DPLDisplayModeChangeIdentifier";

@interface DPLDisplayModeUserNotification ()
@property (nonatomic, getter=isIncreasing, readwrite) BOOL increasing;
@end

@implementation DPLDisplayModeUserNotification

- (instancetype)initWithDisplayName:(NSString *)displayName displayModeName:(NSString *)displayModeName increasing:(BOOL)increasing
{
    NSParameterAssert(displayName);
    NSParameterAssert(displayModeName);
    
    self = [super init];
    if(self)
    {
        self.identifier = DPLDisplayModeUserNotificationIdentifier;
        
        self.increasing = increasing;
        NSString *localizedSubtitleKey;
        if(increasing == YES)
        {
            localizedSubtitleKey = @"Increased Resolution to %@";
        }
        else
        {
            localizedSubtitleKey = @"Decreased Resolution to %@";
        }
        
        self.title = displayName;
        [self setLocalizedSubtitleWithKey:localizedSubtitleKey arguments:@[displayModeName]];
    }
    return self;
}

@end
