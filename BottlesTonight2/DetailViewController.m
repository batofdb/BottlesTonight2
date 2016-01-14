//
//  DetailViewController.m
//  BottlesTonight2
//
//  Created by Francis Bato on 1/13/16.
//  Copyright © 2016 FrancisBato. All rights reserved.
//

#import "DetailViewController.h"
#import "User.h"
#import "Club.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageTest;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.imageTest.image = self.club.imageView.image;
    //self.imageTest.image = [UIImage imageNamed:@"party.jpg"];
}


@end
