//
//  DPLGeneralPreferencesViewController.mm
//  DPLPreferences
//
//  Created by Marcel Dierkes on 28.12.20.
//

#import "DPLGeneralPreferencesViewController.h"
#import <ShortcutRecorder/ShortcutRecorder.h>

@interface DPLGeneralPreferencesViewController () <SRRecorderControlDelegate>
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

#pragma mark - Save Configuration

- (IBAction)saveConfiguration:(id)sender
{
    auto window = self.view.window;
    auto savePanel = NSSavePanel.savePanel;
    savePanel.nameFieldStringValue = [self proposedFileName];
    savePanel.extensionHidden = NO;
    
    auto strings = static_cast<NSArray<NSString *> *>([DPLDisplay.allDisplays valueForKeyPath:@"debugDescription"]);
    auto outputString = [strings componentsJoinedByString:@"\n"];
    auto data = [outputString dataUsingEncoding:NSUTF8StringEncoding];
    
    [savePanel beginSheetModalForWindow:window completionHandler:^(NSModalResponse result) {
        auto fileURL = savePanel.URL;
        if(result == NSModalResponseOK)
        {
            NSLog(@"Saving to %@", fileURL);
            
            NSError *error;
            [data writeToURL:fileURL options:NSDataWritingAtomic error:&error];
            if(error != nil)
            {
                NSLog(@"Failed to write file %@", error.userInfo);
            }
        }
    }];
}

- (NSString *)proposedFileName
{
    auto now = [NSDate date];
    auto dateString = [NSDateFormatter localizedStringFromDate:now
                                                     dateStyle:NSDateFormatterShortStyle
                                                     timeStyle:NSDateFormatterNoStyle];
    return [NSString stringWithFormat:@"Display Configuration %@.txt", dateString];
}

#pragma mark - Shortcuts

- (SRShortcut *)increaseShortcut
{
    return DPLPreferences.sharedPreferences.increaseResolutionShortcut;
}

- (void)setIncreaseShortcut:(SRShortcut *)increaseShortcut
{
    auto preferences = DPLPreferences.sharedPreferences;
    
    [self willChangeValueForKey:@"increaseShortcut"];
    preferences.increaseResolutionShortcut = increaseShortcut;
    [self didChangeValueForKey:@"increaseShortcut"];
    
    auto center = DPLNotificationCenter.defaultCenter;
    [center postNotification:DPLShortcutDidChangeNotification];
    
    
    if(increaseShortcut && [increaseShortcut isEqualToShortcut:self.decreaseShortcut])
    {
        self.decreaseShortcut = nil;
    }
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
    
    auto center = DPLNotificationCenter.defaultCenter;
    [center postNotification:DPLShortcutDidChangeNotification];
    
    if(decreaseShortcut && [decreaseShortcut isEqualToShortcut:self.increaseShortcut])
    {
        self.increaseShortcut = nil;
    }
}

#pragma mark - SRRecorderControlDelegate

- (BOOL)recorderControlShouldBeginRecording:(SRRecorderControl *)aControl
{
    auto center = DPLNotificationCenter.defaultCenter;
    [center postNotification:DPLShortcutWillEditNotification];
    return YES;
}

- (void)recorderControlDidEndRecording:(SRRecorderControl *)aControl
{
    auto center = DPLNotificationCenter.defaultCenter;
    [center postNotification:DPLShortcutDidEditNotification];
}

@end
