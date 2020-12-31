//
//  DPLDisplayMode.h
//  Displace
//
//  Created by Marcel Dierkes on 26.12.20.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface DPLDisplayMode : NSObject
@property (nonatomic, readonly) int32_t displayModeID;
@property (nonatomic, readonly) NSInteger width;
@property (nonatomic, readonly) NSInteger height;
@property (nonatomic, getter=isNativeResolution, readonly) BOOL nativeResolution;
@property (nonatomic, getter=isRetinaResolution, readonly) BOOL retinaResolution;

@property (nonatomic, readonly) CGDisplayModeRef reference;

@property (copy, nonatomic, readonly) NSString *localizedName;
@property (copy, nonatomic, readonly) NSString *localizedNameWithoutAttributes;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithDisplayModeID:(int32_t)displayModeID
                                width:(NSInteger)width
                               height:(NSInteger)height
                     nativeResolution:(BOOL)nativeResolution
                     retinaResolution:(BOOL)retinaResolution
                            reference:(CGDisplayModeRef)reference NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithDisplayModeReference:(CGDisplayModeRef)reference;

- (BOOL)isEqualToDisplayMode:(DPLDisplayMode *)display;

@end

NS_ASSUME_NONNULL_END
