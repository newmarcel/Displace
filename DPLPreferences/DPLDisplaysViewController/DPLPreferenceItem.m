//
//  DPLPreferenceItem.m
//  DPLPreferences
//
//  Created by Marcel Dierkes on 28.12.20.
//

#import "DPLPreferenceItem.h"
#import "DPLDefines.h"

@implementation DPLPreferenceItem

- (instancetype)initWithIdentifier:(NSInteger)identifier name:(NSString *)name
{
    NSParameterAssert(name);
    
    self = [super init];
    if(self)
    {
        self.identifier = identifier;
        self.name = name;
    }
    return self;
}

- (instancetype)initWithIdentifier:(NSInteger)identifier headerName:(NSString *)name image:(NSImage *)image children:(NSArray<DPLPreferenceItem *> *)children
{
    NSParameterAssert(name);
    
    Auto viewModel = [self initWithIdentifier:identifier name:name];
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
    
    NSInteger identifier = (NSInteger)display.displayID;
    Auto instance = [self initWithIdentifier:identifier
                                        name:display.localizedName];
    instance.representedObject = display;
    return instance;
}

- (NSImage *)image
{
    return _image ?: self.parent.image;
}

- (NSColor *)tintColor
{
    Auto parent = self.parent;
    if(parent != nil && parent.tintColor != nil) { return parent.tintColor; }
    return _tintColor;
}

- (NSTintConfiguration *)tintConfiguration
{
    Auto tintColor = self.tintColor;
    if(tintColor != nil)
    {
        return [NSTintConfiguration tintConfigurationWithPreferredColor:tintColor];
    }
    return nil;
}

@end
