//
//  DPLDisplayManager.m
//  DisplaceKit
//
//  Created by Marcel Dierkes on 21.03.21.
//

#import "DPLDisplayManager.h"
#import <DisplaceKit/DPLDisplay.h>
#import <DisplaceKit/DPLDisplayMode.h>
#import <DisplaceKit/NSScreen+DPLDisplay.h>
#import <DisplaceKit/DPLGraphicsDevice.h>
#import "../../DPLDefines.h"

static const NSUInteger DPLDisplayCountMax = 64u;

@interface DPLDisplay ()
@property (copy, nonatomic, readwrite) NSString *localizedName;
@end

@interface DPLDisplayManager ()
@property (nonatomic) NSArray<NSScreen *> *cachedScreens;
@end

@implementation DPLDisplayManager

+ (instancetype)sharedManager
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initWithCoreGraphicsDisplaysAndScreens:nil];
    });
    return sharedInstance;
}

- (instancetype)initWithCoreGraphicsDisplaysAndScreens:(NSArray<NSScreen *> *)screens
{
    self = [super init];
    if(self)
    {
        self.cachedScreens = screens;
    }
    return self;
}

- (NSArray<NSScreen *> *)screens
{
    return self.cachedScreens ?: NSScreen.screens;
}

#pragma mark - Accessors

- (NSArray<DPLDisplay *> *)allDisplays
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
        
        Auto duplicatePredicate = [NSPredicate predicateWithFormat:@"displayID == %@", @(display)];
        Auto duplicates = [displays filteredArrayUsingPredicate:duplicatePredicate];
        if(duplicates.count > 0)
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
        for(NSScreen *screen in self.screens)
        {
            if(screen.dpl_displayID == displayID)
            {
                displayInstance.localizedName = screen.localizedName;
            }
        }
    }
    
    return [displays copy];
}

- (DPLDisplay *)displayWithDisplayID:(CGDirectDisplayID)displayID
{
    return [self displayWithDisplayID:displayID
          usingInformationFromScreens:self.screens];
}

- (DPLDisplay *)displayWithDisplayID:(CGDirectDisplayID)displayID usingInformationFromScreens:(NSArray<NSScreen *> *)screens
{
    if(displayID == kCGNullDirectDisplay || CGDisplayPixelsWide(displayID) == 0)
    {
        return nil;
    }
    
    BOOL isMain = CGDisplayIsMain(displayID);
    BOOL isOnline = CGDisplayIsOnline(displayID);
    BOOL isBuiltIn = CGDisplayIsBuiltin(displayID);
    size_t width = CGDisplayPixelsWide(displayID);
    size_t height = CGDisplayPixelsHigh(displayID);
    
    id<MTLDevice> metalDevice = CGDirectDisplayCopyCurrentMetalDevice(displayID);
    Auto graphicsDevice = [[DPLGraphicsDevice alloc] initWithMetalDevice:metalDevice];
    
    Auto displayModes = [NSMutableArray<DPLDisplayMode *> new];
    Auto options = @{
        (__bridge NSString *)kCGDisplayShowDuplicateLowResolutionModes: (__bridge NSNumber *)kCFBooleanTrue
    };
    Auto modeList = CGDisplayCopyAllDisplayModes(displayID, (__bridge CFDictionaryRef)options);
    if(modeList == nil) { return nil; }
    CFIndex modeListCount = CFArrayGetCount(modeList);
    
    Auto currentDisplayModeReference = CGDisplayCopyDisplayMode(displayID);
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
    
    // Enhance the display instance with NSScreen information
    for(NSScreen *screen in screens)
    {
        if(screen.dpl_displayID == displayID)
        {
            displayInstance.localizedName = screen.localizedName;
        }
    }
    
    return displayInstance;
}

#pragma mark - Builder Methods

- (DPLDisplay *)buildDisplayUsingDirectDisplayID:(CGDirectDisplayID)directDisplayID
{
    return nil;
}

- (DPLDisplayMode *)buildDisplayModeWithReference:(CGDisplayModeRef)reference
{
    NSParameterAssert(reference);
    
    return nil;
}

@end
