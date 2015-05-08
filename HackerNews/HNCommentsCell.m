//
//  HNCommentsCell.m
//  HackerNews
//
//  Created by Daniel on 4/6/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "PureLayout.h"
#import "UIColor+HNColorPalette.h"
#import "UIFont+HNFont.h"
#import "ReactiveCocoa/ReactiveCocoa.h"

//View
#import "HNCommentsCell.h"
#import "HNThinLineButton.h"
#import "RATreeView.h"
#import "HNRepliesCell.h"

//View Model
#import "HNCommentsCellViewModel.h"
#import "HNCommentThread.h"



CGFloat const kCommentsVerticalInset = 10;
CGFloat const kCommentsHorizontalInset = 8;


@interface HNCommentsCell () <RATreeViewDataSource, RATreeViewDelegate>

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (nonatomic) UIView *cardView;

@property (nonatomic) HNCommentsCellViewModel *viewModel;

@property (nonatomic) RATreeView *treeView;

@property (nonatomic) NSLayoutConstraint *treeViewHeightConstraint;


@end


@implementation HNCommentsCell

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

- (void)configureWithViewModel:(HNCommentsCellViewModel *)viewModel {
    NSLog(@"CONFIGURE VIEW MODEL");
    self.viewModel = viewModel;
    self.viewModel.active = YES;
    
    @weakify(self);
    [[RACObserve(self.viewModel, commentThreads) deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        [self.treeView reloadData];
    }];

    
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
    self.cardView.layer.cornerRadius = 2.0;
    self.cardView.layer.borderWidth = 0.5;
    self.cardView.layer.borderColor =  [UIColor colorWithRed:0.290 green:0.290 blue:0.290 alpha:0.2].CGColor;
    
    
    self.cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cardView.layer.shadowRadius  = 4.0;
    self.cardView.layer.shadowOpacity = 0.05;
    self.cardView.layer.shadowOffset = CGSizeMake(0, 1);
    self.cardView.layer.shouldRasterize = YES;
    self.cardView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.cardView.layer.masksToBounds = NO;
    
    [self.contentView addSubview:self.cardView];

    
    self.treeView = [[RATreeView alloc]initForAutoLayout];
    self.treeView.delegate = self;
    self.treeView.dataSource = self;
    self.treeView.rowHeight = UITableViewAutomaticDimension;
    self.treeView.treeFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.treeView.backgroundColor = [UIColor greenColor];
    self.treeView.separatorColor = RATreeViewCellSeparatorStyleNone;
    [self.treeView registerClass:[HNRepliesCell class] forCellReuseIdentifier:@"Cell"];
    
    [self.cardView addSubview:self.treeView];
}

-(void)updateConstraints {
    
//    if (self.didSetupConstraints == NO) {
    
        // Card View Constraints
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kCommentsHorizontalInset];
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kCommentsHorizontalInset];
        [UIView autoSetPriority:750 forConstraints:^{
            [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kCommentsVerticalInset];
        }];
    
    
        self.treeViewHeightConstraint = [self.treeView autoSetDimension:ALDimensionHeight toSize:300];
        [self.treeView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kCommentsVerticalInset];
        [self.treeView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kCommentsHorizontalInset];
        [self.treeView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kCommentsHorizontalInset];
        [self.treeView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kCommentsVerticalInset];
    
        self.didSetupConstraints = YES;
//    }

    
    [super updateConstraints];
        
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.treeView.contentSize.height > self.treeView.bounds.size.height) {
        self.treeViewHeightConstraint.constant = self.treeView.contentSize.height;
        [super layoutSubviews];
    }
}



#pragma mark - TreeView Data Source

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(HNCommentThread *)item {
    if (item == nil) {
        return [self.viewModel.commentThreads count];
    }
    return [item.replies count];
}

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(HNCommentThread *)item {
    HNRepliesCell *cell = [treeView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell configureWithViewModel:[self.viewModel repliesViewModelForRootComment:item.headComment]];

    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(HNCommentThread *)item {
    
    if (item == nil) {
        return [self.viewModel.commentThreads objectAtIndex:index];
    }
    
    return item.replies[index];
}

@end