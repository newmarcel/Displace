//
//  NSURL+DPLPreferences.h
//  DisplaceApplicationSupport
//
//  Created by Marcel Dierkes on 26.12.20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (DPLPreferences)
@property (class, nonatomic, readonly) NSURL *dpl_preferencesAppURL;
@end

NS_ASSUME_NONNULL_END
