//
//  DetailViewController.m
//  BottlesTonight2
//
//  Created by Francis Bato on 1/13/16.
//  Copyright © 2016 FrancisBato. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailBGViewController.h"
#import "User.h"
#import "Club.h"
#import "ScrollContentViewController.h"
#import "DetailUIScrollView.h"


@interface DetailViewController () <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;

// Backgorund view outlets
@property (nonatomic) NSArray *pageTitles;
@property (weak, nonatomic) IBOutlet UIView *bgContentView;

// Scroll view outlets
@property (weak, nonatomic) IBOutlet DetailUIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topScrollContentConstraintOffset;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    // Setup pagevc
    self.pageTitles = @[@"Page1", @"Page2", @"Page3"];
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailBGPageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.view.backgroundColor = [UIColor clearColor];

    // Constrain frame to background
    self.pageViewController.view.frame = CGRectMake(0, 0, self.bgContentView.frame.size.width, self.bgContentView.frame.size.height);
    [self addChildViewController:self.pageViewController];
    [self.bgContentView addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];

    // Calculate offset based on superview frame
    double topOffset = self.view.frame.size.height*.75;
    self.scrollView.topOffset = topOffset;
    self.topScrollContentConstraintOffset.constant = topOffset;
}

- (void)viewDidLayoutSubviews {

    // Set scrollable area
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, (self.scrollContentView.frame.size.height)+(self.view.frame.size.height*.75));

}

- (void)viewWillAppear:(BOOL)animated {

    // Initialize starting vc in page control
    DetailBGViewController *startingVC = (DetailBGViewController *)[self viewControllerAtIndex:0];
    NSArray *viewcontrollers = @[startingVC];
    [self.pageViewController setViewControllers:viewcontrollers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {

    NSUInteger index = ((DetailBGViewController *)viewController).pageIndex;

    if (index == NSNotFound) {
        return nil;
    }

    index++;

    if (index >= [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {

    if (([self.pageTitles count] == 0) || index >= [self.pageTitles count]) {
        return nil;
    }

    // Simulate 3 background pages
    DetailBGViewController *bgVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailBGViewController"];
    bgVC.club = self.club;
    bgVC.pageIndex = index;

    NSLog(@"height: %lf", bgVC.view.frame.size.height);

    return bgVC;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {

    NSUInteger index = ((DetailBGViewController *) viewController).pageIndex;

    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }

    index--;

    return [self viewControllerAtIndex:index];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ScrollEmbedSegue"]) {
        ScrollContentViewController *vc = segue.destinationViewController;
        vc.club = self.club;
    }
}

@end
