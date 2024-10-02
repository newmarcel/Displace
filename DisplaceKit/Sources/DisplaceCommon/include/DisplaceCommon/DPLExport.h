//
//  DPLExport.h
//  DisplaceCommon
//
//  Created by Marcel Dierkes on 02.10.24.
//

#import <Foundation/Foundation.h>

#if defined(__cplusplus)
    #define DPL_EXPORT extern "C"
#else
    #define DPL_EXPORT extern
#endif
