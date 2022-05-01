//
//  DisplaceKitLocalizedStrings.h
//  DisplaceKit
//
//  Created by Marcel Dierkes on 01.05.22.
//

#import <Foundation/Foundation.h>

#define DPL_L10N_INTERNAL_DISPLAY NSLocalizedString(@"Internal Display", @"Internal Display")
#define DPL_L10N_EXTERNAL_DISPLAY NSLocalizedString(@"External Display", @"External Display")

#define DPL_L10N_RETINA_IN_PARENS NSLocalizedString(@"(Retina)", @"(Retina)")
#define DPL_L10N_NATIVE_IN_PARENS NSLocalizedString(@"(Native)", @"(Native)")
#define DPL_L10N_PROMOTION_IN_PARENS NSLocalizedString(@"(ProMotion)", @"(ProMotion)")

NS_INLINE NSString *DPLLocalizedRefreshRate(double refreshRate)
{
    return [NSString stringWithFormat:NSLocalizedString(@"(%.2lf Hertz)", @"(%.2lf Hertz)"),
            refreshRate];
}

NS_INLINE NSString *DPLLocalizedResolution(NSInteger width, NSInteger height)
{
    return [NSString localizedStringWithFormat:
            NSLocalizedString(@"%@ × %@", @"%@ × %@"),
            @(width),
            @(height)
            ];
}
