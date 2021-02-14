//
//  DPLPreferences.h
//  Displace
//
//  Created by Marcel Dierkes on 23.12.20.
//

#import <Foundation/Foundation.h>
#import <DisplaceKit/DPLDefaultsProvider.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const DPLLaunchAtLoginEnabledDefaultsKey;
FOUNDATION_EXPORT NSString * const DPLNonRetinaDisplayModesEnabledDefaultsKey;
FOUNDATION_EXPORT NSString * const DPLIncreaseResolutionShortcutDefaultsKey;
FOUNDATION_EXPORT NSString * const DPLDecreaseResolutionShortcutDefaultsKey;

@class SRShortcut;

@interface DPLPreferences : NSObject
@property (class, nonatomic, readonly) DPLPreferences *sharedPreferences;
@property (nonatomic, readonly) id<DPLDefaultsProvider> defaults;

@property (nonatomic, getter=isLaunchAtLoginEnabled) BOOL launchAtLoginEnabled;
@property (nonatomic, getter=isNonRetinaDisplayModesEnabled) BOOL nonRetinaDisplayModesEnabled;

@property (nonatomic, nullable) SRShortcut *increaseResolutionShortcut;
@property (nonatomic, nullable) SRShortcut *decreaseResolutionShortcut;

- (instancetype)init;
- (instancetype)initWithDefaultsProvider:(id<DPLDefaultsProvider>)defaults NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
