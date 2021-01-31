//
//  DPLDisplaysViewController.mm
//  DPLPreferences
//
//  Created by Marcel Dierkes on 27.12.20.
//

#import "DPLDisplaysViewController.h"
#import "DPLDisplayViewModel.h"
#import "DPLDisplayViewController.h"
#import "DPLGeneralPreferencesViewController.h"

namespace DPL::Identifier
{
constexpr NSUserInterfaceItemIdentifier HeaderCell = @"HeaderCell";
constexpr NSUserInterfaceItemIdentifier DataCell = @"DataCell";
}

@interface DPLDisplaysViewController ()
@property (nonatomic) NSArray<DPLDisplayViewModel *> *displayViewModels;
@property (nonatomic, readonly) NSSplitViewController *splitViewController;
@end

@implementation DPLDisplaysViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureDisplays];
    
    [self.outlineView reloadData];
    
    [self expandDisplaysGroup];
    [self selectFirstDisplay];
}

- (NSSplitViewController *)splitViewController
{
    return static_cast<NSSplitViewController *>(self.parentViewController);
}

- (void)configureDisplays
{
    auto displays = [NSMutableArray<DPLDisplayViewModel *> new];
    for(DPLDisplay *displayObject in DPLDisplay.allDisplays)
    {
        [displays addObject:[[DPLDisplayViewModel alloc] initWithDisplay:displayObject]];
    }
    
    auto displayImage = [NSImage imageWithSystemSymbolName:@"display"
                                  accessibilityDescription:nil];
    
    auto prefsTitle = NSLocalizedString(@"General", @"General");
    auto prefs = [[DPLDisplayViewModel alloc] initWithIdentifier:3 name:prefsTitle];
    prefs.image = [NSImage imageWithSystemSymbolName:@"gear"
                                accessibilityDescription:nil];
    prefs.tintColor = NSColor.tertiaryLabelColor;
    
    self.displayViewModels = @[
        [[DPLDisplayViewModel alloc] initWithIdentifier:1
                                             headerName:NSLocalizedString(@"Displays", @"Displays")
                                                  image:displayImage
                                               children:[displays copy]],
        [[DPLDisplayViewModel alloc] initWithIdentifier:2
                                             headerName:NSLocalizedString(@"Preferences", @"Preferences")
                                                  image:nil
                                               children:@[prefs]],
    ];
}

- (void)expandDisplaysGroup
{
    for(DPLDisplayViewModel *header in self.displayViewModels)
    {
        [self.outlineView expandItem:header];
    }
}

- (void)selectFirstDisplay
{
    auto outlineView = self.outlineView;
    auto firstModel = self.displayViewModels.firstObject.children.firstObject;
    auto row = [outlineView rowForItem:firstModel];
    [outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:row]
             byExtendingSelection:NO];
}

- (void)showDetailsForViewModel:(DPLDisplayViewModel *)model
{
    NSParameterAssert(model);
    
    auto split = self.splitViewController;
    auto detailItem = split.splitViewItems.lastObject;
    
    if([model.representedObject isKindOfClass:[DPLDisplay class]])
    {
        // Show the display details
        if([detailItem.viewController isKindOfClass:[DPLDisplayViewController class]])
        {
            // Update the existing view controller
            detailItem.viewController.representedObject = model.representedObject;
        }
        else
        {
            auto identifier = DPLDisplayViewController.identifier;
            NSViewController *controller = [self.storyboard instantiateControllerWithIdentifier:identifier];
            controller.representedObject = model.representedObject;
            [self setSplitDetailViewController:controller];
        }
    }
    else if(model.representedObject == nil)
    {
        // Show the settings
        if(![detailItem.viewController isKindOfClass:[DPLGeneralPreferencesViewController class]])
        {
            auto identifier = DPLGeneralPreferencesViewController.identifier;
            NSViewController *controller = [self.storyboard instantiateControllerWithIdentifier:identifier];
            [self setSplitDetailViewController:controller];
        }
    }
}

- (void)setSplitDetailViewController:(__kindof NSViewController *)controller
{
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
    if(item == nil) { return self.displayViewModels[index]; }
    
    auto model = static_cast<DPLDisplayViewModel *>(item);
    return  model.children[index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    // Root
    if(item == nil) { return YES; }
    
    auto model = static_cast<DPLDisplayViewModel *>(item);
    return [model isHeader];
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    // Root
    if(item == nil) { return self.displayViewModels.count; }
    
    auto model = static_cast<DPLDisplayViewModel *>(item);
    return model.children.count;
}

#pragma mark - NSOutlineViewDelegate

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    auto model = static_cast<DPLDisplayViewModel *>(item);
    if([model isHeader])
    {
        auto header = [outlineView makeViewWithIdentifier:DPL::Identifier::HeaderCell owner:self];
        static_cast<NSTextField *>(header.subviews.firstObject).stringValue = model.name;
        return header;
    }
    else
    {
        auto cell = [outlineView makeViewWithIdentifier:DPL::Identifier::DataCell owner:self];
        static_cast<NSImageView *>(cell.subviews.firstObject).image = model.image;
        static_cast<NSTextField *>(cell.subviews.lastObject).stringValue = model.name;
        return cell;
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    auto model = static_cast<DPLDisplayViewModel *>(item);
    return ![model isHeader];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    auto model = static_cast<DPLDisplayViewModel *>(item);
    return [model isHeader];
}

- (NSTintConfiguration *)outlineView:(NSOutlineView *)outlineView tintConfigurationForItem:(id)item
{
    auto model = static_cast<DPLDisplayViewModel *>(item);
    return model.tintConfiguration;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    auto outlineView = static_cast<NSOutlineView *>(notification.object);
    
    auto row = outlineView.selectedRow;
    if(auto model = static_cast<DPLDisplayViewModel *>([outlineView itemAtRow:row]))
    {
        [self showDetailsForViewModel:model];
    }
}

@end
