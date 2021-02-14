//
//  DPLDisplay.m
//  Displace
//
//  Created by Marcel Dierkes on 26.12.20.
//

#import "DPLDisplay.h"
#import <Metal/Metal.h>
#import "DPLDefines.h"
#import "DPLDisplayMode.h"
#import "DPLGraphicsDevice.h"
#import "DPLPreferences.h"
#import "NSScreen+DPLDisplay.h"

static const NSUInteger DPLDisplayCountMax = 64u;

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
@property (nonatomic, readwrite) NSArray<DPLDisplayMode *> *displayModes;
@property (nonatomic, readwrite) DPLGraphicsDevice *graphicsDevice;
@property (copy, nonatomic, readwrite) NSString *localizedName;
@end

@implementation DPLDisplay

+ (NSArray<DPLDisplay *> *)allDisplays
{
    return [self allDisplaysUsingInformationFromScreens:NSScreen.screens];
}

+ (NSArray<DPLDisplay *> *)allDisplaysUsingInformationFromScreens:(NSArray<NSScreen *> *)screens
{
    CGDirectDisplayID displaysIDs[DPLDisplayCountMax];
    uint32_t numberOfDisplays = 0;
    CGError result = CGGetActiveDisplayList(DPLDisplayCountMax, displaysIDs, &numberOfDisplays);
    if(result != kCGErrorSuccess)
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Failed to get active display list."
                                     userInfo:nil];
        return @[];
    }

    Auto displays = [NSMutableArray<DPLDisplay *> new];
    for(NSUInteger i = 0; i < DPLDisplayCountMax; i++)
    {
        CGDirectDisplayID display = displaysIDs[i];
        if(display == kCGNullDirectDisplay || CGDisplayPixelsWide(display) == 0)
        {
            continue;
        }

        CGDirectDisplayID displayID = display;
        BOOL isMain = CGDisplayIsMain(display);
        BOOL isOnline = CGDisplayIsOnline(display);
        BOOL isBuiltIn = CGDisplayIsBuiltin(display);
        size_t width = CGDisplayPixelsWide(display);
        size_t height = CGDisplayPixelsHigh(display);
        
        id<MTLDevice> metalDevice = CGDirectDisplayCopyCurrentMetalDevice(displayID);
        Auto graphicsDevice = [[DPLGraphicsDevice alloc] initWithMetalDevice:metalDevice];
        
        Auto displayModes = [NSMutableArray<DPLDisplayMode *> new];
        Auto options = @{
            (__bridge NSString *)kCGDisplayShowDuplicateLowResolutionModes: (__bridge NSNumber *)kCFBooleanTrue
        };
        Auto modeList = CGDisplayCopyAllDisplayModes(display, (__bridge CFDictionaryRef)options);
        if(modeList == nil) { continue; }
        CFIndex modeListCount = CFArrayGetCount(modeList);
        
        Auto currentDisplayModeReference = CGDisplayCopyDisplayMode(display);
        DPLDisplayMode *currentDisplayMode;
        
        // https://stackoverflow.com/questions/1236498/how-to-get-the-display-name-with-the-display-id-in-mac-os-x
        for(CFIndex index = 0; index < modeListCount; index++)
        {
            CGDisplayModeRef mode = (CGDisplayModeRef)CFArrayGetValueAtIndex(modeList, index);
            if(CGDisplayModeIsUsableForDesktopGUI(mode) == false) { continue; }
            
            Auto displayMode = [[DPLDisplayMode alloc] initWithDisplayModeReference:mode];
            [displayModes addObject:displayMode];
            
            if(mode == currentDisplayModeReference)
            {
                currentDisplayMode = displayMode;
            }
        }
        CFRelease(modeList);
        CFRelease(currentDisplayModeReference);
        
        // Sort the display modes by width DESC
        Auto sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"width" ascending:NO];
        [displayModes sortUsingDescriptors:@[sortDescriptor]];
        
        Auto displayInstance = [[DPLDisplay alloc] initWithDisplayID:displayID
                                                               width:(NSInteger)width
                                                              height:(NSInteger)height
                                                                main:isMain
                                                              online:isOnline
                                                             builtIn:isBuiltIn
                                                        displayModes:[displayModes copy]
                                                  currentDisplayMode:currentDisplayMode
                                                      graphicsDevice:graphicsDevice];
        [displays addObject:displayInstance];
        
        // Enhance the display instance with NSScreen information
        for(NSScreen *screen in screens)
        {
            if(screen.dpl_displayID == displayID)
            {
                displayInstance.localizedName = screen.localizedName;
            }
        }
    }
    
    return [displays copy];
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
    
    if([DPLPreferences.sharedPreferences isNonRetinaDisplayModesEnabled] == YES)
    {
        return _displayModes;
    }
    else
    {
        Auto predicate = [NSPredicate predicateWithFormat:@"%K == YES", @"retinaResolution"];
        return [_displayModes filteredArrayUsingPredicate:predicate];
    }
}

- (DPLDisplayMode *)nextDisplayMode
{
    Auto currentDisplayMode = self.currentDisplayMode;
    if(currentDisplayMode == nil) { return nil; }
    
    Auto displayModes = self.displayModes;
    Auto currentIndex = [displayModes indexOfObject:currentDisplayMode];
    if(currentIndex == NSNotFound) { return nil; }
    
    Auto nextIndex = currentIndex - 1;
    if(nextIndex < 0 || nextIndex >= displayModes.count) { return nil; }
    
    return displayModes[nextIndex];
}

- (DPLDisplayMode *)previousDisplayMode
{
    Auto currentDisplayMode = self.currentDisplayMode;
    if(currentDisplayMode == nil) { return nil; }
    
    Auto displayModes = self.displayModes;
    Auto currentIndex = [displayModes indexOfObject:currentDisplayMode];
    if(currentIndex == NSNotFound) { return nil; }
    
    Auto previousIndex = currentIndex + 1;
    if(previousIndex < 0 || previousIndex >= displayModes.count) { return nil; }
    
    return displayModes[previousIndex];
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
        return NSLocalizedString(@"Internal Display", @"Internal Display");
    }
    else
    {
        return NSLocalizedString(@"External Display", @"External Display");
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
    return self.description;
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
