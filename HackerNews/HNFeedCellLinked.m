//
//  HNFeedCellLinked.m
//  HackerNews
//
//  Created by Daniel on 9/24/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNFeedCellLinked.h"
#import "HNFeedCellViewModel.h"
#import "JAMSVGImageView.h"

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
    
    
    
}


@end
