//
//  DemoViewController.m
//  REPhotoCollectionControllerExample
//
//  Created by Roman Efimov on 7/27/12.
//  Copyright (c) 2012 Roman Efimov. All rights reserved.
//

#import "DemoViewController.h"
#import "REPhotoCollectionController.h"
#import "Photo.h"
#import "ThumbnailView.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

- (NSDate *)dateFromString:(NSString *)string
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    return [dateFormat dateFromString:string];
}

- (NSMutableArray *)prepareDatasource
{
    NSMutableArray *datasource = [[NSMutableArray alloc] init];
    [datasource addObject:[Photo photoWithURLString:@"http://distilleryimage6.s3.amazonaws.com/5acf0f48d5ac11e1a3461231381315e1_5.jpg"
                                               date:[self dateFromString:@"05/01/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://distilleryimage0.s3.amazonaws.com/622c57d4ced411e1ae7122000a1e86bb_5.jpg"
                                               date:[self dateFromString:@"05/02/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://distilleryimage7.s3.amazonaws.com/1a8f3db4b87811e1ab011231381052c0_5.jpg"
                                               date:[self dateFromString:@"05/03/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://distilleryimage6.s3.amazonaws.com/c0039594b74011e181bd12313817987b_5.jpg"
                                               date:[self dateFromString:@"05/25/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://distilleryimage10.s3.amazonaws.com/b9e61198b69411e180d51231380fcd7e_5.jpg"
                                               date:[self dateFromString:@"05/25/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://distilleryimage3.s3.amazonaws.com/334b13f4b5ae11e1abd612313810100a_5.jpg"
                                               date:[self dateFromString:@"05/25/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://distilleryimage2.s3.amazonaws.com/9ab3ff16b59911e1b00112313800c5e4_5.jpg"
                                               date:[self dateFromString:@"05/26/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://distilleryimage10.s3.amazonaws.com/e02206c8b59511e1be6a12313820455d_5.jpg"
                                               date:[self dateFromString:@"06/25/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://distilleryimage9.s3.amazonaws.com/3b9c9182b53a11e1be6a12313820455d_5.jpg"
                                               date:[self dateFromString:@"06/23/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://distilleryimage6.s3.amazonaws.com/93f1fab2b4b711e192e91231381b3d7a_5.jpg"
                                               date:[self dateFromString:@"07/25/2012"]]];
    return datasource;
}

- (void)testButtonPressed
{
    REPhotoCollectionController *photoCollectionController = [[REPhotoCollectionController alloc] initWithDatasource:[self prepareDatasource]];
    photoCollectionController.title = @"Photos";
    photoCollectionController.thumbnailViewClass = [ThumbnailView class];
    
    [self.navigationController pushViewController:photoCollectionController animated:YES];
}

- (void)showPhotoCollectionController:(NSArray *)datasource
{
    REPhotoCollectionController *photoCollectionController = [[REPhotoCollectionController alloc] initWithDatasource:datasource];
    photoCollectionController.title = @"Photos";
    photoCollectionController.thumbnailViewClass = [ThumbnailView class];
    [self.navigationController pushViewController:photoCollectionController animated:YES];
}

- (void)cameraRollButtonPressed
{
    NSMutableArray *datasource = [[NSMutableArray alloc] init];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    Photo *photo = [[Photo alloc] init];
                    photo.thumbnail = [UIImage imageWithCGImage:result.thumbnail];
                    photo.date = [result valueForProperty:ALAssetPropertyDate];
                    [datasource addObject:photo];
                    NSLog(@"%i", [datasource count]);
                }
            }];
        } else {
            [self performSelectorOnMainThread:@selector(showPhotoCollectionController:) withObject:datasource waitUntilDone:NO];            
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"Failed.");
    }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Demo";
        
        UIButton *testButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        testButton.frame = CGRectMake(10, 10, 300, 44);
        [testButton setTitle:@"Test" forState:UIControlStateNormal];
        [testButton addTarget:self action:@selector(testButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:testButton];
        
        UIButton *cameraRollButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cameraRollButton.frame = CGRectMake(10, 64, 300, 44);
        [cameraRollButton setTitle:@"Camera Roll" forState:UIControlStateNormal];
        [cameraRollButton addTarget:self action:@selector(cameraRollButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cameraRollButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
