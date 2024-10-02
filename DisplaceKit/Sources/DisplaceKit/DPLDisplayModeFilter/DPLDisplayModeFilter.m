//
//  DPLDisplayModeFilter.m
//  DisplaceKit
//
//  Created by Marcel Dierkes on 16.04.22.
//

#import "DPLDisplayModeFilter.h"
#import <DisplaceCommon/DisplaceCommon.h>

NS_INLINE NSArray<DPLDisplayMode *> *DPLDisplayModesGetWithRefreshRate(NSArray<DPLDisplayMode *> *displayModes, double refreshRate)
{
    NSCParameterAssert(displayModes);
    
    Auto predicate = [NSPredicate predicateWithFormat:@"refreshRate == %@", @(refreshRate)];
    return [displayModes filteredArrayUsingPredicate:predicate];
}

NS_INLINE DPLDisplayMode *DPLDisplayModeGetNext(NSArray<DPLDisplayMode *> *displayModes, DPLDisplayMode *currentDisplayMode, BOOL isInForwardDirection)
{
    Auto currentIndex = [displayModes indexOfObject:currentDisplayMode];
    if(currentIndex == NSNotFound) { return nil; }
    
    if(isInForwardDirection == YES)
    {
        Auto nextIndex = currentIndex - 1;
        if(nextIndex < 0 || nextIndex >= displayModes.count) { return nil; }
        
        return displayModes[nextIndex];
    }
    else
    {
        Auto previousIndex = currentIndex + 1;
        if(previousIndex < 0 || previousIndex >= displayModes.count) { return nil; }
        
        return displayModes[previousIndex];
    }
}

DPLDisplayMode *DPLDisplayModeGetNextBest(NSArray<DPLDisplayMode *> *displayModes, DPLDisplayMode *currentDisplayMode, BOOL isInForwardDirection)
{
    NSCParameterAssert(displayModes);
    
    if(currentDisplayMode == nil) { return nil; }
    
    if(currentDisplayMode.refreshRate >= 0.0f)
    {
        Auto filtered = DPLDisplayModesGetWithRefreshRate(displayModes, currentDisplayMode.refreshRate);
        Auto filteredMode = DPLDisplayModeGetNext(filtered, currentDisplayMode, isInForwardDirection);
        if(filteredMode != nil) { return filteredMode; }
    }
    
    return DPLDisplayModeGetNext(displayModes, currentDisplayMode, isInForwardDirection);
}

DPLDisplayMode *DPLDisplayModeGetHigherDisplayMode(NSArray<DPLDisplayMode *> *displayModes, DPLDisplayMode *currentDisplayMode)
{
    return DPLDisplayModeGetNextBest(displayModes, currentDisplayMode, YES);
}

DPLDisplayMode *DPLDisplayModeGetLowerDisplayMode(NSArray<DPLDisplayMode *> *displayModes, DPLDisplayMode *currentDisplayMode)
{
    return DPLDisplayModeGetNextBest(displayModes, currentDisplayMode, NO);
}
