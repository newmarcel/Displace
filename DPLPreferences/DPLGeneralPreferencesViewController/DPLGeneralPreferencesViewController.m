//
//  DPLGeneralPreferencesViewController.m
//  DPLPreferences
//
//  Created by Marcel Dierkes on 28.12.20.
//

#import "DPLGeneralPreferencesViewController.h"
#import <ShortcutRecorder/ShortcutRecorder.h>
#import <DisplaceUserNotifications/DisplaceUserNotifications.h>
#import "DPLDefines.h"
#import "DPLPreferenceItem.h"

#define DPL_L10N_GENERAL NSLocalizedString(@"General", @"General")
#define DPL_L10N_GENERAL_PREFERENCES NSLocalizedString(@"General Preferences", @"General Preferences")

@interface DPLGeneralPreferencesViewController () <SRRecorderControlDelegate>
@property (nonatomic) NSUserDefaultsController *defaultsController;
@property (nonatomic) SRShortcut *increaseShortcut;
@property (nonatomic) SRShortcut *decreaseShortcut;
@end

@implementation DPLGeneralPreferencesViewController

+ (DPLPreferenceItem *)preferenceItem
{
    Auto item = [[DPLPreferenceItem alloc] initWithIdentifier:3 name:DPL_L10N_GENERAL];
    item.image = [NSImage imageWithSystemSymbolName:@"gear"
                           accessibilityDescription:nil];
    item.tintColor = NSColor.tertiaryLabelColor;
    item.viewControllerClass = [self class];
    return item;
}

- (NSString *)preferredTitle
{
    return DPL_L10N_GENERAL_PREFERENCES;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self configureBindings];
}

- (void)configureBindings
{
    self.defaultsController = [[NSUserDefaultsController alloc] initWithDefaults:DPLAppGroupGetUserDefaults() initialValues:nil];
    
    Auto keyPath = [NSString stringWithFormat:@"values.%@", DPLNonRetinaDisplayModesEnabledDefaultsKey];
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

- (void)openNotificationPreferences:(id)sender
{
    Auto workspace = NSWorkspace.sharedWorkspace;
    [workspace dpl_openNotificationPreferencesWithCompletionHandler:nil];
}

#pragma mark - Save Configuration

- (IBAction)saveConfiguration:(id)sender
{
    Auto window = self.view.window;
    Auto savePanel = NSSavePanel.savePanel;
    savePanel.nameFieldStringValue = [self proposedFileName];
    savePanel.extensionHidden = NO;
    
    Auto strings = (NSArray<NSString *> *)[DPLDisplay.allDisplays valueForKeyPath:@"debugDescription"];
    Auto outputString = [strings componentsJoinedByString:@"\n"];
    Auto data = [outputString dataUsingEncoding:NSUTF8StringEncoding];
    
    [savePanel beginSheetModalForWindow:window completionHandler:^(NSModalResponse result) {
        Auto fileURL = savePanel.URL;
        if(result == NSModalResponseOK)
        {
            DPLLog(@"Saving to %@", fileURL);
            
            NSError *error;
            [data writeToURL:fileURL options:NSDataWritingAtomic error:&error];
            if(error != nil)
            {
                DPLLog(@"Failed to write file %@", error.userInfo);
            }
        }
    }];
}

- (NSString *)proposedFileName
{
    Auto now = [NSDate date];
    Auto dateString = [NSDateFormatter localizedStringFromDate:now
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
    Auto preferences = DPLPreferences.sharedPreferences;
    
    [self willChangeValueForKey:@"increaseShortcut"];
    preferences.increaseResolutionShortcut = increaseShortcut;
    [self didChangeValueForKey:@"increaseShortcut"];
    
    Auto center = DPLNotificationCenter.defaultCenter;
    [center postNotification:DPLShortcutDidChangeNotification];
    
    
    if(increaseShortcut && [increaseShortcut isEqualToShortcut:self.decreaseShortcut])
    {
        self.decreaseShortcut = nil;
    }
}

- (SRShortcut *)decreaseShortcut
{
    Auto preferences = DPLPreferences.sharedPreferences;
    return preferences.decreaseResolutionShortcut;
}

- (void)setDecreaseShortcut:(SRShortcut *)decreaseShortcut
{
    Auto preferences = DPLPreferences.sharedPreferences;
    
    [self willChangeValueForKey:@"decreaseShortcut"];
    preferences.decreaseResolutionShortcut = decreaseShortcut;
    [self didChangeValueForKey:@"decreaseShortcut"];
    
    Auto center = DPLNotificationCenter.defaultCenter;
    [center postNotification:DPLShortcutDidChangeNotification];
    
    if(decreaseShortcut && [decreaseShortcut isEqualToShortcut:self.increaseShortcut])
    {
        self.increaseShortcut = nil;
    }
}

#pragma mark - SRRecorderControlDelegate

- (BOOL)recorderControlShouldBeginRecording:(SRRecorderControl *)aControl
{
    Auto center = DPLNotificationCenter.defaultCenter;
    [center postNotification:DPLShortcutWillEditNotification];
    return YES;
}

- (void)recorderControlDidEndRecording:(SRRecorderControl *)aControl
{
    Auto center = DPLNotificationCenter.defaultCenter;
    [center postNotification:DPLShortcutDidEditNotification];
}

@end
