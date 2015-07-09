//
//  HNCommentsCell.h
//  
//
//  Created by Daniel on 7/9/15.
//
//

#import <UIKit/UIKit.h>

static CGFloat const kRepliesVerticalInset = 10;
static CGFloat const kRepliesHorizontalInset = 8;

@interface HNCommentsCell : UITableViewCell

@property (nonatomic) UILabel *originationLabel;
@property (nonatomic) UITextView *commentTextView;

@property (nonatomic, assign) BOOL didUpdateConstraints;

@end
