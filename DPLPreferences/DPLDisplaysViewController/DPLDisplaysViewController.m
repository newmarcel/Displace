//
//  DPLDisplaysViewController.m
//  DPLPreferences
//
//  Created by Marcel Dierkes on 27.12.20.
//

#import "DPLDisplaysViewController.h"
#import "DPLDefines.h"
#import "DPLPreferenceItem.h"
#import "DPLPreferencesContentViewControllers.h"

static const NSUserInterfaceItemIdentifier DPLIdentifierHeaderCell = @"HeaderCell";
static const NSUserInterfaceItemIdentifier DPLIdentifierDataCell = @"DataCell";

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
    return (NSSplitViewController *)self.parentViewController;
}

- (void)reloadData
{
    [self configureDisplays];
    [self.outlineView reloadData];
    
    [self expandDisplaysGroup];
}

- (void)configureDisplays
{
    Auto displays = [NSMutableArray<DPLPreferenceItem *> new];
    for(DPLDisplay *displayObject in DPLDisplay.allDisplays)
    {
        Auto item = [[DPLPreferenceItem alloc] initWithDisplay:displayObject];
        item.image = displayObject.image;
        item.viewControllerClass = [DPLDisplayViewController class];
        [displays addObject:item];
    }
    
    Auto displayImage = [NSImage imageWithSystemSymbolName:@"display"
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
    Auto outlineView = self.outlineView;
    Auto firstItem = self.preferenceItems.firstObject.children.firstObject;
    Auto row = [outlineView rowForItem:firstItem];
    [outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:row]
             byExtendingSelection:NO];
}

- (void)showDetailsForPreferenceItem:(DPLPreferenceItem *)preferenceItem
{
    NSParameterAssert(preferenceItem);
    
    Auto split = self.splitViewController;
    Auto detailItem = split.splitViewItems.lastObject;
    
    Class viewControllerClass = preferenceItem.viewControllerClass;
    if(viewControllerClass != nil)
    {
        if([detailItem isKindOfClass:viewControllerClass])
        {
            // Update the existing view controller
            id representedObject = preferenceItem.representedObject;
            if(representedObject != nil)
            {
                detailItem.viewController.representedObject = representedObject;
            }
        }
        else
        {
            // Load a new view controller
            Auto controller = (__kindof DPLPreferencesContentViewController *)[viewControllerClass new];
            id representedObject = preferenceItem.representedObject;
            if(representedObject != nil)
            {
                controller.representedObject = representedObject;
            }
            [self setSplitDetailViewController:controller];
        }
    }
}

- (void)setSplitDetailViewController:(__kindof NSViewController *)controller
{
    NSAssert(self.view.window != nil, @"The view must be attached to a window.");
    
    Auto split = self.splitViewController;
    Auto sidebarItem = split.splitViewItems.firstObject;
    Auto detailItem = [NSSplitViewItem splitViewItemWithViewController:controller];
    detailItem.titlebarSeparatorStyle = NSTitlebarSeparatorStyleLine;
    
    split.splitViewItems = @[sidebarItem, detailItem];
}

#pragma mark - NSOutlineViewDataSource

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    // Root
    if(item == nil) { return self.preferenceItems[index]; }
    
    Auto preferenceItem = (DPLPreferenceItem *)item;
    return  preferenceItem.children[index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    // Root
    if(item == nil) { return YES; }
    
    Auto preferenceItem = (DPLPreferenceItem *)item;
    return [preferenceItem isHeader];
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    // Root
    if(item == nil) { return self.preferenceItems.count; }
    
    Auto preferenceItem = (DPLPreferenceItem *)item;
    return preferenceItem.children.count;
}

#pragma mark - NSOutlineViewDelegate

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    Auto preferenceItem = (DPLPreferenceItem *)item;
    if([preferenceItem isHeader])
    {
        Auto header = [outlineView makeViewWithIdentifier:DPLIdentifierHeaderCell owner:self];
        Auto textField = (NSTextField *)header.subviews.firstObject;
        textField.stringValue = preferenceItem.name;
        return header;
    }
    else
    {
        Auto cell = [outlineView makeViewWithIdentifier:DPLIdentifierDataCell owner:self];
        Auto imageView = (NSImageView *)cell.subviews.firstObject;
        imageView.image = preferenceItem.image;
        Auto textField = (NSTextField *)cell.subviews.lastObject;
        textField.stringValue = preferenceItem.name;
        return cell;
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    Auto preferenceItem = (DPLPreferenceItem *)item;
    return ![preferenceItem isHeader];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    Auto preferenceItem = (DPLPreferenceItem *)item;
    return [preferenceItem isHeader];
}

- (NSTintConfiguration *)outlineView:(NSOutlineView *)outlineView tintConfigurationForItem:(id)item
{
    Auto preferenceItem = (DPLPreferenceItem *)item;
    return preferenceItem.tintConfiguration;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    Auto outlineView = (NSOutlineView *)notification.object;
    
    Auto row = outlineView.selectedRow;
    Auto preferenceItem = (DPLPreferenceItem *)[outlineView itemAtRow:row];
    if(preferenceItem != nil)
    {
        [self showDetailsForPreferenceItem:preferenceItem];
    }
}

@end
