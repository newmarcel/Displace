//
//  DPLSettings.h
//  DisplaceApplicationSupport
//
//  Created by Marcel Dierkes on 23.12.20.
//

#import <Foundation/Foundation.h>
#import <DisplaceCommon/DPLExport.h>
#import <DisplaceApplicationSupport/DPLDefaultsProvider.h>

NS_ASSUME_NONNULL_BEGIN

DPL_EXPORT NSString * const DPLFirstLaunchFinishedKey;
DPL_EXPORT NSString * const DPLLaunchAtLoginEnabledDefaultsKey;
DPL_EXPORT NSString * const DPLNonRetinaDisplayModesEnabledDefaultsKey;
DPL_EXPORT NSString * const DPLIncreaseResolutionShortcutDefaultsKey;
DPL_EXPORT NSString * const DPLDecreaseResolutionShortcutDefaultsKey;
DPL_EXPORT NSString * const DPLHideNonProMotionRefreshRatesEnabledDefaultsKey;

@class SRShortcut;

@interface DPLSettings : NSObject
@property (class, nonatomic, readonly) DPLSettings *sharedSettings;
@property (nonatomic, readonly) id<DPLDefaultsProvider> defaults;

@property (nonatomic, getter=isFirstLaunchFinished) BOOL firstLaunchFinished;
@property (nonatomic, getter=isLaunchAtLoginEnabled) BOOL launchAtLoginEnabled;

@property (nonatomic, getter=isNonRetinaDisplayModesEnabled) BOOL nonRetinaDisplayModesEnabled;
@property (nonatomic, getter=isHideNonProMotionRefreshRatesEnabled) BOOL hideNonProMotionRefreshRatesEnabled;

@property (nonatomic, nullable) SRShortcut *increaseResolutionShortcut;
@property (nonatomic, nullable) SRShortcut *decreaseResolutionShortcut;

- (instancetype)init;
- (instancetype)initWithDefaultsProvider:(id<DPLDefaultsProvider>)defaults NS_DESIGNATED_INITIALIZER;

/// Performs the given block only when the app is launched for the first time
/// and marks the first launch as completed.
/// @param block A custom block
- (void)performBlockOnFirstLaunch:(void(NS_NOESCAPE ^)(void))block;

@end

NS_ASSUME_NONNULL_END
