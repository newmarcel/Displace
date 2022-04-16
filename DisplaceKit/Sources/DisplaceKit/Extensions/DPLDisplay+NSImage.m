//
//  DPLDisplay+NSImage.m
//  DisplaceKit
//
//  Created by Marcel Dierkes on 28.03.21.
//

#import <DisplaceKit/DPLDisplay+NSImage.h>
#import "../DPLDefines.h"

@implementation DPLDisplay (NSImage)

- (NSImage *)image
{
    if([self isSidecar])
    {
        return [NSImage imageWithSystemSymbolName:@"ipad.landscape"
                         accessibilityDescription:nil];
    }
    
    return [NSImage imageWithSystemSymbolName:@"display"
                     accessibilityDescription:nil];
}

@end
