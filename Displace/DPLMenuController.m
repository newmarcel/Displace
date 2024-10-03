//
//  DPLMenuController.m
//  Displace
//
//  Created by Marcel Dierkes on 19.12.20.
//

#import "DPLMenuController.h"
#import <DisplaceCommon/DisplaceCommon.h>
#import "DPLLocalizedStrings.h"

@interface DPLMenuController () <NSMenuDelegate>
@property (nonatomic, readwrite) NSMenu *menu;
@end

@implementation DPLMenuController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self configureMenu];
    }
    return self;
}

#pragma mark - Menu Builder

- (void)configureMenu
{
    Auto menu = [[NSMenu alloc] initWithTitle:DPL_L10N_DISPLAYS];
    menu.delegate = self;
    self.menu = menu;
}

- (void)reloadMenu
{
    [self reloadMenu:self.menu];
}

- (void)reloadMenu:(NSMenu *)menu
{
    NSParameterAssert(menu);
    
    if(self.dataSource == nil)
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Missing Data Source"
                                     userInfo:nil];
        return;
    }
    
    [menu removeAllItems];
    
    [self addCurrentDisplayModesToMenu:menu];
    
    Auto dataSource = self.dataSource;
    Auto displayCount = [dataSource numberOfDisplays];
    for(NSInteger displayIndex = 0; displayIndex < displayCount; displayIndex++)
    {
        Auto title = [dataSource titleForDisplayAtIndex:displayIndex];
        Auto item = [[NSMenuItem alloc] initWithTitle:title action:nil keyEquivalent:@""];
        item.image = [dataSource imageForDisplayAtIndex:displayIndex];
        
        [self addDisplayModeMenuForDisplayAtIndex:displayIndex toItem:item];
        [menu addItem:item];
    }
    
    [self addControlItemsToMenu:menu];
    [self addTrailingStandardItemsToMenu:menu];
}

- (void)addDisplayModeMenuForDisplayAtIndex:(NSInteger)displayIndex toItem:(NSMenuItem *)item
{
    NSParameterAssert(item);
    
    Auto dataSource = self.dataSource;
    Auto menuTitle = [dataSource titleForDisplayAtIndex:displayIndex];
    Auto menu = [[NSMenu alloc] initWithTitle:menuTitle];
    
    Auto currentDisplayModeIndex = [dataSource currentDisplayModeIndexForDisplayAtIndex:displayIndex];

    Auto displayModeCount = [dataSource numberOfDisplayModesForDisplayAtIndex:displayIndex];
    if(displayModeCount == 0) { return; }
    
    for(NSInteger index = 0; index < displayModeCount; index++)
    {
        Auto indexPath = [NSIndexPath indexPathForItem:index inSection:displayIndex];
        Auto title = [dataSource titleForDisplayModeAtIndexPath:indexPath];
        Auto subItem = [[NSMenuItem alloc] initWithTitle:title
                                                  action:@selector(selectDisplayMode:)
                                           keyEquivalent:@""];
        subItem.target = self;
        subItem.representedObject = indexPath;
        
        if(currentDisplayModeIndex >= 0 && index == currentDisplayModeIndex)
        {
            subItem.state = NSControlStateValueOn;
        }
        
        [menu addItem:subItem];
    }

    item.submenu = menu;
}

- (void)addControlItemsToMenu:(NSMenu *)menu
{
    NSParameterAssert(menu);
    
    Auto dataSource = self.dataSource;
    
    NSString *increaseKeyEquivalent;
    NSEventModifierFlags increaseFlags = 0;
    if([dataSource respondsToSelector:@selector(keyEquivalentForIncrease:modifierFlags:)])
    {
        [dataSource keyEquivalentForIncrease:&increaseKeyEquivalent
                               modifierFlags:&increaseFlags];
    }
    
    NSString *decreaseKeyEquivalent;
    NSEventModifierFlags decreaseFlags = 0;
    if([dataSource respondsToSelector:@selector(keyEquivalentForDecrease:modifierFlags:)])
    {
        [dataSource keyEquivalentForDecrease:&decreaseKeyEquivalent
                               modifierFlags:&decreaseFlags];
    }
    
    // If the data source is satisfied, begin with a separator
    [menu addItem:NSMenuItem.separatorItem];
    
    Auto increaseItem = [[NSMenuItem alloc] initWithTitle:DPL_L10N_INCREASE_RESOLUTION
                                                   action:@selector(increaseResolution:)
                                            keyEquivalent:increaseKeyEquivalent ?: @""];
    increaseItem.target = self;
    if(increaseKeyEquivalent != nil)
    {
        increaseItem.keyEquivalentModifierMask = increaseFlags;
    }
    [menu addItem:increaseItem];
    
    Auto decreaseItem = [[NSMenuItem alloc] initWithTitle:DPL_L10N_DECREASE_RESOLUTION
                                                   action:@selector(decreaseResolution:)
                                            keyEquivalent:decreaseKeyEquivalent ?: @""];
    decreaseItem.target = self;
    if(decreaseKeyEquivalent != nil)
    {
        decreaseItem.keyEquivalentModifierMask = decreaseFlags;
    }
    [menu addItem:decreaseItem];
}

- (void)addTrailingStandardItemsToMenu:(NSMenu *)menu
{
    NSParameterAssert(menu);
    
    [menu addItem:NSMenuItem.separatorItem];
    
    Auto prefsItem = [[NSMenuItem alloc] initWithTitle:DPL_L10N_SETTINGS
                                                action:@selector(showPreferences:)
                                         keyEquivalent:@","];
    prefsItem.target = self;
    [menu addItem:prefsItem];
    
    [menu addItem:NSMenuItem.separatorItem];
    
    AutoVar quitText = DPL_L10N_QUIT
#if DEBUG
    quitText = [quitText stringByAppendingString:@" (Debug Version)"];
#endif
    
    Auto quitItem = [[NSMenuItem alloc] initWithTitle:quitText
                                               action:@selector(terminate:)
                                        keyEquivalent:@"q"];
    quitItem.target = self;
    [menu addItem:quitItem];
}

- (void)addCurrentDisplayModesToMenu:(NSMenu *)menu
{
    Auto dataSource = self.dataSource;
    Auto displayModeTitles = [dataSource titlesForCurrentDisplayMode];
    if(displayModeTitles.count == 0) { return; }
    
    for(NSString *displayModeTitle in displayModeTitles)
    {
        Auto item = [[NSMenuItem alloc] initWithTitle:displayModeTitle action:nil keyEquivalent:@""];
        item.enabled = NO;
        [menu addItem:item];
    }
    
    [menu addItem:NSMenuItem.separatorItem];
}

#pragma mark - Actions

- (void)showPreferences:(nullable id)sender
{
    Auto delegate = self.delegate;
    if([delegate respondsToSelector:@selector(menuControllerShouldShowPreferences:)])
    {
        [delegate menuControllerShouldShowPreferences:self];
    }
}

- (void)terminate:(nullable id)sender
{
    Auto delegate = self.delegate;
    if([delegate respondsToSelector:@selector(menuControllerShouldTerminate:)])
    {
        [delegate menuControllerShouldTerminate:self];
    }
}

- (void)selectDisplayMode:(nullable NSMenuItem *)sender
{
    Auto delegate = self.delegate;
    if([delegate respondsToSelector:@selector(menuController:didSelectDisplayModeAtIndexPath:)])
    {
        Auto indexPath = (NSIndexPath *)sender.representedObject;
        [delegate menuController:self didSelectDisplayModeAtIndexPath:indexPath];
    }
}

- (void)increaseResolution:(nullable NSMenuItem *)sender
{
    Auto delegate = self.delegate;
    if([delegate respondsToSelector:@selector(menuControllerShouldIncreaseResolution:)])
    {
        [delegate menuControllerShouldIncreaseResolution:self];
    }
}

- (void)decreaseResolution:(nullable NSMenuItem *)sender
{
    Auto delegate = self.delegate;
    if([delegate respondsToSelector:@selector(menuControllerShouldDecreaseResolution:)])
    {
        [delegate menuControllerShouldDecreaseResolution:self];
    }
}

#pragma mark - NSMenuDelegate

- (void)menuNeedsUpdate:(NSMenu *)menu
{
    [self reloadMenu:menu];
}

@end
