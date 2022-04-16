//
//  DPLGeneralPreferencesViewController.h
//  DPLPreferences
//
//  Created by Marcel Dierkes on 28.12.20.
//

#import <Cocoa/Cocoa.h>
#import "DPLPreferencesContentViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class SRRecorderControl;

@interface DPLGeneralPreferencesViewController : DPLPreferencesContentViewController
@property (nonatomic, nullable) IBOutlet NSButton *showNonRetinaResolutionsCheckbox;
@property (nonatomic, nullable) IBOutlet NSButton *hideNonProMotionRefreshRatesCheckbox;
@property (nonatomic, nullable) IBOutlet SRRecorderControl *increaseRecorderControl;
@property (nonatomic, nullable) IBOutlet SRRecorderControl *decreaseRecorderControl;

- (IBAction)saveConfiguration:(nullable id)sender;
- (IBAction)openNotificationPreferences:(nullable id)sender;

@end

NS_ASSUME_NONNULL_END
