//
//  REPhotoThumbnailView.m
//  REPhotoCollectionControllerExample
//
//  Created by Roman Efimov on 7/27/12.
//  Copyright (c) 2012 Roman Efimov. All rights reserved.
//

#import "REPhotoThumbnailView.h"

@implementation REPhotoThumbnailView

@synthesize borderColor = _borderColor;

- (void)setPhoto:(NSObject <REPhotoObjectProtocol> *)photo
{
 
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    
    CGContextSetStrokeColorWithColor(context, _borderColor.CGColor);
    
    CGContextStrokeRect(context, rect);
}


@end
