//
//  DPLAppGroup.h
//  Displace
//
//  Created by Marcel Dierkes on 23.12.20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const DPLAppGroupIdentifier;

FOUNDATION_EXPORT NSURL *DPLAppGroupGetURLWithPathComponent(NSString *);

FOUNDATION_EXPORT NSURL *DPLAppGroupGetDefaultDirectoryURL(void);

FOUNDATION_EXPORT NSUserDefaults *DPLAppGroupGetUserDefaults(void);

NS_ASSUME_NONNULL_END
