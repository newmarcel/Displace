//
//  DPLGeneralPreferencesViewController.h
//  DPLPreferences
//
//  Created by Marcel Dierkes on 28.12.20.
//

#import <Cocoa/Cocoa.h>
#import <DisplaceKit/DisplaceKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SRRecorderControl;

@interface DPLGeneralPreferencesViewController : NSViewController
@property (class, nonatomic, readonly) NSStoryboardSceneIdentifier identifier;
@property (nonatomic, nullable) IBOutlet NSButton *showNonRetinaResolutionsCheckbox;
@property (nonatomic, nullable) IBOutlet SRRecorderControl *increaseRecorderControl;
@property (nonatomic, nullable) IBOutlet SRRecorderControl *decreaseRecorderControl;

- (IBAction)saveConfiguration:(nullable id)sender;

@end

NS_ASSUME_NONNULL_END
