//
//  REPhotoObjectProtocol.h
//  REPhotoCollectionControllerExample
//
//  Created by Roman Efimov on 7/27/12.
//  Copyright (c) 2012 Roman Efimov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol REPhotoObjectProtocol <NSObject>

@property (nonatomic, strong) NSDate *date;

@optional
@property (nonatomic, strong) NSURL *thumbnailURL;
@property (nonatomic, strong) UIImage *thumbnail;

- (id)initWithThumbnailURL:(NSURL *)thumbnailURL date:(NSDate *)date;

@end
