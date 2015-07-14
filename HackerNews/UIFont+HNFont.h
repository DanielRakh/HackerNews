//
//  UIFont+HNFont.h
//  HackerNews
//
//  Created by Daniel on 4/21/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PNTypeWeight) {
    PNTypeWeightRegular,
    PNTypeWeightSemibold,
    PNTypeWeightBold
};

typedef NS_ENUM(NSUInteger, ANTypeWeight) {
    ANTypeWeightUltralight,
    ANTypeWeightRegular,
    ANTypeWeightMedium,
    ANTypeWeightDemibold,
    ANTypeWeightBold,
    
};



@interface UIFont (HNFont)

+ (UIFont *)proximaNovaWithWeight:(PNTypeWeight)weight size:(CGFloat)size;
+ (UIFont *)avenirNextWithWeight:(ANTypeWeight)weight size:(CGFloat)size;

@end
