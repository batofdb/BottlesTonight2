//
//  HomeViewController.m
//  BottlesTonight2
//
//  Created by Francis Bato on 1/13/16.
//  Copyright © 2016 FrancisBato. All rights reserved.
//

#import "HomeViewController.h"
#import "ClubTableViewCell.h"
#import <AFNetworking/AFNetworking.h>
#import "Club.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clubs = [NSArray new];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.tabBarController.tabBar.barTintColor = [UIColor clearColor];

}

- (void)viewWillAppear:(BOOL)animated {
    [self getAPIData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

     ClubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    Club *club = self.clubs[indexPath.row];

    cell.backgroundImageView.image = [UIImage imageNamed:@"party.jpg"];

    cell.clubNameLabel.text = club.photoName;
    cell.clubDetailLabel.text = [NSString stringWithFormat:@"%@ - SS %@",club.camera, club.shutterSpeed];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.clubs.count;
}

- (void) getAPIData {
    NSString *consumerKey = @"ysRYFftaURMrjlpsYw0VFQhTQNrReJLBNMItfu4o";
    NSString *baseURLString = @"https://api.500px.com/v1/photos?feature=popular";

    NSDictionary *parameters = @{@"image_size": @"4",
                                 @"consumer_key": consumerKey};

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:baseURLString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);

        self.clubs = [Club retrieveTransactionsWithResponse:responseObject];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });

    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


@end
