//
//  DPLDisplaysViewController.h
//  DPLPreferences
//
//  Created by Marcel Dierkes on 27.12.20.
//

#import <Cocoa/Cocoa.h>
#import <DisplaceKit/DisplaceKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DPLDisplaysViewController : NSViewController <NSOutlineViewDataSource, NSOutlineViewDelegate>
@property (weak, nonatomic, nullable) IBOutlet NSOutlineView *outlineView;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
