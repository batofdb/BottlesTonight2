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
#import "DetailViewController.h"

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
    // When view appears grab first 20 objects from API if none exist
    if (self.clubs.count == 0) {
        [self getAPIData];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ClubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Club *club = self.clubs[indexPath.row];

    //cell.backgroundImageView.image = [UIImage imageNamed:@"party.jpg"];


    cell.textLabel.backgroundColor = [UIColor clearColor];

    // Would use SDWebImage for async download and cache if other cocoapods were allowed

    // Check to see if image is stored in object if not async download
    if (!club.imageView.image) {
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:club.imageURLString]
                                                completionHandler:^(NSData *data, NSURLResponse *response,
                                                                    NSError *error) {
                                                    if (!error) {

                                                        UIImage *image = [UIImage imageWithData:data];

                                                        //Store image to object
                                                        [club.imageView setImage:image];

                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            ClubTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

                                                            cell.backgroundImageView.image = club.imageView.image;

                                                            // Refresh cell
                                                            [cell setNeedsDisplay];
                                                        });

                                                    } else {
                                                        //Error Handling

                                                        cell.backgroundImageView.image = [UIImage imageNamed:@"party.jpg"];
                                                    }
                                                }];

        [dataTask resume];
    } else {
        // If image exists, use it
        // This allows to reuse image data instead of continuously downloading image everytime
        // user scrolls
        cell.backgroundImageView.image = club.imageView.image;
    }

    cell.clubNameLabel.text = club.photoName;
    cell.clubDetailLabel.text = [NSString stringWithFormat:@"%@ - SS %@",club.camera, club.shutterSpeed];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.clubs.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DetailSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

        DetailViewController *vc = segue.destinationViewController;
        vc.club = self.clubs[indexPath.row];
    }


}



#pragma mark - Networking Layer

- (void)getAPIData {
    NSString *consumerKey = @"ysRYFftaURMrjlpsYw0VFQhTQNrReJLBNMItfu4o";
    NSString *baseURLString = @"https://api.500px.com/v1/photos?feature=popular";

    NSDictionary *parameters = @{@"image_size": @"3",
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
