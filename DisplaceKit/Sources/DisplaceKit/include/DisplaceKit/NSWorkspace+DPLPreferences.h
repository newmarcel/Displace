//
//  NSWorkspace+DPLPreferences.h
//  Displace
//
//  Created by Marcel Dierkes on 27.12.20.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DPLOpenPreferencesCompletionHandler)(NSRunningApplication *_Nullable,
                                                   NSError *_Nullable);

@interface NSWorkspace (DPLPreferences)

/// Opens the preferences app and calls the completion handler
/// either with the running app instance or an error.
/// @param completionHandler An optional completion handler, called on a private queue
- (void)dpl_openPreferencesWithCompletionHandler:(nullable DPLOpenPreferencesCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
