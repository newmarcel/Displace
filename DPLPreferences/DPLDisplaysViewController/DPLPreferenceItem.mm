//
//  DPLPreferenceItem.mm
//  DPLPreferences
//
//  Created by Marcel Dierkes on 28.12.20.
//

#import "DPLPreferenceItem.h"

@implementation DPLPreferenceItem

- (instancetype)initWithIdentifier:(NSInteger)identifier name:(NSString *)name
{
    NSParameterAssert(name);
    self = [super init];
    if(self) { self.identifier = identifier; self.name = name; }
    return self;
}

- (instancetype)initWithIdentifier:(NSInteger)identifier headerName:(NSString *)name image:(NSImage *)image children:(NSArray<DPLPreferenceItem *> *)children
{
    NSParameterAssert(name);
    auto viewModel = [self initWithIdentifier:identifier name:name];
    viewModel.header = YES;
    viewModel.expanded = YES;
    viewModel.children = children;
    viewModel.image = image;
    for(DPLPreferenceItem *child in children) { child.parent = self; }
    return viewModel;
}

- (instancetype)initWithDisplay:(DPLDisplay *)display
{
    NSParameterAssert(display);
    
    auto identifier = static_cast<NSInteger>(display.displayID);
    decltype(self) instance = [self initWithIdentifier:identifier
                                                  name:display.localizedName];
    instance.representedObject = display;
    return instance;
}

- (NSImage *)image
{
    if(auto parent = self.parent; parent.image != nil) { return parent.image; }
    return _image;
}

- (NSColor *)tintColor
{
    if(auto parent = self.parent; parent.tintColor != nil) { return parent.tintColor; }
    return _tintColor;
}

- (NSTintConfiguration *)tintConfiguration
{
    if(auto tintColor = self.tintColor)
    {
        return [NSTintConfiguration tintConfigurationWithPreferredColor:tintColor];
    }
    return nil;
}

@end
