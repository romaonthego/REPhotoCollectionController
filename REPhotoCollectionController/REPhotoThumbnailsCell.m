//
// REPhotoThumbnailsCell.m
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

#import "REPhotoThumbnailsCell.h"

@implementation REPhotoThumbnailsCell

@synthesize thumbnailViewClass = _thumbnailViewClass;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier thumbnailViewClass:(Class)thumbnailViewClass
{
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _thumbnailViewClass = thumbnailViewClass;
        _photos = [[NSMutableArray alloc] init];
        for (int i=0; i < 4; i++) {
            REPhotoThumbnailView *thumbnailView = [[[_thumbnailViewClass class] alloc] initWithFrame:CGRectMake(6+(72 * i + 6 * i), 6, 72, 72)];
            [thumbnailView setHidden:YES];
            thumbnailView.tag = i;
            [self addSubview:thumbnailView];
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
    [_photos removeAllObjects];
}

- (void)addPhoto:(NSObject<REPhotoObjectProtocol> *)photo
{
    [_photos addObject:photo];
}

- (void)refresh
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[REPhotoThumbnailView class]]) {
            REPhotoThumbnailView *thumbnailView = (REPhotoThumbnailView *)view;
            if (thumbnailView.tag < [_photos count]) {
                [thumbnailView setHidden:NO];
                if ([thumbnailView respondsToSelector:@selector(setPhoto:)]) {
                    [thumbnailView setPhoto:[_photos objectAtIndex:thumbnailView.tag]];
                }
            } else {
                [thumbnailView setHidden:YES];
            }
        }
    }
}


@end
