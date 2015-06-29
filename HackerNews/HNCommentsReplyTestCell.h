//
//  HNCommentsReplyTestCell.h
//  
//
//  Created by Daniel on 6/28/15.
//
//

#import <UIKit/UIKit.h>
#import "HNRepliesCellViewModel.h"


@interface HNCommentsReplyTestCell : UITableViewCell

@property (nonatomic) HNRepliesCellViewModel *viewModel;
@property (nonatomic) UITextView *commentTextView;
@property (nonatomic) NSLayoutConstraint *textViewHeightConstraint;



- (void)configureWithViewModel:(HNRepliesCellViewModel *)viewModel;


- (CGFloat)preferredLayoutSizeFittingHeight:(CGFloat)height;


@end
