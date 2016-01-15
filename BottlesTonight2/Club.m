//
//  Clubs.m
//  BottlesTonight2
//
//  Created by Francis Bato on 1/13/16.
//  Copyright © 2016 FrancisBato. All rights reserved.
//

#import "Club.h"
#import "User.h"

@implementation Club

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.imageURLString = dictionary[@"image_url"];
        self.photoName = dictionary[@"name"];

        if (![dictionary[@"description"] isEqual:[NSNull null]]) {
            self.desc = dictionary[@"description"];
        } else {
            self.desc = @"N/A";
        }

        self.imageView = [UIImageView new];

        if (![dictionary[@"camera"] isEqual:[NSNull null]]) {
            self.camera = dictionary[@"camera"];
        } else {
            self.camera = @"N/A";
        }

        if (![dictionary[@"shutter_speed"] isEqual:[NSNull null]]) {
            self.shutterSpeed = dictionary[@"shutter_speed"];
        } else {
            self.shutterSpeed = @"N/A";
        }

        self.rating = [dictionary[@"rating"] doubleValue];

        if (![dictionary[@"longitude"] isEqual:[NSNull null]]) {
            self.longitude = [dictionary[@"longitude"] doubleValue];
            self.latitude = [dictionary[@"latitude"] doubleValue];
        }

        User *user = [User new];
        user.username = dictionary[@"user"][@"username"];
        user.firstName = dictionary[@"user"][@"firstname"];
        user.lastName = dictionary[@"user"][@"lastname"];

        if (![dictionary[@"user"][@"city"] isEqual:[NSNull null]]) {
            user.city = dictionary[@"user"][@"city"];
            user.country = dictionary[@"user"][@"country"];
        } else {
            user.city = @"Somewhere";
            user.country = @"Worldwide";
        }

        user.userpic_url = dictionary[@"user"][@"userpic_url"];
        user.userpic = [UIImageView new];

        self.user = user;
    }
    
    return self;
}


+ (NSArray *)retrieveTransactionsWithResponse:(NSDictionary *)response {

    NSArray *results = response[@"photos"];
    NSMutableArray *clubs = [NSMutableArray new];

    for (NSDictionary *dict in results) {
        Club *club = [[Club alloc] initWithDictionary:dict];
        [clubs addObject:club];
    }

    return clubs;

}

@end
