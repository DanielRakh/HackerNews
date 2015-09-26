//
//  HNFeedCellLinked.m
//  HackerNews
//
//  Created by Daniel on 9/24/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNFeedCellLinked.h"
#import "HNFeedCellViewModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DSFavIconManager.h"


static NSString *favIconURLString = @"https://www.google.com/s2/favicons?domain=";

@interface HNFeedCellLinked ()

@property (nonatomic, strong) HNFeedCellViewModel *viewModel;

@end

@implementation HNFeedCellLinked


- (void)awakeFromNib {
    [super awakeFromNib];
    self.commentsButton.layer.cornerRadius = self.commentsButton.bounds.size.height / 2.0;
    
}

- (void)configureWithViewModel:(HNFeedCellViewModel *)viewModel {
    
    self.viewModel = viewModel;
    
    self.titleLabel.text = self.viewModel.title;
    self.linkLabel.text = self.viewModel.url;
    self.infoLabel.text = self.viewModel.info;
    
    NSString *favIconPath = [favIconURLString stringByAppendingString:[self.viewModel.url stringByAppendingString:@"/apple-touch-icon.png"]];
    

    
    [self.linkIconView sd_setImageWithURL:[NSURL URLWithString:@"http://icons.better-idea.org/api/icons?url=medium.com&i_am_feeling_lucky=yes"] placeholderImage:[UIImage imageNamed:@"LinkIcon"]];
    
//    [[DSFavIconManager sharedInstance] iconForURL:[NSURL URLWithString:favIconPath] downloadHandler:^(UINSImage *icon) {
//        self.linkIconView.image = icon;
//    }];

    
//    [self iconForURL:@"https://www.google.com/s2/favicons?domain=www.stackoverflow.com"];
}

/*
- (void)iconForURL:(NSString *)url {
    
    NSURLSessionDataTask *faviconTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            UIImage *favIcon = [UIImage imageWithData:data scale:0];
            self.linkIconView.image = favIcon;
        }
    }];
    
    [faviconTask resume];
}
 */


@end
