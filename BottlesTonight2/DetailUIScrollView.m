//
//  DetailUIScrollView.m
//  BottlesTonight2
//
//  Created by Francis Bato on 1/15/16.
//  Copyright © 2016 FrancisBato. All rights reserved.
//

#import "DetailUIScrollView.h"

@implementation DetailUIScrollView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    NSLog(@"content offset:%lf point:%lf",self.contentOffset.y,point.y);

    if (self.contentOffset.y < 451.0 && point.y < 453.0) {
        return NO;
    } else {
        return YES;
    }
}

@end
