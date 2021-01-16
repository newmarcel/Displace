//
//  DPLDisplay.h
//  Displace
//
//  Created by Marcel Dierkes on 26.12.20.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AppKit/NSScreen.h>

NS_ASSUME_NONNULL_BEGIN

@class DPLDisplayMode;

@interface DPLDisplay : NSObject
@property (class, copy, nonatomic, readonly) NSArray<DPLDisplay *> *allDisplays;

@property (nonatomic, readonly) CGDirectDisplayID displayID;
@property (nonatomic, readonly) NSInteger width;
@property (nonatomic, readonly) NSInteger height;

@property (nonatomic, getter=isMain, readonly) BOOL main;
@property (nonatomic, getter=isOnline, readonly) BOOL online;
@property (nonatomic, getter=isBuiltIn, readonly) BOOL builtIn;

@property (nonatomic, readonly) NSArray<DPLDisplayMode *> *displayModes;
@property (nonatomic, nullable) DPLDisplayMode *currentDisplayMode;
@property (nonatomic, nullable, readonly) DPLDisplayMode *nextDisplayMode;
@property (nonatomic, nullable, readonly) DPLDisplayMode *previousDisplayMode;

@property (copy, nonatomic, readonly) NSString *localizedName;

+ (NSArray<DPLDisplay *> *)allDisplaysUsingInformationFromScreens:(nullable NSArray<NSScreen *> *)screens;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithDisplayID:(CGDirectDisplayID)displayID
                            width:(NSInteger)width
                           height:(NSInteger)height
                             main:(BOOL)main
                           online:(BOOL)online
                          builtIn:(BOOL)builtIn
                     displayModes:(NSArray<DPLDisplayMode *> *)displayModes
               currentDisplayMode:(nullable DPLDisplayMode *)currentDisplayMode NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqualToDisplay:(DPLDisplay *)display;

- (void)applyCurrentDisplayMode;

@end

NS_ASSUME_NONNULL_END
