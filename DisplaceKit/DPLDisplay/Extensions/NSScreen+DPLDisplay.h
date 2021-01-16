//
//  NSScreen+DPLDisplayID.h
//  DisplaceKit
//
//  Created by Marcel Dierkes on 16.01.21.
//

#import <Cocoa/Cocoa.h>
#import <CoreGraphics/CoreGraphics.h>
#import <DisplaceKit/DPLDisplay.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSScreen (DPLDisplay)
@property (nonatomic, readonly) CGDirectDisplayID dpl_displayID;
@end

@interface DPLDisplay (NSScreen)
+ (NSArray<DPLDisplay *> *)allDisplaysWithInformationFromScreens:(nullable NSArray<NSScreen *> *)screens;
@end

NS_ASSUME_NONNULL_END
