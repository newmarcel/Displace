//
//  DPLPreferencesWindowController.h
//  DPLPreferences
//
//  Created by Marcel Dierkes on 27.12.20.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface DPLPreferencesWindowController : NSWindowController

- (IBAction)completelyTerminate:(id)sender;
- (IBAction)showAboutPanel:(nullable id)sender;

@end

NS_ASSUME_NONNULL_END
