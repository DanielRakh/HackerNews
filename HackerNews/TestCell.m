//
//  TestCell.m
//  
//
//  Created by Daniel on 6/29/15.
//
//

#import "TestCell.h"

@implementation TestCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)layoutSubviews {
    [super layoutSubviews];
//    CGFloat textViewWidth = self.contentView.bounds.size.width - (8 * 2);
//    CGRect rect = [self.commentTextView.attributedText boundingRectWithSize:CGSizeMake(textViewWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//    
//    self.textViewHeightConstraint.constant = CGRectGetHeight(rect) + 1;
    
    self.textViewHeightConstraint.constant = [self textViewHeightForAttributedText:self.commentTextView.attributedText andWidth:self.contentView.bounds.size.width];
    
}


- (void)updateConstraints {
    
    self.textViewHeightConstraint.constant = [self textViewHeightForAttributedText:self.commentTextView.attributedText andWidth:self.contentView.bounds.size.width];
//
    
    
    [super updateConstraints];
    
}

- (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width {
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}


- (void)configureWithViewModel:(HNRepliesCellViewModel *)viewModel {
    self.commentTextView.attributedText = viewModel.text;
}


@end
