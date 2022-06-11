//
//  DPLDisplayViewController.h
//  DPLPreferences
//
//  Created by Marcel Dierkes on 28.12.20.
//

#import <Cocoa/Cocoa.h>
#import "DPLPreferencesContentViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DPLDisplayViewController : DPLPreferencesContentViewController <NSTableViewDataSource, NSTableViewDelegate>
@property (class, nonatomic, readonly) DPLPreferenceItem *preferenceItem NS_UNAVAILABLE;
@property (weak, nonatomic, nullable) IBOutlet NSTableView *tableView;

- (IBAction)setSelectedAsCurrentDisplayResolution:(nullable id)sender;

@end

NS_ASSUME_NONNULL_END
