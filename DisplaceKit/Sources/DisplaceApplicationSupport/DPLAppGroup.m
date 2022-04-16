//
//  DPLAppGroup.m
//  DisplaceApplicationSupport
//
//  Created by Marcel Dierkes on 23.12.20.
//

#import <DisplaceApplicationSupport/DPLAppGroup.h>
#import "DPLDefines.h"

NSString * const DPLAppGroupIdentifier = @"group.info.marcel-dierkes.Displace";
static NSString * const DPLAppGroupDefaultDirectoryName = @"Displace";

NSURL *DPLAppGroupGetURLWithPathComponent(NSString *pathComponent)
{
    NSCParameterAssert(pathComponent);
    
    Auto fileManager = NSFileManager.defaultManager;
    Auto identifier = DPLAppGroupIdentifier;
    Auto container = [fileManager containerURLForSecurityApplicationGroupIdentifier:identifier];
    
    Auto URL = [container URLByAppendingPathComponent:pathComponent];
    if(![fileManager fileExistsAtPath:URL.path])
    {
        NSError *error;
        [fileManager createDirectoryAtURL:URL withIntermediateDirectories:YES attributes:nil error:&error];
        if(error != nil)
        {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:@"Could not create app group directory."
                                         userInfo:@{ NSUnderlyingErrorKey: error }];
        }
    }
    return URL;
}

NSURL *DPLAppGroupGetDefaultDirectoryURL()
{
    return DPLAppGroupGetURLWithPathComponent(DPLAppGroupDefaultDirectoryName);
}

NSUserDefaults *DPLAppGroupGetUserDefaults()
{
    return [[NSUserDefaults alloc] initWithSuiteName:DPLAppGroupIdentifier];
}
