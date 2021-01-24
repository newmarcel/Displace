//
//  DPLPreferences.mm
//  Displace
//
//  Created by Marcel Dierkes on 23.12.20.
//

#import "DPLPreferences.h"
#import "DPLAppGroup.h"
#import <ShortcutRecorder/ShortcutRecorder.h>
#import <ServiceManagement/ServiceManagement.h>

NSString * const DPLLaunchAtLoginEnabledDefaultsKey = @"info.marcel-dierkes.Displace.LaunchAtLoginEnabled";
NSString * const DPLNonRetinaDisplayModesEnabledDefaultsKey = @"info.marcel-dierkes.Displace.NonRetinaDisplayModesEnabled";
NSString * const DPLIncreaseResolutionShortcutDefaultsKey = @"info.marcel-dierkes.Displace.IncreaseResolutionShortcut";
NSString * const DPLDecreaseResolutionShortcutDefaultsKey =  @"info.marcel-dierkes.Displace.DecreaseResolutionShortcut";
static NSString * const DPLLoginHelperBundleIdentifier = @"info.marcel-dierkes.Displace.LoginHelper";

@interface DPLPreferences ()
@property (nonatomic, readwrite) id<DPLDefaultsProvider> defaults;
@end

@implementation DPLPreferences

+ (instancetype)sharedPreferences
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
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

#pragma mark - Launch at Login

- (BOOL)setLoginHelperEnabled:(BOOL)loginHelperEnabled
{
    auto identifier = (__bridge CFStringRef)DPLLoginHelperBundleIdentifier;
    auto enabled = static_cast<Boolean>(loginHelperEnabled);
    return static_cast<BOOL>(SMLoginItemSetEnabled(identifier, enabled));
}

- (BOOL)isLaunchAtLoginEnabled
{
    return [self.defaults boolForKey:DPLLaunchAtLoginEnabledDefaultsKey];
}

- (void)setLaunchAtLoginEnabled:(BOOL)enabled
{
    BOOL success = [self setLoginHelperEnabled:enabled];
    if(success == YES)
    {
        [self.defaults setBool:enabled forKey:DPLLaunchAtLoginEnabledDefaultsKey];
    }
    else
    {
        NSLog(@"Failed to enable Login Helper.");
    }
}

#pragma mark - Non-Retina Display Modes Enabled

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
