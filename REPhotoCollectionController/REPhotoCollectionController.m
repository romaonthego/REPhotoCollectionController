//
//  REPhotoCollectionController.m
//  REPhotoCollectionControllerExample
//
//  Created by Roman Efimov on 7/27/12.
//  Copyright (c) 2012 Roman Efimov. All rights reserved.
//

#import "REPhotoCollectionController.h"
#import "REPhotoThumbnailsCell.h"

@interface REPhotoCollectionController ()

@end

@implementation REPhotoCollectionController

@synthesize datasource = _datasource;
@synthesize groupByDate = _groupByDate;
@synthesize hasLoadMore;
@synthesize thumbnailViewClass = _thumbnailViewClass;

- (REPhotoGroup *)findByMonth:(int)month year:(int)year
{
    for (REPhotoGroup *group in ds) {
        if (group.month == month && group.year == year)
            return group;
    }
    return nil;
}

- (void)reloadData
{
    if (!_groupByDate) {
        REPhotoGroup *group = [[REPhotoGroup alloc] init];
        group.month = 1;
        group.year = 1900;
        [ds removeAllObjects];
        for (NSObject *object in _datasource) {
            [group.items addObject:object];
        }
        [ds addObject:group];
        return;
    }
    NSArray *sorted = [_datasource sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSObject <REPhotoObjectProtocol> *photo1 = obj1;
        NSObject <REPhotoObjectProtocol> *photo2 = obj2;
        return ![photo1.date compare:photo2.date];
    }];
    [ds removeAllObjects];
    for (NSObject *object in sorted) {
        NSObject <REPhotoObjectProtocol> *photo = (NSObject <REPhotoObjectProtocol> *)object;
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit |
                                        NSMonthCalendarUnit | NSYearCalendarUnit fromDate:photo.date];
        NSUInteger month = [components month];
        NSUInteger year = [components year];
        REPhotoGroup *group = [self findByMonth:month year:year];
        if (group == nil) {
            group = [[REPhotoGroup alloc] init];
            group.month = month;
            group.year = year;
            [group.items addObject:photo];
            [ds addObject:group];
        } else {
            [group.items addObject:photo];
        }
    }
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UITableViewController functions

- (void)setDatasource:(NSArray *)datasource
{
    _datasource = datasource;
    [self reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        ds = [[NSMutableArray alloc] init];
        self.groupByDate = YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (id)initWithDatasource:(NSArray *)datasource
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        self.datasource = datasource;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([ds count] == 0) return 0;
    if (!_groupByDate) return 1;
    
    if ([self tableView:self.tableView numberOfRowsInSection:[ds count] - 1] == 0) {
        return [ds count] - 1;
    }
    return [ds count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    REPhotoGroup *group = (REPhotoGroup *)[ds objectAtIndex:section];
    
    if ([ds count] - 1 == section && hasLoadMore) {
        int count = ceil((double) [group.items count] / 4);
        if ([group.items count] < count * 4)
            return count - 1;
    }
    
    return ceil([group.items count] / 4.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"REPhotoThumbnailsCell";
    REPhotoThumbnailsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[REPhotoThumbnailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier thumbnailViewClass:_thumbnailViewClass];
    }
    
    REPhotoGroup *group = (REPhotoGroup *)[ds objectAtIndex:indexPath.section];
    
    int start = indexPath.row * 4;
    int end = start + 4;
    if (end > [group.items count])
        end = [group.items count];
    
    [cell removeAllPhotos];
    for (int i=start; i < end; i++) {
        NSObject <REPhotoObjectProtocol> *photo = [group.items objectAtIndex:i];
        [cell addPhoto:photo];
    }
    [cell refresh];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return !_groupByDate ? 0 : 22;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    REPhotoGroup *group = (REPhotoGroup *)[ds objectAtIndex:section];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%i-%i-1", group.year, group.month]];
    
    [dateFormatter setDateFormat:@"MMMM yyyy"];
    NSString *resultString = [dateFormatter stringFromDate:date];
    return resultString;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    return view;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
