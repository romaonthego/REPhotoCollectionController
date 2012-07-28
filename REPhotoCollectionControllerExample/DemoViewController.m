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
    [datasource addObject:[Photo photoWithURLString:@"http://farm8.staticflickr.com/7264/7648998436_b95eaa582f_q.jpg"
                                               date:[self dateFromString:@"05/01/2010"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://farm8.staticflickr.com/7176/6979154719_2583a0e216_q.jpg"
                                               date:[self dateFromString:@"05/02/2010"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://farm8.staticflickr.com/7264/7648998436_b95eaa582f_q.jpg"
                                               date:[self dateFromString:@"05/03/2010"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://farm8.staticflickr.com/7264/7648998436_b95eaa582f_q.jpg"
                                               date:[self dateFromString:@"05/25/2010"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://farm8.staticflickr.com/7264/7648998436_b95eaa582f_q.jpg"
                                               date:[self dateFromString:@"05/25/2010"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://farm8.staticflickr.com/7264/7648998436_b95eaa582f_q.jpg"
                                               date:[self dateFromString:@"05/25/2010"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://farm8.staticflickr.com/7264/7648998436_b95eaa582f_q.jpg"
                                               date:[self dateFromString:@"05/26/2010"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://farm8.staticflickr.com/7264/7648998436_b95eaa582f_q.jpg"
                                               date:[self dateFromString:@"06/25/2010"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://farm8.staticflickr.com/7264/7648998436_b95eaa582f_q.jpg"
                                               date:[self dateFromString:@"06/23/2010"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://farm8.staticflickr.com/7264/7648998436_b95eaa582f_q.jpg"
                                               date:[self dateFromString:@"07/25/2010"]]];
    return datasource;
}

- (void)testButtonPressed
{
    REPhotoCollectionController *photoCollectionController = [[REPhotoCollectionController alloc] initWithDatasource:[self prepareDatasource]];
    photoCollectionController.title = @"Photos";
    photoCollectionController.thumbnailViewClass = [ThumbnailView class];
    
    [self.navigationController pushViewController:photoCollectionController animated:YES];
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
