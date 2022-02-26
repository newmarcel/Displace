//
//  DPLPreferences.m
//  Displace
//
//  Created by Marcel Dierkes on 23.12.20.
//

#import <DisplaceKit/DPLPreferences.h>
#import <DisplaceKit/DPLAppGroup.h>
#import <ShortcutRecorder/ShortcutRecorder.h>
#import "../DPLDefines.h"

NSString * const DPLFirstLaunchFinishedKey = @"info.marcel-dierkes.Displace.FirstLaunchFinshed";
NSString * const DPLLaunchAtLoginEnabledDefaultsKey = @"info.marcel-dierkes.Displace.LaunchAtLoginEnabled";
NSString * const DPLNonRetinaDisplayModesEnabledDefaultsKey = @"info.marcel-dierkes.Displace.NonRetinaDisplayModesEnabled";
NSString * const DPLIncreaseResolutionShortcutDefaultsKey = @"info.marcel-dierkes.Displace.IncreaseResolutionShortcut";
NSString * const DPLDecreaseResolutionShortcutDefaultsKey =  @"info.marcel-dierkes.Displace.DecreaseResolutionShortcut";

@interface DPLPreferences ()
@property (nonatomic, readwrite) id<DPLDefaultsProvider> defaults;
@end

@implementation DPLPreferences

+ (instancetype)sharedPreferences
{
    static dispatch_once_t once;
    static DPLPreferences *sharedPreferences;
    dispatch_once(&once, ^{
        sharedPreferences = [self new];
    });
    return sharedPreferences;
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

- (BOOL)isNonRetinaDisplayModesEnabled
{
    return [self.defaults boolForKey:DPLNonRetinaDisplayModesEnabledDefaultsKey];
}

- (void)setNonRetinaDisplayModesEnabled:(BOOL)enabled
{
    [self.defaults setBool:enabled forKey:DPLNonRetinaDisplayModesEnabledDefaultsKey];
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
