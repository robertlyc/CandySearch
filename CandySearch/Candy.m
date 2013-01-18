//
//  Candy.m
//  CandySearch
//
//  Created by RoBeRt on 13-1-18.
//  Copyright (c) 2013年 RoBeRt. All rights reserved.
//

#import "Candy.h"

@implementation Candy
@synthesize category = _category;
@synthesize name = _name;

+ (id)candyOfCategory:(NSString *)category name:(NSString *)name{
    Candy *newCandy = [[self alloc] init];
    newCandy.category = category;
    newCandy.name = name;
    return newCandy;
}

@end
