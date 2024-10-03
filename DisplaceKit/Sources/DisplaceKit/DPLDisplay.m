//
//  DPLDisplay.m
//  DisplaceKit
//
//  Created by Marcel Dierkes on 26.12.20.
//

#import <DisplaceKit/DPLDisplay.h>
#import <DisplaceKit/DPLDisplayMode.h>
#import <DisplaceKit/DPLGraphicsDevice.h>
#import <DisplaceApplicationSupport/DPLPreferences.h>
#import <DisplaceCommon/DisplaceCommon.h>
#import "DisplaceKitLocalizedStrings.h"
#import "DPLDisplayManager/DPLDisplayManager.h"
#import "DPLDisplayModeFilter/DPLDisplayModeFilter.h"

NS_INLINE NSString *DPLBoolToString(BOOL value)
{
    return (value == YES) ? @"YES" : @"NO";
}

@interface DPLDisplay ()
@property (nonatomic, readwrite) CGDirectDisplayID displayID;
@property (nonatomic, readwrite) NSInteger width;
@property (nonatomic, readwrite) NSInteger height;
@property (nonatomic, getter=isMain, readwrite) BOOL main;
@property (nonatomic, getter=isOnline, readwrite) BOOL online;
@property (nonatomic, getter=isBuiltIn, readwrite) BOOL builtIn;
@property (nonatomic, readwrite) BOOL hasSafeArea;
@property (nonatomic, readwrite) NSArray<DPLDisplayMode *> *displayModes;
@property (nonatomic, readwrite) DPLGraphicsDevice *graphicsDevice;
@property (copy, nonatomic, readwrite) NSString *localizedName;
@end

@implementation DPLDisplay

+ (NSArray<DPLDisplay *> *)allDisplays
{
    Auto manager = DPLDisplayManager.sharedManager;
    return manager.allDisplays;
}

+ (DPLDisplay *)displayWithDisplayID:(CGDirectDisplayID)displayID
{
    Auto manager = DPLDisplayManager.sharedManager;
    return [manager displayWithDisplayID:displayID];
}

#pragma mark - Life Cycle

- (instancetype)initWithDisplayID:(CGDirectDisplayID)displayID width:(NSInteger)width height:(NSInteger)height main:(BOOL)main online:(BOOL)online builtIn:(BOOL)builtIn displayModes:(NSArray<DPLDisplayMode *> *)displayModes currentDisplayMode:(DPLDisplayMode *)currentDisplayMode graphicsDevice:(DPLGraphicsDevice *)graphicsDevice
{
    NSParameterAssert(displayModes);
    NSParameterAssert(graphicsDevice);
    
    self = [super init];
    if(self)
    {
        self.displayID = displayID;
        self.width = width;
        self.height = height;
        self.main = main;
        self.online = online;
        self.builtIn = builtIn;
        self.displayModes = displayModes;
        self.currentDisplayMode = currentDisplayMode;
        self.graphicsDevice = graphicsDevice;
    }
    return self;
}

- (NSArray<DPLDisplayMode *> *)displayModes
{
    if(_displayModes == nil) { return @[]; }
    
    AutoVar filteredModes = (NSMutableArray<DPLDisplayMode *> *)[_displayModes mutableCopy];
    
    Auto settings = DPLPreferences.sharedPreferences;
    if([settings isNonRetinaDisplayModesEnabled] == NO)
    {
        Auto backup = (NSMutableArray<DPLDisplayMode *> *)[filteredModes mutableCopy];
        
        Auto predicate = [NSPredicate predicateWithFormat:@"%K == YES", @"retinaResolution"];
        [filteredModes filterUsingPredicate:predicate];

        // Reset if no display modes are left
        if(filteredModes.count == 0)
        {
            filteredModes = backup; // reset!
        }
    }
    
    if([settings isHideNonProMotionRefreshRatesEnabled] == YES)
    {
        Auto backup = (NSMutableArray<DPLDisplayMode *> *)[filteredModes mutableCopy];
        
        Auto predicate = [NSPredicate predicateWithFormat:@"%K == YES", @"proMotionRefreshRate"];
        [filteredModes filterUsingPredicate:predicate];

        // Reset if no display modes are left
        if(filteredModes.count == 0)
        {
            filteredModes = backup; // reset!
        }
    }
    
    return [filteredModes copy];
}

- (DPLDisplayMode *)nextDisplayMode
{
    return DPLDisplayModeGetHigherDisplayMode(self.displayModes, self.currentDisplayMode);
}

- (DPLDisplayMode *)previousDisplayMode
{
    return DPLDisplayModeGetLowerDisplayMode(self.displayModes, self.currentDisplayMode);
}

- (BOOL)isSidecar
{
    return [self.localizedName containsString:@"Sidecar"];
}

#pragma mark - Apply Current Display Mode

- (void)applyCurrentDisplayMode
{
    Auto displayMode = self.currentDisplayMode;
    if(displayMode == nil) { return; }
    
    CGDisplayConfigRef config;
    CGBeginDisplayConfiguration(&config);
    
    CGDisplaySetDisplayMode(self.displayID, displayMode.reference, nil);
    
#if DEBUG
    CGConfigureOption option = kCGConfigureForSession;
#else
    CGConfigureOption option = kCGConfigurePermanently;
#endif
    
    Auto result = CGCompleteDisplayConfiguration(config, option);
    if(result != kCGErrorSuccess)
    {
        DPLLog(@"Failed to apply display mode change. Revert.");
        CGRestorePermanentDisplayConfiguration();
        return;
    }
}

#pragma mark - Localized Name

- (NSString *)localizedName
{
    if(_localizedName != nil) { return _localizedName; }
    
    if([self isBuiltIn])
    {
        return DPL_L10N_INTERNAL_DISPLAY;
    }
    else
    {
        return DPL_L10N_EXTERNAL_DISPLAY;
    }
}

#pragma mark - Description

- (NSString *)description
{
    Auto string = [[NSMutableString alloc] initWithString:super.description];
    [string appendFormat:@"\n  ID: %@", @(self.displayID)];
    [string appendFormat:@"\n  Is Main: %@", DPLBoolToString([self isMain])];
    [string appendFormat:@"\n  Is Online: %@", DPLBoolToString([self isOnline])];
    [string appendFormat:@"\n  Is Built-In: %@", DPLBoolToString([self isBuiltIn])];
    [string appendFormat:@"\n  Is Sidecar: %@", DPLBoolToString([self isSidecar])];
    [string appendFormat:@"\n  Has Safe Area: %@", DPLBoolToString([self hasSafeArea])];
    [string appendFormat:@"\n  Size: %@ × %@", @(self.width), @(self.height)];
    [string appendFormat:@"\n  Modes:"];
    for(DPLDisplayMode *mode in self.displayModes)
    {
        [string appendFormat:@"\n   - %@", mode];
        if([mode isEqual:self.currentDisplayMode])
        {
            [string appendString:@" (current)"];
        }
    }
    [string appendFormat:@"\n  Graphics Device:\n%@", self.graphicsDevice];
    
    return string;
}

- (NSString *)debugDescription
{
    Auto string = [[NSMutableString alloc] initWithString:super.description];
    [string appendFormat:@"\n  ID: %@", @(self.displayID)];
    [string appendFormat:@"\n  Is Main: %@", DPLBoolToString([self isMain])];
    [string appendFormat:@"\n  Is Online: %@", DPLBoolToString([self isOnline])];
    [string appendFormat:@"\n  Is Built-In: %@", DPLBoolToString([self isBuiltIn])];
    [string appendFormat:@"\n  Is Sidecar: %@", DPLBoolToString([self isSidecar])];
    [string appendFormat:@"\n  Has Safe Area: %@", DPLBoolToString([self hasSafeArea])];
    [string appendFormat:@"\n  Size: %@ × %@", @(self.width), @(self.height)];
    [string appendFormat:@"\n  Modes:"];
    for(DPLDisplayMode *mode in self.displayModes)
    {
        [string appendFormat:@"\n   - %@", mode.debugDescription];
    }
    [string appendFormat:@"\n  Graphics Device:\n%@", self.graphicsDevice];
    
    return string;
}

#pragma mark - Equatable

- (BOOL)isEqualToDisplay:(DPLDisplay *)display
{
    NSParameterAssert(display);
    
    return self.displayID == display.displayID
        && self.width == display.width
        && self.height == display.height;
}

- (BOOL)isEqual:(id)object
{
    Auto other = (DPLDisplay *)object;
    if(other == nil) { return NO; }
    if([other isKindOfClass:[self class]] == NO) { return NO; }
    
    return [self isEqualToDisplay:other];
}

#pragma mark - Hashable

- (NSUInteger)hash
{
    return self.displayID
        ^ self.width
        ^ self.height;
}

@end
