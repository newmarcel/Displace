//
//  DPLDisplayManager.h
//  DisplaceKit
//
//  Created by Marcel Dierkes on 21.03.21.
//

#import <Cocoa/Cocoa.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Metal/Metal.h>

NS_ASSUME_NONNULL_BEGIN

@class DPLDisplay;

@interface DPLDisplayManager : NSObject
@property (class, nonatomic, readonly) DPLDisplayManager *sharedManager;

@property (nonatomic, readonly) NSArray<NSScreen *> *screens;
@property (copy, nonatomic, readonly) NSArray<DPLDisplay *> *allDisplays;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoreGraphicsDisplaysAndScreens:(nullable NSArray<NSScreen *> *)screens NS_DESIGNATED_INITIALIZER;

- (nullable DPLDisplay *)displayWithDisplayID:(CGDirectDisplayID)displayID;
- (nullable DPLDisplay *)displayWithDisplayID:(CGDirectDisplayID)displayID
                  usingInformationFromScreens:(nullable NSArray<NSScreen *> *)screens;

@end

NS_ASSUME_NONNULL_END
