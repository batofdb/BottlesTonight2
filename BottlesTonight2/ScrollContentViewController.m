//
//  ScrollContentViewController.m
//  BottlesTonight2
//
//  Created by Francis Bato on 1/14/16.
//  Copyright © 2016 FrancisBato. All rights reserved.
//

#import "ScrollContentViewController.h"
#import <FXBlurView.h>
#import "Club.h"
#import <MapKit/MapKit.h>
#import "UIImageView+AFNetworking.h"

@interface ScrollContentViewController ()

// Labels
@property (weak, nonatomic) IBOutlet UILabel *clubTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *shutterSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameAndLocationLabel;

// Images
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;

// Mapview
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

// Contraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutGuideOffset;

@end

@implementation ScrollContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Setup map annotation
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(self.club.latitude, self.club.longitude);
    annotation.title = [NSString stringWithFormat:@"Rating: %lf",self.club.rating];
    annotation.subtitle = self.club.camera;

    // Setup zoom region
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    region.span = span;
    region.center = annotation.coordinate;

    // Add map notation to mapview
    [self.mapView addAnnotation:annotation];
    [self.mapView setRegion:region animated:TRUE];
    [self.mapView regionThatFits:region];

    self.view.backgroundColor = [UIColor clearColor];

    // Add blur effect
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.view addSubview:blurEffectView];
    [self.view sendSubviewToBack:blurEffectView];

    // Populate scrollview content labels
    self.clubTitleLabel.text = self.club.photoName;
    self.shutterSpeedLabel.text = [NSString stringWithFormat:@"Shutter Speed | %@",self.club.shutterSpeed];
    self.ratingLabel.text = [NSString stringWithFormat:@"Rating : %lf",self.club.rating];
    self.descriptionLabel.text = self.club.desc;

    self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.bounds.size.height/2;
    self.userProfileImageView.clipsToBounds = YES;

    self.usernameLabel.text = self.club.user.username;
    self.nameAndLocationLabel.text = [NSString stringWithFormat:@"%@ %@ | %@, %@",self.club.user.firstName,self.club.user.lastName,self.club.user.city,self.club.user.country];

    [self getUserProfilePic];
}

#pragma mark - DL Profile Picture

-(void)getUserProfilePic {

    if (!self.club.user.userpic.image) {

        [self.userProfileImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.club.user.userpic_url]] placeholderImage: [UIImage imageNamed:@"party.jpg"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {

            self.userProfileImageView.image = image;
            self.club.user.userpic.image = image;

            [self.userProfileImageView setNeedsDisplay];

        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            // Handle Error
        }];

    } else {
        // If image exists, use it
        // This allows to reuse image data instead of continuously downloading image everytime
        // user scrolls
        self.userProfileImageView.image = self.club.user.userpic.image;
    }
}

@end
