//
//  DPLDisplayMode.mm
//  Displace
//
//  Created by Marcel Dierkes on 26.12.20.
//

#import <DisplaceKit/DPLDisplayMode.h>
#import <DisplaceKit/DPLPreferences.h>
#import "../DPLDefines.h"

@interface DPLDisplayMode ()
@property (nonatomic, readwrite) int32_t displayModeID;
@property (nonatomic, readwrite) NSInteger width;
@property (nonatomic, readwrite) NSInteger height;
@property (nonatomic, readwrite) double refreshRate;
@property (nonatomic, getter=isNativeResolution, readwrite) BOOL nativeResolution;
@property (nonatomic, getter=isRetinaResolution, readwrite) BOOL retinaResolution;
@property (nonatomic, readwrite) CGDisplayModeRef reference;
@end

@implementation DPLDisplayMode

- (instancetype)initWithDisplayModeID:(int32_t)displayModeID width:(NSInteger)width height:(NSInteger)height refreshRate:(double)refreshRate nativeResolution:(BOOL)nativeResolution retinaResolution:(BOOL)retinaResolution reference:(CGDisplayModeRef)reference
{
    NSParameterAssert(reference);
    
    self = [super init];
    if(self)
    {
        self.displayModeID = displayModeID;
        self.width = width;
        self.height = height;
        self.refreshRate = refreshRate;
        self.nativeResolution = nativeResolution;
        self.retinaResolution = retinaResolution;
        self.reference = reference;
        
        CGDisplayModeRetain(reference);
    }
    return self;
}

- (void)dealloc
{
    CGDisplayModeRelease(self.reference);
}

- (instancetype)initWithDisplayModeReference:(CGDisplayModeRef)reference
{
    NSParameterAssert(reference);
    
    int32_t displayModeID = CGDisplayModeGetIODisplayModeID(reference);
    size_t width = CGDisplayModeGetWidth(reference);
    size_t height = CGDisplayModeGetHeight(reference);
    double refreshRate = CGDisplayModeGetRefreshRate(reference);
    
    uint32_t IOFlags = CGDisplayModeGetIOFlags(reference);
    BOOL isNativeResolution = (IOFlags & kDisplayModeNativeFlag);
    BOOL isRetinaResolution = width != CGDisplayModeGetPixelWidth(reference);
    
    return [self initWithDisplayModeID:displayModeID 
                                 width:(NSInteger)width
                                height:(NSInteger)height
                           refreshRate:refreshRate
                      nativeResolution:isNativeResolution
                      retinaResolution:isRetinaResolution
                             reference:reference];
}

- (BOOL)isProMotionRefreshRate
{
    return round(self.refreshRate) == 120.0f;
}

#pragma mark - Localized Name

- (NSString *)localizedName
{
    Auto string = (NSMutableString *)[self.localizedNameWithoutAttributes mutableCopy];
    if([DPLPreferences.sharedPreferences isNonRetinaDisplayModesEnabled] == YES)
    {
        Auto retinaAttributeTitle = NSLocalizedString(@"(Retina)", @"(Retina)");
        if([self isRetinaResolution]) { [string appendFormat:@" %@", retinaAttributeTitle]; }
    }
    
    Auto nativeAttributeTitle = NSLocalizedString(@"(Native)", @"(Native)");
    if([self isNativeResolution]) { [string appendFormat:@" %@", nativeAttributeTitle]; }
    
    NSString *refreshRateTitle;
    if([self isProMotionRefreshRate])
    {
        refreshRateTitle = NSLocalizedString(@"(ProMotion)", @"(ProMotion)");
    }
    else if(self.refreshRate > 0.0f)
    {
        refreshRateTitle = [NSString stringWithFormat:NSLocalizedString(@"(%.2lf Hertz)", @"(%.2lf Hertz)"), self.refreshRate];
    }
    
    if(refreshRateTitle != nil)
    {
        [string appendFormat:@" %@", refreshRateTitle];
    }

    return [string copy];
}

- (NSString *)localizedNameWithoutAttributes
{
    return [NSString localizedStringWithFormat:
            NSLocalizedString(@"%@ × %@", @"%@ × %@"),
            @(self.width),
            @(self.height)
            ];
}

#pragma mark - Description

- (NSString *)description
{
    Auto string = [[NSMutableString alloc] initWithString:super.description];
    [string appendFormat:@" %@", @(self.displayModeID)];
    [string appendFormat:@" [%@ × %@]", @(self.width), @(self.height)];
    if([self isRetinaResolution]) { [string appendString:@" @2x"]; }
    if([self isNativeResolution]) { [string appendString:@" (native)"]; }
    
    return string;
}

- (NSString *)debugDescription
{
    return ((__bridge_transfer NSString *)CFCopyDescription(self.reference));
}

#pragma mark - Equatable

- (BOOL)isEqualToDisplayMode:(DPLDisplayMode *)displayMode
{
    NSParameterAssert(displayMode);
    
    return self.displayModeID == displayMode.displayModeID
        && self.width == displayMode.width
        && self.height == displayMode.height
        && self.refreshRate == displayMode.refreshRate;
}

- (BOOL)isEqual:(id)object
{
    Auto other = (DPLDisplayMode *)object;
    if(other == nil) { return NO; }
    if([other isKindOfClass:[self class]] == NO) { return NO; }
    
    return [self isEqualToDisplayMode:other];
}

#pragma mark - Hashable

- (NSUInteger)hash
{
    return self.displayModeID
        ^ self.width
        ^ self.height;
}

@end
