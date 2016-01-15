//
//  User.m
//  BottlesTonight2
//
//  Created by Francis Bato on 1/13/16.
//  Copyright © 2016 FrancisBato. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initUserWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.username = dictionary[@"username"];
        self.firstName = dictionary[@"firstname"];
        self.lastName = dictionary[@"lastname"];
        self.city = dictionary[@"city"];
        self.country = dictionary[@"country"];
        self.userpic_url = dictionary[@"userpic_url"];
        self.userpic = [UIImageView new];
    }

    return self;
}

@end
