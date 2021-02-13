//
//  DPLDefines.h
//  Displace
//
//  Created by Marcel Dierkes on 17.01.21.
//

#ifndef DPL_DEFINES_H
#define DPL_DEFINES_H

#define Auto const __auto_type
#define AutoVar __auto_type
#define AutoWeak __weak __auto_type

#if DEBUG
#define DPLLog(_args...) NSLog(_args)
#else
#define DPLLog(_args...)
#endif

#endif /* DPL_DEFINES_H */
