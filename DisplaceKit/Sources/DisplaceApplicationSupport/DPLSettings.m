//
//  DPLSettings.m
//  DisplaceApplicationSupport
//
//  Created by Marcel Dierkes on 23.12.20.
//

#import <DisplaceApplicationSupport/DPLSettings.h>
#import <DisplaceApplicationSupport/DPLAppGroup.h>
#import <ShortcutRecorder/ShortcutRecorder.h>
#import <DisplaceCommon/DisplaceCommon.h>

NSString * const DPLFirstLaunchFinishedKey = @"info.marcel-dierkes.Displace.FirstLaunchFinshed";
NSString * const DPLLaunchAtLoginEnabledDefaultsKey = @"info.marcel-dierkes.Displace.LaunchAtLoginEnabled";
NSString * const DPLNonRetinaDisplayModesEnabledDefaultsKey = @"info.marcel-dierkes.Displace.NonRetinaDisplayModesEnabled";
NSString * const DPLIncreaseResolutionShortcutDefaultsKey = @"info.marcel-dierkes.Displace.IncreaseResolutionShortcut";
NSString * const DPLDecreaseResolutionShortcutDefaultsKey =  @"info.marcel-dierkes.Displace.DecreaseResolutionShortcut";
NSString * const DPLHideNonProMotionRefreshRatesEnabledDefaultsKey =  @"info.marcel-dierkes.Displace.HideNonProMotionRefreshRatesEnabled";

@interface DPLSettings ()
@property (nonatomic, readwrite) id<DPLDefaultsProvider> defaults;
@end

@implementation DPLSettings

+ (instancetype)sharedSettings
{
    static dispatch_once_t once;
    static DPLSettings *sharedSettings;
    dispatch_once(&once, ^{
        sharedSettings = [self new];
    });
    return sharedSettings;
}

- (instancetype)init
{
    return [self initWithDefaultsProvider:DPLAppGroupGetUserDefaults()];
}

- (instancetype)initWithDefaultsProvider:(id<DPLDefaultsProvider>)defaults
{
    NSParameterAssert(defaults);
    
    self = [super init];
    if(self)
    {
        self.defaults = defaults;
    }
    return self;
}

#pragma mark - Properties

- (BOOL)isLaunchAtLoginEnabled
{
    return [self.defaults boolForKey:DPLLaunchAtLoginEnabledDefaultsKey];
}

- (void)setLaunchAtLoginEnabled:(BOOL)enabled
{
    [self.defaults setBool:enabled forKey:DPLLaunchAtLoginEnabledDefaultsKey];
}

#pragma mark - Retina, ProMotion

- (BOOL)isNonRetinaDisplayModesEnabled
{
    return [self.defaults boolForKey:DPLNonRetinaDisplayModesEnabledDefaultsKey];
}

- (void)setNonRetinaDisplayModesEnabled:(BOOL)enabled
{
    [self.defaults setBool:enabled forKey:DPLNonRetinaDisplayModesEnabledDefaultsKey];
}

- (BOOL)isHideNonProMotionRefreshRatesEnabled
{
    return [self.defaults boolForKey:DPLHideNonProMotionRefreshRatesEnabledDefaultsKey];
}

- (void)setHideNonProMotionRefreshRatesEnabled:(BOOL)enabled
{
    [self.defaults setBool:enabled forKey:DPLHideNonProMotionRefreshRatesEnabledDefaultsKey];
}

#pragma mark - First Launch

- (BOOL)isFirstLaunchFinished
{
    return [self.defaults boolForKey:DPLFirstLaunchFinishedKey];
}

- (void)setFirstLaunchFinished:(BOOL)firstLaunchFinished
{
    if(firstLaunchFinished == YES)
    {
        [self.defaults setBool:firstLaunchFinished forKey:DPLFirstLaunchFinishedKey];
    }
    else
    {
        [self.defaults removeObjectForKey:DPLFirstLaunchFinishedKey];
    }
}

- (void)performBlockOnFirstLaunch:(void(NS_NOESCAPE ^)(void))block
{
    if([self isFirstLaunchFinished] == NO)
    {
        self.firstLaunchFinished = YES;
        block();
    }
}

#pragma mark - Shortcuts

- (SRShortcut *)increaseResolutionShortcut
{
    Auto data = [self.defaults dataForKey:DPLIncreaseResolutionShortcutDefaultsKey];
    if(data == nil)
    {
        return nil;
    }
    
    NSError *error;
    SRShortcut *shortcut = [NSKeyedUnarchiver unarchivedObjectOfClass:[SRShortcut class]
                                                             fromData:data
                                                                error:&error];
    if(error != nil)
    {
        DPLLog(@"Failed to deserialize increase shortcut: %@", error.userInfo);
        return nil;
    }
    return shortcut;
}

- (void)setIncreaseResolutionShortcut:(SRShortcut *)increaseResolutionShortcut
{
    if(increaseResolutionShortcut == nil)
    {
        [self.defaults removeObjectForKey:DPLIncreaseResolutionShortcutDefaultsKey];
        return;
    }
    
    NSError *error;
    Auto data = [NSKeyedArchiver archivedDataWithRootObject:increaseResolutionShortcut
                                      requiringSecureCoding:YES error:&error];
    if(error != nil)
    {
        DPLLog(@"Failed to serialize increase shortcut: %@", error.userInfo);
        [self.defaults removeObjectForKey:DPLIncreaseResolutionShortcutDefaultsKey];
        return;
    }
    [self.defaults setObject:data forKey:DPLIncreaseResolutionShortcutDefaultsKey];
}

- (SRShortcut *)decreaseResolutionShortcut
{
    Auto data = [self.defaults dataForKey:DPLDecreaseResolutionShortcutDefaultsKey];
    if(data == nil)
    {
        return nil;
    }
    
    NSError *error;
    SRShortcut *shortcut = [NSKeyedUnarchiver unarchivedObjectOfClass:[SRShortcut class]
                                                             fromData:data
                                                                error:&error];
    if(error != nil)
    {
        DPLLog(@"Failed to deserialize decrease shortcut: %@", error.userInfo);
        return nil;
    }
    return shortcut;
}

- (void)setDecreaseResolutionShortcut:(SRShortcut *)decreaseResolutionShortcut
{
    if(decreaseResolutionShortcut == nil)
    {
        [self.defaults removeObjectForKey:DPLDecreaseResolutionShortcutDefaultsKey];
        return;
    }
    
    NSError *error;
    Auto data = [NSKeyedArchiver archivedDataWithRootObject:decreaseResolutionShortcut
                                      requiringSecureCoding:YES error:&error];
    if(error != nil)
    {
        DPLLog(@"Failed to serialize decrease shortcut: %@", error.userInfo);
        [self.defaults removeObjectForKey:DPLDecreaseResolutionShortcutDefaultsKey];
        return;
    }
    [self.defaults setObject:data forKey:DPLDecreaseResolutionShortcutDefaultsKey];
}

@end
