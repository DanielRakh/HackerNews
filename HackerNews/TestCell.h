//
//  TestCell.h
//  
//
//  Created by Daniel on 6/29/15.
//
//

#import <UIKit/UIKit.h>
#import "HNRepliesCellViewModel.h"


@interface TestCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (nonatomic) HNRepliesCellViewModel *viewModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;



- (void)configureWithViewModel:(HNRepliesCellViewModel *)viewModel;


@end
