//
//  Utils.m
//  hn
//
//  Created by Marcin Kmieć on 30.10.2014.
//  Copyright (c) 2014 Marcin. All rights reserved.
//

#import "HNUtilities.h"
#import <UIKit/UIKit.h>
#import "NSString+RemoveTag.h"
#import "UIFont+HNFont.h"
#import "UIColor+HNColorPalette.h"
#import <DateTools/NSDate+DateTools.h>

@implementation HNUtilities




#pragma mark - Strings

+ (NSString *)timeAgoFromTimestamp:(NSNumber *)timestamp {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp.doubleValue];
    NSString *timeString = date.timeAgoSinceNow;
    return timeString;
    
}

+ (NSAttributedString *)convertHTMLToAttributedString:(NSString *)string{
    NSString *result = [HNUtilities replaceSpecialCharactersInString:string];
    result = [HNUtilities addNewLinesWhereIndicated:result];
    result = [HNUtilities extractHTMLLinksFrom:result];
    
    NSAttributedString *attributedString = [HNUtilities addAttributesToString:result];

    return attributedString;
}

+ (NSArray *)getStringsInString:(NSString *)string withTag:(NSString *)tag{
    NSString *closingTag = [tag stringByReplacingOccurrencesOfString:@"<" withString:@"</"];
    NSArray *components = [string componentsSeparatedByString:closingTag];
    NSMutableArray *strings= [NSMutableArray new];
    for(int i = 0; i < [components count] - 1; i++){
        
        NSString *singleComponent = components[i];
        
        NSRange r1 = [singleComponent rangeOfString:tag];
        
        if(r1.length == 0){
            continue;
        }
        
        NSRange rSub = NSMakeRange(r1.location + r1.length, singleComponent.length - r1.location - r1.length);
        NSString *subString = [singleComponent substringWithRange:rSub];
        
        [strings addObject:subString];
    }
    
    return strings;
}

+ (NSAttributedString *)addAttributesToString:(NSString *)string{
    
    NSArray *pTagStrings = [HNUtilities getStringsInString:string withTag:@"<i>"];
    NSArray *preCodeTagStrings = [HNUtilities getStringsInString:string withTag:@"<code>"];
    
    string = [string stringByRemovingTag:@"<i>"];
    string = [string stringByRemovingOpeningTag:@"<pre><code>" withClosingTag:@"</code></pre>"];
    
    UIFont *preferredFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    CGFloat preferredFontSize = [preferredFont pointSize] - 1.0;
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:preferredFontSize];
    NSDictionary *attributes= [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
    
    for(NSString *singleString in pTagStrings){
        NSRange r1 = [string rangeOfString:singleString];
        
        UIFont *font = [UIFont fontWithName:@"Helvetica-Oblique" size:preferredFontSize];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        [mutableAttributedString addAttributes:attrsDictionary range:r1];
    }
    
    for(NSString *singleString in preCodeTagStrings){
        NSRange r1 = [string rangeOfString:singleString];
        
        UIFont *font = [UIFont fontWithName:@"Courier New" size:preferredFontSize];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        [mutableAttributedString addAttributes:attrsDictionary range:r1];
    }
    
    
    return [mutableAttributedString copy];
    
}

+ (NSString *)extractHTMLLinksFrom:(NSString *)string{
    
    NSArray *components = [string componentsSeparatedByString:@"</a>"];
    
    
    for(int i = 0; i < [components count] - 1; i++){
        
        NSString *singleComponent = components[i];
        
        NSRange r1 = [singleComponent rangeOfString:@"<a"];
        
        if(r1.length == 0){
            continue;
        }
        
        
        NSRange rSub = NSMakeRange(r1.location, singleComponent.length - r1.location);
        NSString *subString = [singleComponent substringWithRange:rSub];
        
        r1 = [subString rangeOfString:@"href=\""];
        NSRange r2 = [subString rangeOfString:@"\" rel"];
        
        if(r1.length == 0 || r2.length == 0){
            continue;
        }
        
        rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
        NSString *url = [subString substringWithRange:rSub];
        
        string = [string stringByReplacingOccurrencesOfString:subString withString:url];

    }

    
     string = [string stringByReplacingOccurrencesOfString:@"</a>" withString:@""];
    
    return string;

    
}


+ (NSString *)addNewLinesWhereIndicated:(NSString *)string{
    
    NSArray *components = [string componentsSeparatedByString:@"<p>"];
    
    
    for(int i = 0; i < [components count] - 1; i++){
        
        NSString *singleComponent = components[i];
        
        NSString *newSingleComponent = [singleComponent stringByAppendingString:@"\n\n"];
        
        string = [string stringByReplacingOccurrencesOfString:singleComponent withString:newSingleComponent];
    }
    
    string = [string stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    
    return string;

}

+ (NSString *)replaceSpecialCharactersInString:(NSString *)string{

    string = [string stringByReplacingOccurrencesOfString:@"&#x27;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&#x2F;" withString:@"/"];
    string = [string stringByReplacingOccurrencesOfString:@"&#x5C;" withString:@"\\"];
    
    
    return string;
}


+ (NSAttributedString *)proximaNovaStyleStringForTitle:(NSString *)title withURL:(NSString *)url {
    
    NSAttributedString *titleString = [[NSAttributedString alloc]initWithString:title
                                                                     attributes:@{NSForegroundColorAttributeName : [UIColor darkTextColor]}];
    
    NSAttributedString *urlString;
    
    if (url != nil) {
        urlString = [[NSAttributedString alloc]initWithString:
                     [NSString stringWithFormat:@" (%@)", url.pathComponents[1]] attributes:@{
                                                                                              NSForegroundColorAttributeName : [UIColor HNLightGray],
                                                                                              NSFontAttributeName : [UIFont proximaNovaWithWeight:TypeWeightSemibold size:12.0],
                                                                                              NSBaselineOffsetAttributeName : @1.8}];
    }
    
    NSMutableAttributedString *combinedString = [[NSMutableAttributedString alloc]initWithAttributedString:titleString];
    
    [combinedString appendAttributedString:urlString];
    
    return combinedString;
    
    
}


+ (NSString *)stringForCommentsCount:(NSNumber *)commentsCount {
    
    NSString *commentsCountString;

    switch (commentsCount.integerValue) {
        case 0:
            commentsCountString = @"No Comments";
            break;
        case 1:
            commentsCountString = @"1 Comment";
            break;
        default:
            commentsCountString = [NSString stringWithFormat:@"%@ Comments", commentsCount];
            break;
    }
    return commentsCountString;
}



+ (NSAttributedString *)proximaNovaStyledCommentStringForHTML:(NSString *)uglyHTML {
    
    NSMutableParagraphStyle *pStyle = [NSMutableParagraphStyle new];
    pStyle.lineSpacing = 5.0;
    
    NSAttributedString *convertedHTML = [self convertHTMLToAttributedString:uglyHTML];
    NSMutableAttributedString *prettyString = [[NSMutableAttributedString alloc]initWithAttributedString:convertedHTML];
    [prettyString addAttributes: @{
                                   NSFontAttributeName : [UIFont proximaNovaWithWeight:TypeWeightRegular size:14.0],
                                   NSForegroundColorAttributeName : [UIColor darkTextColor], NSParagraphStyleAttributeName : pStyle
                                   } range:NSMakeRange(0, convertedHTML.length)];
    
    return prettyString;
}

+ (NSAttributedString *)originationLabelForAuthor:(NSString *)author time:(NSNumber *)time  {
    
    NSAttributedString *authorString = [[NSAttributedString alloc]initWithString:@"drak" attributes:@{NSForegroundColorAttributeName : [UIColor HNOrange]}];
    
    NSAttributedString *timeString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" | %@", [HNUtilities timeAgoFromTimestamp:time]] attributes:@{NSForegroundColorAttributeName : [UIColor HNLightGray]}];
    
    NSMutableAttributedString *combinedStr = [[NSMutableAttributedString alloc] initWithAttributedString:authorString];
    [combinedStr appendAttributedString:timeString];
    
    return combinedStr;
}





//#pragma mark - HTML
//
//+ (NSString *)setCSSForLinks:(NSString *)htmlString{
//    return [NSString stringWithFormat:@"<head> <style> a{color: #1569C7;text-decoration: none} </style></head> %@",htmlString];
//}
//
//
//+ (NSString *)makeCodeWrapInHTML:(NSString *)htmlString{
//    return [htmlString stringByReplacingOccurrencesOfString:@"<pre>" withString:@"<pre style=\"white-space: pre-wrap;\">"];
//}
//
//+ (NSString *)makeLongLinksWrapInHTML:(NSString *)htmlString{
//    
//    return [NSString stringWithFormat:@"<body style=\"-ms-word-break: break-all;word-break: break-all;word-break: break-word;-webkit-hyphens: auto; -moz-hyphens: auto; hyphens: auto;\">%@</body>",
//            htmlString];
//}
//
//+ (NSString *)setFont:(NSString *)fontName withSize:(int)size inThisPieceOfHTMLCode:(NSString *)htmlString{
//    return [NSString stringWithFormat:@"<span style=\"font-family: %@; font-size: %i\">%@</span>",
//            fontName,
//            size,
//            htmlString];
//}
//
//+ (NSString *)makeThisPieceOfHTMLBeautiful: (NSString *)htmlString withFont:(NSString *)fontName ofSize:(int)size{
//    
//    
//    htmlString = [HNUtilities setFont:fontName withSize:size inThisPieceOfHTMLCode:htmlString];
//    
//    htmlString = [HNUtilities makeCodeWrapInHTML:htmlString];
//    htmlString = [HNUtilities makeLongLinksWrapInHTML:htmlString];
//    htmlString = [HNUtilities setCSSForLinks:htmlString];
//    return htmlString;
//    
//}
//

@end
