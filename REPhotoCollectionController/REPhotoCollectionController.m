//
// REPhotoCollectionController.m
// REPhotoCollectionController
//
// Copyright (c) 2012 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
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
        REPhotoGroup *group = ^REPhotoGroup *{
            for (REPhotoGroup *group in ds) {
                if (group.month == month && group.year == year)
                    return group;
            }
            return nil;
        }();
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([ds count] == 0) return 0;
    if (!_groupByDate) return 1;
    
    if ([self tableView:self.tableView numberOfRowsInSection:[ds count] - 1] == 0) {
        return [ds count] - 1;
    }
    return [ds count];
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
    
    int startIndex = indexPath.row * 4;
    int endIndex = startIndex + 4;
    if (endIndex > [group.items count])
        endIndex = [group.items count];
    
    [cell removeAllPhotos];
    for (int i = startIndex; i < endIndex; i++) {
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    return view;
}

#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end
