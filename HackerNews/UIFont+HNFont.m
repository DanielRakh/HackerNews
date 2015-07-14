//
//  UIFont+HNFont.m
//  HackerNews
//
//  Created by Daniel on 4/21/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "UIFont+HNFont.h"

@implementation UIFont (HNFont)

+ (UIFont *)proximaNovaWithWeight:(PNTypeWeight)weight size:(CGFloat)size {
    
    NSString *fontName;
    
    switch (weight) {
        case PNTypeWeightRegular:
            fontName = @"ProximaNova-Regular";
            break;
        case PNTypeWeightBold:
            fontName = @"ProximaNova-Bold";
            break;
        case PNTypeWeightSemibold:
            fontName = @"ProximaNova-Semibold";
            break;
        default:
            NSLog(@"There was an error setting Proxima Nova");
            break;
    }
    
    return [UIFont fontWithName:fontName size:size];
}

+ (UIFont *)avenirNextWithWeight:(ANTypeWeight)weight size:(CGFloat)size {
    
    NSString *fontName;
    
    switch (weight) {
        case ANTypeWeightUltralight:
            fontName = @"AvenirNext-UltraLight";
            break;
        case ANTypeWeightRegular:
            fontName = @"AvenirNext-Regular";
            break;
        case ANTypeWeightMedium:
            fontName = @"AvenirNext-Medium";
            break;
        case ANTypeWeightDemibold:
            fontName = @"AvenirNext-DemiBold";
            break;
        case ANTypeWeightBold:
            fontName = @"AvenirNext-Bold";
            break;
        default:
            NSLog(@"There was an error setting Proxima Nova");
            break;
    }
    
    return [UIFont fontWithName:fontName size:size];
    
    
}

@end
