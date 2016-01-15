//
//  DetailBGViewController.h
//  BottlesTonight2
//
//  Created by Francis Bato on 1/14/16.
//  Copyright © 2016 FrancisBato. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Club;

@interface DetailBGViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property NSUInteger pageIndex;
@property (nonatomic) Club *club;

@end
