//
//  DPLHelper.h
//  DPLHelper
//
//  Created by Marcel Dierkes on 20.02.21.
//

#import <Foundation/Foundation.h>
#import "DPLHelperProtocol.h"

// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
@interface DPLHelper : NSObject <DPLHelperProtocol>
@end
