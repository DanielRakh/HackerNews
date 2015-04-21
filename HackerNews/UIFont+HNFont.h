//
//  UIFont+HNFont.h
//  HackerNews
//
//  Created by Daniel on 4/21/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TypeWeight) {
    TypeWeightRegular,
    TypeWeightSemibold,
    TypeWeightBold
};

@interface UIFont (HNFont)

+ (UIFont *)proximaNovaWithWeight:(TypeWeight)weight size:(CGFloat)size;

@end
