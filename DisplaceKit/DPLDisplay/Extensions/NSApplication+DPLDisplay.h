//
//  NSApplication+DPLDisplay.h
//  DisplaceKit
//
//  Created by Marcel Dierkes on 15.02.21.
//

#import <Cocoa/Cocoa.h>
#import <CoreGraphics/CoreGraphics.h>
#import <DisplaceKit/DPLDisplay.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSApplication (DPLDisplay)
/// Returns the currently active display (i.e. the menu bar is in an active state)
@property (nonatomic, readonly, nullable) DPLDisplay *dpl_activeDisplay;
@end

NS_ASSUME_NONNULL_END
