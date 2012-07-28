//
//  REPhotoThumbnailView.h
//  REPhotoCollectionControllerExample
//
//  Created by Roman Efimov on 7/27/12.
//  Copyright (c) 2012 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REPhotoObjectProtocol.h"
#import "EGOImageButton.h"

@interface REPhotoThumbnailView : UIView

@property (nonatomic, strong) UIColor *borderColor;

- (void)setPhoto:(NSObject <REPhotoObjectProtocol> *)photo;

@end
