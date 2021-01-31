//
//  DPLDisplayViewController.mm
//  DPLPreferences
//
//  Created by Marcel Dierkes on 28.12.20.
//

#import "DPLDisplayViewController.h"

namespace DPL::Column
{
constexpr NSUserInterfaceItemIdentifier Resolution = @"resolution";
constexpr NSUserInterfaceItemIdentifier IsRetina = @"isRetina";
constexpr NSUserInterfaceItemIdentifier IsCurrent = @"isCurrent";
constexpr NSUserInterfaceItemIdentifier Attributes = @"attributes";
constexpr NSUserInterfaceItemIdentifier Cell = @"cell";
constexpr NSUserInterfaceItemIdentifier ImageCell = @"imageCell";
}

@interface DPLDisplayViewController ()
@property (nonatomic, readonly, nullable) DPLDisplay *display;
@end

@implementation DPLDisplayViewController

+ (NSStoryboardSceneIdentifier)identifier
{
    return @"DisplayViewController";
}

- (void)viewDidAppear
{
    [super viewDidAppear];
    
    auto window = self.view.window;
    window.subtitle = self.display.localizedName;
}

- (DPLDisplay *)display
{
    return static_cast<DPLDisplay *>(self.representedObject);
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
    [self.tableView reloadData];
}

- (IBAction)setSelectedAsCurrentDisplayResolution:(nullable id)sender
{
    NSInteger selectedRow = self.tableView.clickedRow;
    if([sender isKindOfClass:[NSButton class]])
    {
        selectedRow = self.tableView.selectedRow;
    }
    
    if(selectedRow < 0) { return; }
    
    auto display = self.display;
    auto displayMode = display.displayModes[selectedRow];
    display.currentDisplayMode = displayMode;
    [display applyCurrentDisplayMode];
    
    [self.tableView reloadData];
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.display.displayModes.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return self.display.displayModes[row];
}

#pragma mark - NSTableViewDelegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    auto displayMode = self.display.displayModes[row];
    
    if([tableColumn.identifier isEqualToString:DPL::Column::Resolution])
    {
        auto cell = [tableView makeViewWithIdentifier:DPL::Column::Cell owner:self];
        auto textField = static_cast<NSTextField *>(cell.subviews.firstObject);
        textField.stringValue = displayMode.localizedNameWithoutAttributes;
        textField.font = [NSFont monospacedDigitSystemFontOfSize:textField.font.pointSize
                                                          weight:NSFontWeightRegular];
        return cell;
    }
    else if([tableColumn.identifier isEqualToString:DPL::Column::IsCurrent])
    {
        auto cell = [tableView makeViewWithIdentifier:DPL::Column::ImageCell owner:self];
        auto imageView = static_cast<NSImageView *>(cell.subviews.firstObject);
        auto checkImage = [NSImage imageWithSystemSymbolName:@"checkmark.circle"
                                    accessibilityDescription:nil];
        imageView.image = self.display.currentDisplayMode == displayMode ? checkImage : nil;
        
        imageView.toolTip = NSLocalizedString(@"The current display resolution", @"The current display resolution");
        tableColumn.headerToolTip = imageView.toolTip;
        
        return cell;
    }
    else if([tableColumn.identifier isEqualToString:DPL::Column::IsRetina])
    {
        auto cell = [tableView makeViewWithIdentifier:DPL::Column::ImageCell owner:self];
        auto imageView = static_cast<NSImageView *>(cell.subviews.firstObject);
        auto retinaImage = [NSImage imageWithSystemSymbolName:@"eye"
                                     accessibilityDescription:nil];
        imageView.image = [displayMode isRetinaResolution] ? retinaImage : nil;
        
        imageView.toolTip = NSLocalizedString(@"High resolution", @"High resolution");
        tableColumn.headerToolTip = imageView.toolTip;
        
        return cell;
    }
    return nil;
}

@end
