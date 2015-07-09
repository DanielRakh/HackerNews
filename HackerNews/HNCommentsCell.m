//
//  HNCommentsCell.m
//  
//
//  Created by Daniel on 7/9/15.
//
//

#import "HNCommentsCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PureLayout.h"

//Categories
#import "UIColor+HNColorPalette.h"
#import "UIFont+HNFont.h"
#import "UIView+FindUITableView.h"


@interface HNCommentsCell ()


@end

@implementation HNCommentsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.didUpdateConstraints = NO;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    // Set up Origination Label
    self.originationLabel = [UILabel newAutoLayoutView];
    self.originationLabel.numberOfLines = 1;
    self.originationLabel.textColor = [UIColor lightGrayColor];
    self.originationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.originationLabel.font = [UIFont proximaNovaWithWeight:TypeWeightSemibold size:12.0];
    self.originationLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.originationLabel];
    
    self.commentTextView = [UITextView newAutoLayoutView];
    self.commentTextView.backgroundColor = [UIColor clearColor];
    self.commentTextView.clipsToBounds = NO;
    self.commentTextView.editable = NO;
    self.commentTextView.linkTextAttributes = @{NSForegroundColorAttributeName : [UIColor HNOrange]};
    self.commentTextView.selectable = YES;
    self.commentTextView.dataDetectorTypes = UIDataDetectorTypeLink;
    self.commentTextView.scrollEnabled = NO;
    self.commentTextView.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
    self.commentTextView.textContainer.lineFragmentPadding = 0;
    self.commentTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.commentTextView.text = nil;
    self.commentTextView.font = nil;
    self.commentTextView.textColor = nil;
    self.commentTextView.textAlignment = NSTextAlignmentLeft;
    
    
    [self.contentView addSubview:self.commentTextView];
    
    
}



@end
