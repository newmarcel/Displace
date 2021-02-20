//
//  DPLHelper.m
//  DPLHelper
//
//  Created by Marcel Dierkes on 20.02.21.
//

#import "DPLHelper.h"

@implementation DPLHelper

// This implements the example protocol. Replace the body of this class with the implementation of this service's protocol.
- (void)upperCaseString:(NSString *)aString withReply:(void (^)(NSString *))reply
{
    NSString *response = [aString uppercaseString];
    reply(response);
}

@end
