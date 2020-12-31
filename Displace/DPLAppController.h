//
//  DPLAppController.h
//  Displace
//
//  Created by Marcel Dierkes on 18.12.20.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface DPLAppController : NSObject <NSApplicationDelegate>
@property (nonatomic, readonly) NSStatusItem *systemStatusItem;
@end

NS_ASSUME_NONNULL_END
