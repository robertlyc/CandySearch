//
//  Candy.h
//  CandySearch
//
//  Created by RoBeRt on 13-1-18.
//  Copyright (c) 2013年 RoBeRt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Candy : NSObject

@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *name;

+ (id)candyOfCategory:(NSString *)category name:(NSString *)name;

@end
