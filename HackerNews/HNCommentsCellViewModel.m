//
//  HNCommentsCellViewModel.m
//  HackerNews
//
//  Created by Daniel on 4/6/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNCommentsCellViewModel.h"
#import "HNComment.h"
#import "DTCoreText.h"


@interface HNCommentsCellViewModel ()

@property (nonatomic) HNComment *comment;

@property (nonatomic, readwrite) NSAttributedString *origination;
@property (nonatomic, readwrite) NSAttributedString *text;

@end
@implementation HNCommentsCellViewModel



- (instancetype)initWithComment:(HNComment *)comment {
    self = [super init];
    if (self) {
        
//        NSError* error;
//        NSString* source = @"<strong>Nice</strong> try, Phil";
//        source = [source stringByAppendingString:@"<style>strong{font-family: 'Avenir-Roman';font-size: 14px;}</style>"];
   
        _comment = comment;
        _origination = [[NSAttributedString alloc]initWithString: @"by danielrak | 5 hrs ago"];
        
        NSString *html = comment.text_;
        NSData *data = [html dataUsingEncoding:NSUTF16StringEncoding];
        
        
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:data options:@{DTUseiOS6Attributes : @YES} documentAttributes:NULL];
//        NSLog(@" DT CORE TEXT: %@", attrString);
        
        
        
        _text = attrString;
        
        
//        NSString *convertedString = [[HTMLDocument alloc]initWithString:comment.text_];
//
//        NSLog(@" REGULAR: %@", comment.text_);
//        NSLog(@" UNESCAPING: %@",comment.text_.html_stringByUnescapingHTML);
//        _text = comment.text_.html_stringByUnescapingHTML;
        
        
        //        _text = [[NSAttributedString alloc] initWithData:[[comment.text_ stringByAppendingString:@"<style>strong{font-family:'Avenir-Roman';font-size: 14px;}</style>"]dataUsingEncoding:NSUTF8StringEncoding]
//                                                 options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];

    }
    return self;
}

@end
