//
//  DPLPreferences.h
//  DisplaceApplicationSupport
//
//  Created by Marcel Dierkes on 23.12.20.
//

#import <Foundation/Foundation.h>
#import <DisplaceApplicationSupport/DPLDefaultsProvider.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const DPLFirstLaunchFinishedKey;
FOUNDATION_EXPORT NSString * const DPLLaunchAtLoginEnabledDefaultsKey;
FOUNDATION_EXPORT NSString * const DPLNonRetinaDisplayModesEnabledDefaultsKey;
FOUNDATION_EXPORT NSString * const DPLIncreaseResolutionShortcutDefaultsKey;
FOUNDATION_EXPORT NSString * const DPLDecreaseResolutionShortcutDefaultsKey;
FOUNDATION_EXPORT NSString * const DPLHideNonProMotionRefreshRatesEnabledDefaultsKey;

@class SRShortcut;

@interface DPLPreferences : NSObject
@property (class, nonatomic, readonly) DPLPreferences *sharedPreferences;
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
