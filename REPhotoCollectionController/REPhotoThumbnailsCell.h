//
//  REPhotoThumbnailsCell.h
//  REPhotoCollectionControllerExample
//
//  Created by Roman Efimov on 7/27/12.
//  Copyright (c) 2012 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REPhotoThumbnailView.h"
#import "REPhotoObjectProtocol.h"

@interface REPhotoThumbnailsCell : UITableViewCell {
    NSMutableArray *photos;
}

@property (nonatomic, readwrite) Class thumbnailViewClass;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier thumbnailViewClass:(Class)thumbnailViewClass;
- (void)removeAllPhotos;
- (void)addPhoto:(NSObject <REPhotoObjectProtocol> *)photo;
- (void)refresh;

@end
