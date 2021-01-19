//
//  DPLGraphicsDevice.h
//  DisplaceKit
//
//  Created by Marcel Dierkes on 19.01.21.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

NS_ASSUME_NONNULL_BEGIN

@interface DPLGraphicsDevice : NSObject
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly, getter=isLowPower) BOOL lowPower;
@property (nonatomic, readonly, getter=isHeadless) BOOL headless;
@property (nonatomic, readonly, getter=isRemovable) BOOL removable;
@property (nonatomic, readonly) BOOL hasUnifiedMemory;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithMetalDevice:(id<MTLDevice>)metalDevice NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqual:(nullable id)object;
- (BOOL)isEqualToGraphicsDevice:(DPLGraphicsDevice *)otherDevice;

@end

NS_ASSUME_NONNULL_END
