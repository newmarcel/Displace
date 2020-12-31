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
}

@end
