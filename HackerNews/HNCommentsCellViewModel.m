//
//  HNCommentsCellViewModel.m
//  HackerNews
//
//  Created by Daniel on 4/6/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNCommentsCellViewModel.h"
#import "HNComment.h"
#import <DTCoreText/DTCoreText.h>
#import "Utils.h"


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
        _origination = [[NSAttributedString alloc]initWithString: @"by danielrak | 5 hrs ago"];
        _text = [Utils convertHTMLToAttributedString:comment.text_];
//        _text = [[NSAttributedString alloc]initWithString:comment.text_];
        
        
//        if ([comment.text_ hasSuffix:@"<p>"]) {
//            comment.text_ = [comment.text_ substringToIndex:comment.text_.length - 3];
//        }
        
//        DTCoreTextParagraphStyle *style = [DTCoreTextParagraphStyle defaultParagraphStyle];
//        style.paragraphSpacing = 10.0;
//        
//        NSParagraphStyle *pStyle = style.NSParagraphStyle;
//
//        
//
//        
//        
//        unichar last = [comment.text_ characterAtIndex:[comment.text_ length] - 8];
//        if ([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:last]) {
//            NSLog(@"MEMBER!!!");
//        }
//
//        
//        NSLog(@"%@", comment.text_);
//
//        NSLog(@"%ld", comment.text_.length);
//        
//        NSDictionary *opts = @{DTDefaultFontName : @"AvenirNext-Regular", DTDefaultFontSize: @(14.0), NSParagraphStyleAttributeName : pStyle};
//        NSAttributedString *attStr = [[[DTHTMLAttributedStringBuilder alloc]initWithHTML:[comment.text_ dataUsingEncoding:NSUTF8StringEncoding] options:opts documentAttributes:NULL] generatedAttributedString];
//        NSMutableAttributedString *mutStr = attStr.mutableCopy;
//        [mutStr addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, mutStr.length)];
        
//        _text = attStr;
//
//
//        NSLog(@"%@",_text);
        
        
//        NSString *html = comment.text_;
//        // first parse any unnecessary html paragraphs out
//      
//        
//        DTHTMLAttributedStringBuilder *builder = [[DTHTMLAttributedStringBuilder alloc]
//                                                  initWithHTML:[html dataUsingEncoding:NSUTF8StringEncoding]
//                                                  options:nil
//                                                  documentAttributes:nil];
//        NSMutableAttributedString *attributedString = [[builder generatedAttributedString] mutableCopy];
//        
//        DTCoreTextParagraphStyle *paragraphStyle = [DTCoreTextParagraphStyle defaultParagraphStyle];
//        style.paragraphSpacing = 12.f;
//  


    }
    
    return self;
}

@end
