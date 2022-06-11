//
//  DPLDisplayViewController.m
//  DPLPreferences
//
//  Created by Marcel Dierkes on 28.12.20.
//

#import "DPLDisplayViewController.h"
#import "DPLDefines.h"
#import "DPLPreferencesLocalizedStrings.h"
#import "DPLPreferenceItem.h"

static const NSUserInterfaceItemIdentifier DPLColumnResolution = @"resolution";
static const NSUserInterfaceItemIdentifier DPLColumnIsRetina = @"isRetina";
static const NSUserInterfaceItemIdentifier DPLColumnIsCurrent = @"isCurrent";
static const NSUserInterfaceItemIdentifier DPLColumnAttributes = @"attributes";
static const NSUserInterfaceItemIdentifier DPLColumnCell = @"cell";
static const NSUserInterfaceItemIdentifier DPLColumnImageCell = @"imageCell";

@interface DPLDisplayViewController ()
@property (nonatomic, readonly, nullable) DPLDisplay *display;
@end

@implementation DPLDisplayViewController

+ (DPLPreferenceItem *)preferenceItem
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Unused" userInfo:nil];
}

- (NSString *)preferredTitle
{
    return self.display.localizedName;
}

- (DPLDisplay *)display
{
    return (DPLDisplay *)self.representedObject;
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
    
    Auto display = self.display;
    Auto displayMode = display.displayModes[selectedRow];
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
    Auto displayMode = self.display.displayModes[row];
    
    if([tableColumn.identifier isEqualToString:DPLColumnResolution])
    {
        Auto cell = [tableView makeViewWithIdentifier:DPLColumnCell owner:self];
        Auto textField = (NSTextField *)cell.subviews.firstObject;
        textField.stringValue = displayMode.localizedNameWithoutAttributes;
        textField.font = [NSFont monospacedDigitSystemFontOfSize:textField.font.pointSize
                                                          weight:NSFontWeightRegular];
        return cell;
    }
    else if([tableColumn.identifier isEqualToString:DPLColumnIsCurrent])
    {
        Auto cell = [tableView makeViewWithIdentifier:DPLColumnImageCell owner:self];
        Auto imageView = (NSImageView *)cell.subviews.firstObject;
        Auto checkImage = [NSImage imageWithSystemSymbolName:@"checkmark.circle"
                                    accessibilityDescription:nil];
        imageView.image = self.display.currentDisplayMode == displayMode ? checkImage : nil;
        
        imageView.toolTip = DPL_L10N_CURRENT_DISPLAY_RESOLUTION_TOOLTIP;
        tableColumn.headerToolTip = imageView.toolTip;
        
        return cell;
    }
    else if([tableColumn.identifier isEqualToString:DPLColumnIsRetina])
    {
        Auto cell = [tableView makeViewWithIdentifier:DPLColumnImageCell owner:self];
        Auto imageView = (NSImageView *)cell.subviews.firstObject;
        Auto retinaImage = [NSImage imageWithSystemSymbolName:@"eye"
                                     accessibilityDescription:nil];
        imageView.image = [displayMode isRetinaResolution] ? retinaImage : nil;
        
        imageView.toolTip = DPL_L10N_HIGH_RESOLUTION_TOOLTIP;
        tableColumn.headerToolTip = imageView.toolTip;
        
        return cell;
    }
    return nil;
}

@end
