//
//  DPLDisplay+NSImage.m
//  DisplaceKit
//
//  Created by Marcel Dierkes on 28.03.21.
//

#import <DisplaceKit/DPLDisplay+NSImage.h>
#import <DisplaceCommon/DisplaceCommon.h>

@implementation DPLDisplay (NSImage)

- (NSImage *)image
{
    if([self isSidecar])
    {
        return [NSImage imageWithSystemSymbolName:@"ipad.landscape"
                         accessibilityDescription:nil];
    }
    else if([self hasSafeArea])
    {
        return [NSImage imageWithSystemSymbolName:@"laptopcomputer"
                         accessibilityDescription:nil];
    }
    
    return [NSImage imageWithSystemSymbolName:@"display"
                     accessibilityDescription:nil];
}

@end
