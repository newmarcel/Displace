//
//  DPLAppGroup.h
//  DisplaceApplicationSupport
//
//  Created by Marcel Dierkes on 23.12.20.
//

#import <Foundation/Foundation.h>
#import <DisplaceCommon/DPLExport.h>

NS_ASSUME_NONNULL_BEGIN

DPL_EXPORT NSString * const DPLAppGroupIdentifier;

DPL_EXPORT NSURL *DPLAppGroupGetURLWithPathComponent(NSString *);

DPL_EXPORT NSURL *DPLAppGroupGetDefaultDirectoryURL(void);

DPL_EXPORT NSUserDefaults *DPLAppGroupGetUserDefaults(void);

NS_ASSUME_NONNULL_END
