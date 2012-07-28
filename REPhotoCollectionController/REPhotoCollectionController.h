//
//  REPhotoCollectionController.h
//  REPhotoCollectionControllerExample
//
//  Created by Roman Efimov on 7/27/12.
//  Copyright (c) 2012 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REPhotoObjectProtocol.h"
#import "REPhotoGroup.h"

@interface REPhotoCollectionController : UITableViewController {
    NSMutableArray *ds;
}

@property (nonatomic, readwrite) BOOL hasLoadMore;
@property (nonatomic, strong, setter = setDatasource:) NSArray *datasource;
@property (nonatomic, readwrite) BOOL groupByDate;
@property (nonatomic, readwrite) Class thumbnailViewClass;

- (id)initWithDatasource:(NSArray *)datasource;
- (void)reloadData;

@end
