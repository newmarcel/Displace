//
//  DPLDisplayModeFilter.h
//  DisplaceKit
//
//  Created by Marcel Dierkes on 16.04.22.
//

#import <Foundation/Foundation.h>
#import <DisplaceKit/DPLDisplayMode.h>

NS_ASSUME_NONNULL_BEGIN

DPLDisplayMode *_Nullable
DPLDisplayModeGetHigherDisplayMode(NSArray<DPLDisplayMode *> *displayModes,
                                   DPLDisplayMode *_Nullable currentDisplayMode);

DPLDisplayMode *_Nullable
DPLDisplayModeGetLowerDisplayMode(NSArray<DPLDisplayMode *> *displayModes,
                                  DPLDisplayMode *_Nullable currentDisplayMode);

NS_ASSUME_NONNULL_END
