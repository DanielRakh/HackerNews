//
//  HNCommentsHeaderCell.h
//  HackerNews
//
//  Created by Daniel on 9/29/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNCommentsHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;

//- (void)configureWithViewModel:(HNFeedCellViewModel *)viewModel;



@end
