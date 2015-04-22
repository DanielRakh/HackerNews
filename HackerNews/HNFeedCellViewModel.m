//
//  HNCellViewModel.m
//  HackerNews
//
//  Created by Daniel on 4/2/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//


#import <DateTools/NSDate+DateTools.h>
#import "UIColor+HNColorPalette.h"
#import "UIFont+HNFont.h"

//View Model
#import "HNCommentsViewModel.h"
#import "HNFeedCellViewModel.h"

// Model
#import "HNStory.h"

@interface HNFeedCellViewModel ()

@property (nonatomic, readwrite) HNStory *story;

@end

@implementation HNFeedCellViewModel

- (instancetype)initWithStory:(HNStory *)story {
    self = [super init];
    if (self) {
        
        _story = story;
        _score = [NSString stringWithFormat:@"%@ Points", story.score_.stringValue];
        _title = [self formattedStringForTitle:story.title_ andURL:story.url_];
        _commentsCount = story.descendants_.stringValue;
        _info = [NSString stringWithFormat: @"by %@ | %@", story.by_, [self formattedStringForTime:story.time_]];
    }
    
    return self;
}

- (HNCommentsViewModel *)commentsViewModel {
    HNCommentsViewModel *viewModel = [[HNCommentsViewModel alloc]initWithStory:self.story];
    return viewModel;
}


#pragma mark - Helper Methods

- (NSString *)formattedStringForTime:(NSNumber *)time {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time.doubleValue];
    NSString *timeString = date.timeAgoSinceNow;
    return timeString;
}

- (NSAttributedString *)formattedStringForTitle:(NSString *)title andURL:(NSString *)url {
    
    NSAttributedString *titleString = [[NSAttributedString alloc]initWithString:title
                                                                     attributes:@{NSForegroundColorAttributeName : [UIColor darkTextColor]}];
    
    NSAttributedString *urlString = [[NSAttributedString alloc]initWithString:
                                     [NSString stringWithFormat:@" (%@)", url.pathComponents[1]] attributes:@{
                                                                            NSForegroundColorAttributeName : [UIColor HNLightGray],
                                                                                NSFontAttributeName : [UIFont proximaNovaWithWeight:TypeWeightSemibold size:12.0],
                                                                            NSBaselineOffsetAttributeName : @1.8}];
    
    NSMutableAttributedString *combinedString = [[NSMutableAttributedString alloc]initWithAttributedString:titleString];
    
    [combinedString appendAttributedString:urlString];
    
    return combinedString;
    

}



@end
