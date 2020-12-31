//
//  DPLDisplayViewController.h
//  DPLPreferences
//
//  Created by Marcel Dierkes on 28.12.20.
//

#import <Cocoa/Cocoa.h>
#import <DisplaceKit/DisplaceKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DPLDisplayViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>
@property (class, nonatomic, readonly) NSStoryboardSceneIdentifier identifier;
@property (weak, nonatomic, nullable) IBOutlet NSTableView *tableView;
@end

NS_ASSUME_NONNULL_END
