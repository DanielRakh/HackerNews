//
//  HNCommentsCellViewModel.m
//  HackerNews
//
//  Created by Daniel on 4/6/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <DateTools/NSDate+DateTools.h>
#import "HNCommentsCellViewModel.h"
#import "HNComment.h"
#import "Utils.h"
#import "UIFont+HNFont.h"
#import "UIColor+HNColorPalette.h"


@interface HNCommentsCellViewModel ()

@property (nonatomic) HNComment *comment;

@property (nonatomic, readwrite) NSAttributedString *origination;
@property (nonatomic, readwrite) NSAttributedString *text;

@end

@implementation HNCommentsCellViewModel


- (instancetype)initWithComment:(HNComment *)comment {
    self = [super init];
    if (self) {

        _comment = comment;
        _origination = [self originationLabelForAuthor:comment.by_ time:comment.time_];
        _text = [self formatCommentHTML:comment.text_];
        _repliesCount = [NSString stringWithFormat:@"%ld Replies", comment.kids.count];
    }
    
    return self;
}

- (NSAttributedString *)formatCommentHTML:(NSString *)uglyHTML {
    
    NSMutableParagraphStyle *pStyle = [NSMutableParagraphStyle new];
    pStyle.lineSpacing = 5.0;
    
    NSAttributedString *convertedHTML = [Utils convertHTMLToAttributedString:uglyHTML];
    NSMutableAttributedString *prettyString = [[NSMutableAttributedString alloc]initWithAttributedString:convertedHTML];
    [prettyString addAttributes: @{
                                   NSFontAttributeName : [UIFont proximaNovaWithWeight:TypeWeightRegular size:14.0],
                                   NSForegroundColorAttributeName : [UIColor darkTextColor], NSParagraphStyleAttributeName : pStyle
                                   } range:NSMakeRange(0, convertedHTML.length)];
    
    return prettyString;
}

- (NSAttributedString *)originationLabelForAuthor:(NSString *)author time:(NSNumber *)time  {
    
    NSAttributedString *authorString = [[NSAttributedString alloc]initWithString:@"drak" attributes:@{NSForegroundColorAttributeName : [UIColor HNOrange]}];
   
    NSAttributedString *timeString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" | %@", [self formattedStringForTime:time]] attributes:@{NSForegroundColorAttributeName : [UIColor HNLightGray]}];
    
    NSMutableAttributedString *combinedStr = [[NSMutableAttributedString alloc] initWithAttributedString:authorString];
    [combinedStr appendAttributedString:timeString];
    
    return combinedStr;
}


- (NSString *)formattedStringForTime:(NSNumber *)time {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time.doubleValue];
    NSString *timeString = date.timeAgoSinceNow;
    return timeString;
}


                                      

@end
