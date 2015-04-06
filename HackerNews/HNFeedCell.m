//
//  HNFeedTableViewCell.m
//  HackerNews
//
//  Created by Daniel on 4/1/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNFeedCell.h"
#import "PureLayout.h"
#import "UIColor+HNColorPalette.h"
#import "HNThinLineButton.h"
#import "HNCellViewModel.h"
#import "HNCommentsViewModel.h"
#import "HNCommentsViewController.h"


CGFloat const kVerticalInset = 10;
CGFloat const kHorizontalInset = 8;


@interface HNFeedCell ()

@property (nonatomic) UIView *cardView;
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic) HNCellViewModel *viewModel;

@end

@implementation HNFeedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initalizeViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initalizeViews];
    }
    return self;
}

- (void)configureWithViewModel:(HNCellViewModel *)viewModel {
    self.viewModel = viewModel;
    self.titleLabel.text = viewModel.title;
    self.scoreLabel.text = viewModel.score;
    [self.commentsButton setTitle:[NSString stringWithFormat:@"%@ Comments", viewModel.commentsCount] forState:UIControlStateNormal];
    [self.commentsButton addTarget:self action:@selector(commentsButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    self.infoLabel.text = viewModel.info;
}

- (void)initalizeViews {
    
    self.didSetupConstraints = NO;
    // We are creating a rounded corner view to serve as the background
    // of the cell so we need to make the real cell background clear.
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    // Set up Card View - rounded corner cell background
    self.cardView = [UIView newAutoLayoutView];
    self.cardView.backgroundColor = [UIColor HNWhite];
    self.cardView.layer.cornerRadius = 8.0;
    self.cardView.layer.borderWidth = 0.5;
    self.cardView.layer.borderColor =  [UIColor HNLightGray].CGColor;
    
    [self.contentView addSubview:self.cardView];
    
    
    // Set up Score Label
    self.scoreLabel = [UILabel newAutoLayoutView];
    self.scoreLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.scoreLabel.numberOfLines = 1;
    self.scoreLabel.text = NSTextAlignmentLeft;
    self.scoreLabel.textColor = [UIColor HNOrange];
    self.scoreLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:10.0];
    
    [self.cardView addSubview:self.scoreLabel];

    
    
    // Set up Title Label
    self.titleLabel = [UILabel newAutoLayoutView];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0];
    
    [self.cardView addSubview:self.titleLabel];
    
    
    
    // Set up Info Label
    self.infoLabel = [UILabel newAutoLayoutView];
    self.infoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.infoLabel.numberOfLines = 1;
    self.infoLabel.text = NSTextAlignmentLeft;
    self.infoLabel.textColor = [UIColor lightGrayColor];
    self.infoLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:10.0];
    
    [self.cardView addSubview:self.infoLabel];
    
    
    // Set up Comments Button
    self.commentsButton = [HNThinLineButton newAutoLayoutView];
    [self.cardView addSubview:self.commentsButton];

}

-(void)updateConstraints {
    
    if (self.didSetupConstraints == NO) {
       
        // Card View Constraints
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalInset];
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalInset];
        [UIView autoSetPriority:750 forConstraints:^{
            [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kVerticalInset];
        }];
        
        
        [self.scoreLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kVerticalInset];
        [self.scoreLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalInset];
        
        // Title Label Constraints
        [self.titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.scoreLabel withOffset:kVerticalInset relation:NSLayoutRelationEqual];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHorizontalInset];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalInset];
        
        // Comments Button Constraints
        [self.commentsButton autoSetDimensionsToSize:CGSizeMake(84, 26)];
        [self.commentsButton autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHorizontalInset];
         [self.commentsButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kVerticalInset];
        [self.commentsButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:kVerticalInset relation:NSLayoutRelationEqual];
        
        
        // Info Label Constraints
        
        [self.infoLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.titleLabel];
        [self.infoLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.commentsButton];
        
        
        self.didSetupConstraints = YES;
    }
    
    
    [super updateConstraints];
}



- (void)commentsButtonDidTap:(id)sender {
    [self pushCommentsController];
}


- (void)pushCommentsController {
    HNCommentsViewModel *viewModel = [[HNCommentsViewModel alloc]initWithPost:self.viewModel.post];
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HNCommentsViewController *commentsController =[mainSB instantiateViewControllerWithIdentifier:@"CommentsController"];
    commentsController.viewModel = viewModel;

    [self.navController pushViewController:commentsController animated:YES];
}

@end
