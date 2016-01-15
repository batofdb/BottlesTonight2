//
//  DetailBGViewController.m
//  BottlesTonight2
//
//  Created by Francis Bato on 1/14/16.
//  Copyright © 2016 FrancisBato. All rights reserved.
//

#import "DetailBGViewController.h"
#import "Club.h"

@interface DetailBGViewController ()

@end

@implementation DetailBGViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.backgroundImageView.image = self.club.imageView.image;
    self.backgroundImageView.clipsToBounds = YES;
}

@end
