//
//  DPLDisplaysViewController.mm
//  DPLPreferences
//
//  Created by Marcel Dierkes on 27.12.20.
//

#import "DPLDisplaysViewController.h"
#import "DPLPreferenceItem.h"
#import "DPLPreferencesContentViewControllers.h"

namespace DPL::Identifier
{
constexpr NSUserInterfaceItemIdentifier HeaderCell = @"HeaderCell";
constexpr NSUserInterfaceItemIdentifier DataCell = @"DataCell";
}

@interface DPLDisplaysViewController ()
@property (nonatomic) NSArray<DPLPreferenceItem *> *preferenceItems;
@property (nonatomic, readonly) NSSplitViewController *splitViewController;
@end

@implementation DPLDisplaysViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureDisplays];
    
    [self.outlineView reloadData];
    
    [self expandDisplaysGroup];
}

- (void)viewWillAppear
{
    [super viewWillAppear];
    
    [self selectFirstItem];
}

- (NSSplitViewController *)splitViewController
{
    return static_cast<NSSplitViewController *>(self.parentViewController);
}

- (void)configureDisplays
{
    auto displays = [NSMutableArray<DPLPreferenceItem *> new];
    for(DPLDisplay *displayObject in DPLDisplay.allDisplays)
    {
        [displays addObject:[[DPLPreferenceItem alloc] initWithDisplay:displayObject]];
    }
    
    auto displayImage = [NSImage imageWithSystemSymbolName:@"display"
                                  accessibilityDescription:nil];
    
    self.preferenceItems = @[
        [[DPLPreferenceItem alloc] initWithIdentifier:1
                                             headerName:NSLocalizedString(@"Displays", @"Displays")
                                                  image:displayImage
                                               children:[displays copy]],
        [[DPLPreferenceItem alloc] initWithIdentifier:2
                                             headerName:NSLocalizedString(@"Preferences", @"Preferences")
                                                  image:nil
                                               children:@[DPLGeneralPreferencesViewController.preferenceItem]],
    ];
}

- (void)expandDisplaysGroup
{
    for(DPLPreferenceItem *header in self.preferenceItems)
    {
        [self.outlineView expandItem:header];
    }
}

- (void)selectFirstItem
{
    auto outlineView = self.outlineView;
    auto firstItem = self.preferenceItems.firstObject.children.firstObject;
    auto row = [outlineView rowForItem:firstItem];
    [outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:row]
             byExtendingSelection:NO];
}

- (void)showDetailsForPreferenceItem:(DPLPreferenceItem *)preferenceItem
{
    NSParameterAssert(preferenceItem);
    
    auto split = self.splitViewController;
    auto detailItem = split.splitViewItems.lastObject;
    
    Class viewControllerClass = preferenceItem.viewControllerClass;
    if([preferenceItem.representedObject isKindOfClass:[DPLDisplay class]])
    {
        // Show the display details
        if([detailItem.viewController isKindOfClass:[DPLDisplayViewController class]])
        {
            // Update the existing view controller
            detailItem.viewController.representedObject = preferenceItem.representedObject;
        }
        else
        {
            auto controller = [DPLDisplayViewController new];
            controller.representedObject = preferenceItem.representedObject;
            [self setSplitDetailViewController:controller];
        }
    }
    else if(viewControllerClass != nil && ![detailItem isKindOfClass:viewControllerClass])
    {
        auto controller = (__kindof DPLPreferencesContentViewController *)[viewControllerClass new];
        [self setSplitDetailViewController:controller];
    }
}

- (void)setSplitDetailViewController:(__kindof NSViewController *)controller
{
    NSAssert(self.view.window != nil, @"The view must be attached to a window.");
    
    auto split = self.splitViewController;
    auto sidebarItem = split.splitViewItems.firstObject;
    auto detailItem = [NSSplitViewItem splitViewItemWithViewController:controller];
    detailItem.titlebarSeparatorStyle = NSTitlebarSeparatorStyleLine;
    
    split.splitViewItems = @[sidebarItem, detailItem];
}

#pragma mark - NSOutlineViewDataSource

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    // Root
    if(item == nil) { return self.preferenceItems[index]; }
    
    auto preferenceItem = static_cast<DPLPreferenceItem *>(item);
    return  preferenceItem.children[index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    // Root
    if(item == nil) { return YES; }
    
    auto preferenceItem = static_cast<DPLPreferenceItem *>(item);
    return [preferenceItem isHeader];
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    // Root
    if(item == nil) { return self.preferenceItems.count; }
    
    auto preferenceItem = static_cast<DPLPreferenceItem *>(item);
    return preferenceItem.children.count;
}

#pragma mark - NSOutlineViewDelegate

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    auto preferenceItem = static_cast<DPLPreferenceItem *>(item);
    if([preferenceItem isHeader])
    {
        auto header = [outlineView makeViewWithIdentifier:DPL::Identifier::HeaderCell owner:self];
        static_cast<NSTextField *>(header.subviews.firstObject).stringValue = preferenceItem.name;
        return header;
    }
    else
    {
        auto cell = [outlineView makeViewWithIdentifier:DPL::Identifier::DataCell owner:self];
        static_cast<NSImageView *>(cell.subviews.firstObject).image = preferenceItem.image;
        static_cast<NSTextField *>(cell.subviews.lastObject).stringValue = preferenceItem.name;
        return cell;
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    auto preferenceItem = static_cast<DPLPreferenceItem *>(item);
    return ![preferenceItem isHeader];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    auto preferenceItem = static_cast<DPLPreferenceItem *>(item);
    return [preferenceItem isHeader];
}

- (NSTintConfiguration *)outlineView:(NSOutlineView *)outlineView tintConfigurationForItem:(id)item
{
    auto preferenceItem = static_cast<DPLPreferenceItem *>(item);
    return preferenceItem.tintConfiguration;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    auto outlineView = static_cast<NSOutlineView *>(notification.object);
    
    auto row = outlineView.selectedRow;
    if(auto preferenceItem = static_cast<DPLPreferenceItem *>([outlineView itemAtRow:row]))
    {
        [self showDetailsForPreferenceItem:preferenceItem];
    }
}

@end
