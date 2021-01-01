//
//  DPLGeneralPreferencesViewController.mm
//  DPLPreferences
//
//  Created by Marcel Dierkes on 28.12.20.
//

#import "DPLGeneralPreferencesViewController.h"
#import <ShortcutRecorder/ShortcutRecorder.h>

@interface DPLGeneralPreferencesViewController ()
@property (nonatomic) NSUserDefaultsController *defaultsController;
@property (nonatomic) SRShortcut *increaseShortcut;
@property (nonatomic) SRShortcut *decreaseShortcut;
@end

@implementation DPLGeneralPreferencesViewController

+ (NSStoryboardSceneIdentifier)identifier
{
    return @"ShortcutsViewController";
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self configureBindings];
}

- (void)viewDidAppear
{
    [super viewDidAppear];
    
    auto window = self.view.window;
    window.subtitle = NSLocalizedString(@"General Preferences", @"General Preferences");
}

- (void)configureBindings
{
    self.defaultsController = [[NSUserDefaultsController alloc] initWithDefaults:DPLAppGroupGetUserDefaults() initialValues:nil];
    
    auto keyPath = [NSString stringWithFormat:@"values.%@", DPLNonRetinaDisplayModesEnabledDefaultsKey];
    [self.showNonRetinaResolutionsCheckbox bind:NSValueBinding
                                       toObject:self.defaultsController
                                    withKeyPath:keyPath
                                        options:nil];
    
    [self.increaseRecorderControl bind:NSValueBinding
                              toObject:self
                           withKeyPath:@"increaseShortcut"
                               options:nil];
    [self.decreaseRecorderControl bind:NSValueBinding
                              toObject:self
                           withKeyPath:@"decreaseShortcut"
                               options:nil];
}

#pragma mark - Shortcuts

- (SRShortcut *)increaseShortcut
{
    return DPLPreferences.sharedPreferences.increaseResolutionShortcut;
}

- (void)setIncreaseShortcut:(SRShortcut *)increaseShortcut
{
    [self willChangeValueForKey:@"increaseShortcut"];
    DPLPreferences.sharedPreferences.increaseResolutionShortcut = increaseShortcut;
    [self didChangeValueForKey:@"increaseShortcut"];
}

- (SRShortcut *)decreaseShortcut
{
    auto preferences = DPLPreferences.sharedPreferences;
    return preferences.decreaseResolutionShortcut;
}

- (void)setDecreaseShortcut:(SRShortcut *)decreaseShortcut
{
    auto preferences = DPLPreferences.sharedPreferences;
    
    [self willChangeValueForKey:@"decreaseShortcut"];
    preferences.decreaseResolutionShortcut = decreaseShortcut;
    [self didChangeValueForKey:@"decreaseShortcut"];
}

@end
