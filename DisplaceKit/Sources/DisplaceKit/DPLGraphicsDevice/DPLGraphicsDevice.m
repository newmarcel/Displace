//
//  DPLGraphicsDevice.m
//  DisplaceKit
//
//  Created by Marcel Dierkes on 19.01.21.
//

#import <DisplaceKit/DPLGraphicsDevice.h>
#import "../DPLDefines.h"

NS_INLINE NSString *DPLBoolToString(BOOL value) { return (value == YES) ? @"YES" : @"NO"; }

@interface DPLGraphicsDevice ()
@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite, getter=isLowPower) BOOL lowPower;
@property (nonatomic, readwrite, getter=isHeadless) BOOL headless;
@property (nonatomic, readwrite, getter=isRemovable) BOOL removable;
@property (nonatomic, readwrite) BOOL hasUnifiedMemory;

@property(nonatomic) uint64_t registryID;
@end

@implementation DPLGraphicsDevice

- (instancetype)initWithMetalDevice:(id<MTLDevice>)metalDevice
{
    NSParameterAssert(metalDevice);
    
    self = [super init];
    {
        self.registryID = metalDevice.registryID;
        self.name = metalDevice.name;
        self.lowPower = [metalDevice isLowPower];
        self.headless = [metalDevice isHeadless];
        self.removable = [metalDevice isRemovable];
    }
    return self;
}

- (NSString *)description
{
    Auto string = [[NSMutableString alloc] initWithString:super.description];
    [string appendFormat:@"\n  ID: %@", @(self.registryID)];
    [string appendFormat:@"\n  Name: %@", self.name];
    [string appendFormat:@"\n  Is Low Power: %@", DPLBoolToString([self isLowPower])];
    [string appendFormat:@"\n  Is Headless: %@", DPLBoolToString([self isHeadless])];
    [string appendFormat:@"\n  Is Removable: %@", DPLBoolToString([self isRemovable])];
    
    return string;
}

#pragma mark - Hashable

- (NSUInteger)hash
{
    return (NSUInteger)self.registryID;
}

#pragma mark - Equatable

- (BOOL)isEqual:(nullable id)object
{
    Auto other = (DPLGraphicsDevice *)object;
    if(other == nil) { return NO; }
    if(![other isKindOfClass:[self class]]) { return NO; }
    
    return [self isEqualToGraphicsDevice:other];
}

- (BOOL)isEqualToGraphicsDevice:(DPLGraphicsDevice *)otherDevice
{
    NSParameterAssert(otherDevice);
    
    return self.registryID == otherDevice.registryID;
}

@end
