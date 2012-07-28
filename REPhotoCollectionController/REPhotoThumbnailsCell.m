//
//  REPhotoThumbnailsCell.m
//  REPhotoCollectionControllerExample
//
//  Created by Roman Efimov on 7/27/12.
//  Copyright (c) 2012 Roman Efimov. All rights reserved.
//

#import "REPhotoThumbnailsCell.h"
#import "EGOImageButton.h"
#import "ThumbnailView.h"

@implementation REPhotoThumbnailsCell

@synthesize thumbnailViewClass = _thumbnailViewClass;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier thumbnailViewClass:(Class)thumbnailViewClass
{
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _thumbnailViewClass = thumbnailViewClass;
        for (int i=0; i < 4; i++) {
            REPhotoThumbnailView *thumbnailView = [[[_thumbnailViewClass class] alloc] initWithFrame:CGRectMake(6+(72 * i + 6*i), 6, 72, 72)];
            [thumbnailView setHidden:YES];
            thumbnailView.tag = i;
            [self addSubview:thumbnailView];
            
            photos = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)removeAllPhotos
{
    [photos removeAllObjects];
}

- (void)addPhoto:(NSObject<REPhotoObjectProtocol> *)photo
{
    [photos addObject:photo];
}

- (void)refresh
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[REPhotoThumbnailView class]]) {
            REPhotoThumbnailView *thumbnailView = (REPhotoThumbnailView *)view;
            if (thumbnailView.tag < [photos count]) {
                [thumbnailView setHidden:NO];
                if ([thumbnailView respondsToSelector:@selector(setPhoto:)]) {
                    [thumbnailView setPhoto:[photos objectAtIndex:thumbnailView.tag]];
                }
            }
        }
    }
}


@end
