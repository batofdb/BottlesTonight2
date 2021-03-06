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
#import "UIImageView+AFNetworking.h"
#import <DGActivityIndicatorView/DGActivityIndicatorView.h>

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) DGActivityIndicatorView *activityIndicator;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clubs = [NSArray new];

    // Setup activity indicator
    self.activityIndicator = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeDoubleBounce tintColor:[UIColor whiteColor] size:20.0f];
    self.activityIndicator.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    [self.view addSubview:self.activityIndicator];

    // Customize nav bar
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;

    // Customize tab bar
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

    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.clubNameLabel.text = club.photoName;

    NSString *mappedString = @"No Map";

    if (club.latitude != 0 && club.longitude != 0)
        mappedString = @"Mapped";

    cell.clubDetailLabel.text = [NSString stringWithFormat:@"%@ - SS %@ | %@",club.camera, club.shutterSpeed,mappedString];

    // Check if image does not exist, if so async download
    if (!club.imageView.image) {

        //Avoid retain cycle
        __weak ClubTableViewCell *weakCell = cell;

        [weakCell.backgroundImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:club.imageURLString]] placeholderImage: [UIImage imageNamed:@"party.jpg"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {

            weakCell.backgroundImageView.image = image;
            club.imageView.image = image;

            [weakCell setNeedsDisplay];

            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                // Handle Error
            }];
    } else {
        // Use image if it exists
        cell.backgroundImageView.image = club.imageView.image;
    }

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

    [self.activityIndicator startAnimating];

    NSString *consumerKey = @"ysRYFftaURMrjlpsYw0VFQhTQNrReJLBNMItfu4o";
    NSString *baseURLString = @"https://api.500px.com/v1/photos?feature=editors";

    NSDictionary *parameters = @{@"image_size": @"3",
                                 @"consumer_key": consumerKey};

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:baseURLString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);

        self.clubs = [Club retrieveTransactionsWithResponse:responseObject];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.activityIndicator stopAnimating];
        });

    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}


@end
