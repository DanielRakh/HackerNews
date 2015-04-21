//
//  UIFont+HNFont.m
//  HackerNews
//
//  Created by Daniel on 4/21/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "UIFont+HNFont.h"

@implementation UIFont (HNFont)

+ (UIFont *)proximaNovaWithWeight:(TypeWeight)weight size:(CGFloat)size {
    
    NSString *fontName;
    
    switch (weight) {
        case TypeWeightRegular:
            fontName = @"ProximaNova-Regular";
            break;
        case TypeWeightBold:
            fontName = @"ProximaNova-Bold";
            break;
        case TypeWeightSemibold:
            fontName = @"ProximaNova-Semibold";
            break;
        default:
            NSLog(@"There was an error setting Proxima Nova");
            break;
    }
    
    return [UIFont fontWithName:fontName size:size];
    
}

@end
