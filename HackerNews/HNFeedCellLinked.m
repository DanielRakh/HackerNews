//
//  HNFeedCellLinked.m
//  HackerNews
//
//  Created by Daniel on 9/24/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNFeedCellLinked.h"
#import "HNFeedCellViewModel.h"

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
//    [self iconForURL:@"https://www.google.com/s2/favicons?domain=www.stackoverflow.com"];
}

- (void)iconForURL:(NSString *)url {
    
    NSURLSessionDataTask *faviconTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            UIImage *favIcon = [UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
            NSLog(@"%@",favIcon);
        }
    }];
    
    [faviconTask resume];
}


@end
