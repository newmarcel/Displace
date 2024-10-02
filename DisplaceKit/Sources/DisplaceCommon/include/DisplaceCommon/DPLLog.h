//
//  DPLLog.h
//  DisplaceCommon
//
//  Created by Marcel Dierkes on 02.10.24.
//

#import <Foundation/Foundation.h>
#import <os/log.h>

#if DEBUG
#define DPLLog(_args...) NSLog(_args)
#else
#define DPLLog(_args...)
#endif

NS_INLINE os_log_t DPLLogCreateWithCategory(const char *category)
{
    return os_log_create("info.marcel-dierkes.Displace", category);
}
