//
//  Utils.h
//  hn
//
//  Created by Marcin Kmieć on 30.10.2014.
//  Copyright (c) 2014 Marcin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNUtilities : NSObject

+ (NSString *)timeAgoFromTimestamp:(NSNumber *)timestamp;
+ (NSString *)prettyURL:(NSString *)urlString;


+ (NSAttributedString *)proximaNovaStyleStringForTitle:(NSString *)title withURL:(NSString *)url;
+ (NSAttributedString *)proximaNovaStyledCommentStringForHTML:(NSString *)uglyHTML;
+ (NSString *)stringForCommentsCount:(NSNumber *)commentsCount;
+ (NSAttributedString *)originationLabelForAuthor:(NSString *)author time:(NSNumber *)time;

@end
