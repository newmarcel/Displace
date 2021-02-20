//
//  DPLPreferenceItem.h
//  DPLPreferences
//
//  Created by Marcel Dierkes on 28.12.20.
//

#import <Cocoa/Cocoa.h>
#import <DisplaceKit/DisplaceKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DPLPreferenceItem : NSObject
@property (nonatomic) NSInteger identifier;
@property (nonatomic) NSString *name;

@property (nonatomic, nullable) id representedObject;

@property (nonatomic, getter=isHeader) BOOL header;
@property (nonatomic, getter=isExpanded) BOOL expanded;

@property (nonatomic, nullable) NSArray<DPLPreferenceItem *> *children;
@property (weak, nonatomic, nullable) DPLPreferenceItem *parent;

@property (nonatomic, nullable) NSImage *image;
@property (nonatomic, nullable) NSColor *tintColor;
@property (nonatomic, nullable, readonly) NSTintConfiguration *tintConfiguration;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithIdentifier:(NSInteger)identifier
                              name:(NSString *)name NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithIdentifier:(NSInteger)identifier
                        headerName:(NSString *)name
                             image:(nullable NSImage *)image
                          children:(nullable NSArray<DPLPreferenceItem *> *)children;

- (instancetype)initWithDisplay:(DPLDisplay *)display;

@end

NS_ASSUME_NONNULL_END
