//
//  DPLPreferencesContentViewController.h
//  DesktopTime Preferences
//
//  Created by Marcel Dierkes on 30.01.21.
//

#import <Cocoa/Cocoa.h>
#import <DisplaceKit/DisplaceKit.h>
#import <DisplaceApplicationSupport/DisplaceApplicationSupport.h>

NS_ASSUME_NONNULL_BEGIN

@class DPLPreferenceItem;

@interface DPLPreferencesContentViewController : NSViewController
@property (class, nonatomic, readonly) NSUserInterfaceItemIdentifier identifier;
@property (class, nonatomic, readonly) DPLPreferenceItem *preferenceItem;
@property (nonatomic, readonly) NSString *preferredTitle;
@end

NS_ASSUME_NONNULL_END
