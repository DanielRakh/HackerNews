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


- (void)configureWithViewModel:(HNFeedCellViewModel *)viewModel {
    
    self.viewModel = viewModel;
    
    self.titleLabel.text = self.viewModel.title;
    self.linkLabel.text = self.viewModel.url;
    self.infoLabel.text = self.viewModel.info;
    
    
    
}


@end
