//
//  DPLMenuController.mm
//  Displace
//
//  Created by Marcel Dierkes on 19.12.20.
//

#import "DPLMenuController.h"

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
    auto menu = [[NSMenu alloc] initWithTitle:NSLocalizedString(@"Displays", @"Displays")];
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
    
    const auto dataSource = self.dataSource;
    const auto displayCount = [dataSource numberOfDisplays];
    for(NSInteger displayIndex = 0; displayIndex < displayCount; displayIndex++)
    {
        const auto title = [dataSource titleForDisplayAtIndex:displayIndex];
        auto item = [[NSMenuItem alloc] initWithTitle:title action:nil keyEquivalent:@""];
        item.image = [NSImage imageWithSystemSymbolName:@"display" accessibilityDescription:nil];
        [self addDisplayModeMenuForDisplayAtIndex:displayIndex toItem:item];
        [menu addItem:item];
    }
    
    [self addTrailingStandardItemsToMenu:menu];
}

- (void)addDisplayModeMenuForDisplayAtIndex:(NSInteger)displayIndex toItem:(NSMenuItem *)item
{
    NSParameterAssert(item);
    
    const auto dataSource = self.dataSource;
    const auto menuTitle = [dataSource titleForDisplayAtIndex:displayIndex];
    auto menu = [[NSMenu alloc] initWithTitle:menuTitle];
    
    const auto currentDisplayModeIndex = [dataSource currentDisplayModeIndexForDisplayAtIndex:displayIndex];

    const auto displayModeCount = [dataSource numberOfDisplayModesForDisplayAtIndex:displayIndex];
    for(NSInteger index = 0; index < displayModeCount; index++)
    {
        auto indexPath = [NSIndexPath indexPathForItem:index inSection:displayIndex];
        const auto title = [dataSource titleForDisplayModeAtIndexPath:indexPath];
        auto subItem = [[NSMenuItem alloc] initWithTitle:title
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

- (void)addTrailingStandardItemsToMenu:(NSMenu *)menu
{
    NSParameterAssert(menu);
    
    [menu addItem:NSMenuItem.separatorItem];
    
    auto prefsItem = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Preferences…", @"Preferences…")
                                                action:@selector(showPreferences:)
                                         keyEquivalent:@","];
    prefsItem.target = self;
    [menu addItem:prefsItem];
    
    [menu addItem:NSMenuItem.separatorItem];
    
    auto quitItem = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Quit Displace", @"Quit Displace")
                                               action:@selector(terminate:)
                                        keyEquivalent:@"q"];
    quitItem.target = self;
    [menu addItem:quitItem];
}

- (IBAction)showPreferences:(nullable id)sender
{
    auto delegate = self.delegate;
    if([delegate respondsToSelector:@selector(menuControllerShouldShowPreferences:)])
    {
        [delegate menuControllerShouldShowPreferences:self];
    }
}

- (IBAction)terminate:(id)sender
{
    auto delegate = self.delegate;
    if([delegate respondsToSelector:@selector(menuControllerShouldTerminate:)])
    {
        [delegate menuControllerShouldTerminate:self];
    }
}

- (IBAction)selectDisplayMode:(nullable NSMenuItem *)sender
{
    auto delegate = self.delegate;
    if([delegate respondsToSelector:@selector(menuController:didSelectDisplayModeAtIndexPath:)])
    {
        auto indexPath = static_cast<NSIndexPath *>(sender.representedObject);
        [delegate menuController:self didSelectDisplayModeAtIndexPath:indexPath];
    }
}

#pragma mark - NSMenuDelegate

- (void)menuNeedsUpdate:(NSMenu *)menu
{
    [self reloadMenu:menu];
}

@end
