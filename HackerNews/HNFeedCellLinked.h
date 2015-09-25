//
//  HNFeedCellLinked.h
//  HackerNews
//
//  Created by Daniel on 9/24/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HNFeedCellViewModel;
@class JAMSVGImageView;

@interface HNFeedCellLinked : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet JAMSVGImageView *linkIconView;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;



- (void)configureWithViewModel:(HNFeedCellViewModel *)viewModel;

@end
