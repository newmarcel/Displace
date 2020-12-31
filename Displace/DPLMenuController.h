//
//  DPLMenuController.h
//  Displace
//
//  Created by Marcel Dierkes on 19.12.20.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DPLMenuControllerDataSource;
@protocol DPLMenuControllerDelegate;

@interface DPLMenuController : NSObject
@property (nonatomic, readonly) NSMenu *menu;
@property (weak, nonatomic, nullable) id<DPLMenuControllerDataSource> dataSource;
@property (weak, nonatomic, nullable) id<DPLMenuControllerDelegate> delegate;

- (void)reloadMenu;

@end

@protocol DPLMenuControllerDataSource <NSObject>
- (NSInteger)numberOfDisplays;
- (NSString *)titleForDisplayAtIndex:(NSInteger)displayIndex;
- (NSInteger)numberOfDisplayModesForDisplayAtIndex:(NSInteger)displayIndex;
- (NSInteger)currentDisplayModeIndexForDisplayAtIndex:(NSInteger)displayIndex; // or -1 if that fails
- (NSString *)titleForDisplayModeAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol DPLMenuControllerDelegate <NSObject>
@optional
- (void)menuControllerShouldShowPreferences:(DPLMenuController *)controller;
- (void)menuControllerShouldTerminate:(DPLMenuController *)controller;
- (void)menuController:(DPLMenuController *)controller didSelectDisplayModeAtIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
