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
#import "HNCommentsContainerCell.h"
#import "HNThinLineButton.h"
#import "RATreeView.h"
#import "HNCommentsReplyWithRepliesCell.h"

//View Model
#import "HNCommentsCellViewModel.h"
#import "HNRepliesCellViewModel.h"
#import "HNCommentThread.h"
#import "HNItemComment.h"




CGFloat const kCommentsVerticalInset = 10;
CGFloat const kCommentsHorizontalInset = 8;


@interface HNCommentsContainerCell () <RATreeViewDataSource, RATreeViewDelegate>

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (nonatomic) UIView *cardView;

@end


@implementation HNCommentsContainerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initalizeViews];
        [self bindViewModel];
    }
    return self;
}

- (void)bindViewModel {
    @weakify(self);
    [[[RACObserve(self, viewModel) deliverOnMainThread] ignore:nil] subscribeNext:^(HNCommentsCellViewModel *x) {
        @strongify(self);
        [self.treeView reloadData];
        [self layoutIfNeeded];
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

    
    self.treeView = [RATreeView newAutoLayoutView];
    self.treeView.backgroundColor = [ UIColor orangeColor];

    self.treeView.delegate = self;
    self.treeView.dataSource = self;
    self.treeView.rowHeight = UITableViewAutomaticDimension;
    self.treeView.estimatedRowHeight = 200;
    self.treeView.scrollEnabled = NO;
    self.treeView.treeFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.treeView.backgroundColor = [UIColor clearColor];
    self.treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    [self.treeView registerClass:[HNCommentsReplyWithRepliesCell class] forCellReuseIdentifier:@"Cell"];
    
    [self.cardView addSubview:self.treeView];
    
    
}



- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints {
    
    if (self.didSetupConstraints == NO) {
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kCommentsHorizontalInset];
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kCommentsHorizontalInset];
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kCommentsVerticalInset];
    
        [self.treeView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kCommentsVerticalInset];
        [self.treeView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kCommentsHorizontalInset];
        [self.treeView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kCommentsHorizontalInset];
        
        [UIView autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
            
//            [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kCommentsVerticalInset];
            [self.treeView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kCommentsVerticalInset];
        }];
        

        self.didSetupConstraints = YES;
    }
    

    if (!self.treeViewHeightConstraint) {
        self.treeViewHeightConstraint = [self.treeView autoSetDimension:ALDimensionHeight toSize:self.treeView.contentSize.height];
    }
    else {
        self.treeViewHeightConstraint.constant = self.treeView.contentSize.height;
    }

    [super updateConstraints];
}

#pragma mark - TreeView Data Source

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(HNCommentThread *)item {
    
    if (item == nil) {
        return [self.viewModel.commentThreadArray count];
    }
    
    return [item.replies count];

}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(HNCommentThread *)item {
    
    
    if (item == nil) {
        return [self.viewModel.commentThreadArray objectAtIndex:index];
    }
    
    return item.replies[index];
}

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(HNCommentThread *)item {
    
    HNCommentsReplyWithRepliesCell *cell = [treeView dequeueReusableCellWithIdentifier:@"Cell"];
    
    [cell configureWithViewModel:[self.viewModel repliesViewModelForRootComment:item.headComment]];
    
    
    __weak typeof (self) weakSelf = self;
    __weak typeof (cell) weakCell = cell;
    
//    if ([self.treeView levelForCellForItem:item] == 0) {
//        cell.widthThreadLineConstraint.constant = 0;
//        cell.commentTextViewToThreadline.constant = 0;
//    } else {
//        cell.leadingThreadLineConstraint.constant = [self.treeView levelForCellForItem:item] * 8;
//    }

    
//    if (item.replies.count < 1) {
//        //No replies
//        for (NSLayoutConstraint *constraint in cell.repliesButtonConstraints) {
//            constraint.constant = 0;
//        }
//    }
    cell.repliesButtonDidTapAction = ^(id sender){
        if (![weakSelf.treeView isCellForItemExpanded:item]) {
            [weakSelf.treeView expandRowForItem:item];
            weakSelf.treeViewHeightConstraint.constant = weakSelf.treeView.contentSize.height;
            [weakCell layoutIfNeeded];
            [weakSelf layoutIfNeeded];
            
            [weakSelf.treeView.delegate treeView:treeView didExpandRowForItem:item];

            DLog(@"In block weak :%f", weakSelf.treeView.contentSize.height);
            DLog(@"In block:%f", self.treeView.contentSize.height);
            DLogNSSize(self.bounds.size);
        }
    };
    
    DLogNSSize(self.treeView.contentSize);
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];

    return cell;
}

- (UITableViewCellEditingStyle)treeView:(RATreeView *)treeView editingStyleForRowForItem:(id)item {
    return UITableViewCellEditingStyleNone;
}


#pragma mark - 
#pragma mark - TreeView Delegate

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {
    
    DLogNSObject(treeView);
    
}

- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item {
//    [self.parentTableView beginUpdates];
//    [self.parentTableView endUpdates];
}

- (void)treeView:(RATreeView *)treeView didExpandRowForItem:(id)item {

//    [self.parentTableView beginUpdates];
//        self.treeViewHeightConstraint.constant = self.treeView.contentSize.height;
//
//    [self.parentTableView endUpdates];
//    DLogNSSize(self.treeView.contentSize);
//    [self.parentTableView endUpdates];
}




#pragma mark - 
#pragma mark 

- (CGSize)preferredLayoutSizeFittingSize:(CGSize)targetSize {
    
    CGRect originalFrame = self.frame;
    
    CGRect frame = self.frame;
    frame.size = targetSize;
    self.frame = frame;

    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];

    
    
    CGSize computedSize = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    CGSize newSize = CGSizeMake(targetSize.width, computedSize.height);
    
    self.frame = originalFrame;
    
    return newSize;
    
}








@end