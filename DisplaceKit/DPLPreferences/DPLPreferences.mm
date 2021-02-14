//
//  DPLPreferences.mm
//  Displace
//
//  Created by Marcel Dierkes on 23.12.20.
//

#import "DPLPreferences.h"
#import "DPLAppGroup.h"
#import <ShortcutRecorder/ShortcutRecorder.h>

namespace DPL::Preferences::Key
{
constexpr auto LaunchAtLoginEnabled = @"info.marcel-dierkes.Displace.LaunchAtLoginEnabled";
}

NSString * const DPLNonRetinaDisplayModesEnabledDefaultsKey = @"info.marcel-dierkes.Displace.NonRetinaDisplayModesEnabled";
NSString * const DPLIncreaseResolutionShortcutDefaultsKey = @"info.marcel-dierkes.Displace.IncreaseResolutionShortcut";
NSString * const DPLDecreaseResolutionShortcutDefaultsKey =  @"info.marcel-dierkes.Displace.DecreaseResolutionShortcut";

using namespace DPL::Preferences;

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
    return [self.defaults boolForKey:Key::LaunchAtLoginEnabled];
}

- (void)setLaunchAtLoginEnabled:(BOOL)enabled
{
    [self.defaults setBool:enabled forKey:Key::LaunchAtLoginEnabled];
}

- (BOOL)isNonRetinaDisplayModesEnabled
{
    return [self.defaults boolForKey:DPLNonRetinaDisplayModesEnabledDefaultsKey];
}

- (void)setNonRetinaDisplayModesEnabled:(BOOL)enabled
{
    [self.defaults setBool:enabled forKey:DPLNonRetinaDisplayModesEnabledDefaultsKey];
}

#pragma mark - Shortcuts

- (SRShortcut *)increaseResolutionShortcut
{
    auto data = [self.defaults dataForKey:DPLIncreaseResolutionShortcutDefaultsKey];
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
        NSLog(@"Failed to deserialize increase shortcut: %@", error.userInfo);
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
    auto data = [NSKeyedArchiver archivedDataWithRootObject:increaseResolutionShortcut
                                      requiringSecureCoding:YES error:&error];
    if(error != nil)
    {
        NSLog(@"Failed to serialize increase shortcut: %@", error.userInfo);
        [self.defaults removeObjectForKey:DPLIncreaseResolutionShortcutDefaultsKey];
        return;
    }
    [self.defaults setObject:data forKey:DPLIncreaseResolutionShortcutDefaultsKey];
}

- (SRShortcut *)decreaseResolutionShortcut
{
    auto data = [self.defaults dataForKey:DPLDecreaseResolutionShortcutDefaultsKey];
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
        NSLog(@"Failed to deserialize decrease shortcut: %@", error.userInfo);
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
    auto data = [NSKeyedArchiver archivedDataWithRootObject:decreaseResolutionShortcut
                                      requiringSecureCoding:YES error:&error];
    if(error != nil)
    {
        NSLog(@"Failed to serialize decrease shortcut: %@", error.userInfo);
        [self.defaults removeObjectForKey:DPLDecreaseResolutionShortcutDefaultsKey];
        return;
    }
    [self.defaults setObject:data forKey:DPLDecreaseResolutionShortcutDefaultsKey];
}

@end
