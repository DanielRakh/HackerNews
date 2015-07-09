//
//  HNCommentsCell.h
//  
//
//  Created by Daniel on 7/9/15.
//
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PureLayout.h"


//Categories
#import "UIColor+HNColorPalette.h"
#import "UIFont+HNFont.h"

@class HNRepliesCellViewModel;



@interface HNCommentsCommentCell : UITableViewCell

@property (nonatomic) UILabel *originationLabel;
@property (nonatomic) UITextView *commentTextView;

@property (nonatomic, assign) BOOL didUpdateConstraints;

- (void)configureWithViewModel:(HNRepliesCellViewModel *)viewModel;


@end
