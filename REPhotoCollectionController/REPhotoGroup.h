//
//  REPhotoGroup.h
//  REPhotoCollectionControllerExample
//
//  Created by Roman Efimov on 7/27/12.
//  Copyright (c) 2012 Roman Efimov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface REPhotoGroup : NSObject

@property (nonatomic, readwrite) NSUInteger month;
@property (nonatomic, readwrite) NSUInteger year;
@property (nonatomic, strong) NSMutableArray *items;

@end
