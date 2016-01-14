//
//  Clubs.h
//  BottlesTonight2
//
//  Created by Francis Bato on 1/13/16.
//  Copyright © 2016 FrancisBato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import <UIKit/UIKit.h>

@interface Club : NSObject

@property (nonatomic) NSString *imageURLString;
@property (nonatomic) NSString *photoName;
@property (nonatomic) NSString *camera;
@property (nonatomic) NSString *shutterSpeed;
@property (nonatomic) double rating;
@property (nonatomic) double longitude;
@property (nonatomic) double latitude;
@property (nonatomic) User *user;
@property (nonatomic) UIImageView *imageView;

+ (NSArray *)retrieveTransactionsWithResponse:(NSDictionary *)response;

@end
