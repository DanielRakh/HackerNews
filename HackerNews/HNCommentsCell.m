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
#import "HNRepliesCellViewModel.h"
#import "HNCommentThread.h"
#import "HNItemComment.h"

#import "UIView+FindUITableView.h"



CGFloat const kCommentsVerticalInset = 10;
CGFloat const kCommentsHorizontalInset = 8;


@interface HNCommentsCell () <RATreeViewDataSource, RATreeViewDelegate>

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (nonatomic) UIView *cardView;
//@property (nonatomic) RATreeView *treeView;
@property (nonatomic) NSLayoutConstraint *treeViewHeightConstraint;
@property (nonatomic) NSNumber *expandedHeight;


@property (nonatomic) NSMutableArray *indexPathsForRowsToExpand;

@end


@implementation HNCommentsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self initalizeViews];
    [self bindViewModel];
    self.indexPathsForRowsToExpand = [NSMutableArray array];
}

- (void)bindViewModel {
    @weakify(self);
    [[[RACObserve(self, viewModel) deliverOnMainThread] ignore:nil] subscribeNext:^(HNCommentsCellViewModel *x) {
        @strongify(self);
        NSLog(@"%@",x);
        [self.treeView reloadData];
        [self.treeView layoutIfNeeded];
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

    
    self.treeView = [[RATreeView alloc]initWithFrame:CGRectZero style:RATreeViewStylePlain];
    self.treeView.translatesAutoresizingMaskIntoConstraints = NO;

    self.treeView.delegate = self;
    self.treeView.dataSource = self;
    self.treeView.rowHeight = UITableViewAutomaticDimension;
    self.treeView.estimatedRowHeight = 200;
    self.treeView.scrollEnabled = NO;
    self.treeView.treeFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.treeView.backgroundColor = [UIColor greenColor];
    self.treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    [self.treeView registerClass:[HNRepliesCell class] forCellReuseIdentifier:@"Cell"];
    
    [self.cardView addSubview:self.treeView];
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.treeViewHeightConstraint.constant = self.treeView.contentSize.height;
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints {
    
    if (self.didSetupConstraints == NO) {
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kCommentsHorizontalInset];
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kCommentsHorizontalInset];
    
        [self.treeView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kCommentsVerticalInset];
        [self.treeView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kCommentsHorizontalInset];
        [self.treeView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kCommentsHorizontalInset];
        
        [UIView autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
            
            [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kCommentsVerticalInset];
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

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(HNCommentThread *)item {
    
    HNRepliesCell *cell = [treeView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.parentTreeView = self.treeView;
    cell.treeConstraint = self.treeViewHeightConstraint;
    
    __weak typeof (self) weakSelf = self;
    __weak typeof (cell) weakCell = cell;
    cell.repliesButtonDidTapAction = ^(id sender){
        
        if (![weakSelf.treeView isCellForItemExpanded:item]) {
//        [weakSelf.parentTableView beginUpdates];
            [weakSelf.treeView expandRowForItem:item expandChildren:YES withRowAnimation:RATreeViewRowAnimationAutomatic];
            [weakSelf.treeView updateConstraintsIfNeeded];
            [weakSelf.treeView layoutIfNeeded];
//            [weakCell.repliesButton setTitle:@"Collapse" forState:UIControlStateNormal];

//            [weakSelf.treeView beginUpdates];
//            weakCell.repliesButton.alpha = 0;
//            [weakCell.repliesButton removeFromSuperview];
//            [weakCell.repliesButtonConstraints autoRemoveConstraints];
//            [weakCell.contentView addConstraint:weakCell.textViewToBottomConstraint];
//            [weakSelf.treeView endUpdates];
//            [weakSelf.treeView updateConstraintsIfNeeded];
//            [weakSelf.treeView layoutIfNeeded];
//        [weakSelf.parentTableView endUpdates];
    }
    };
    [cell configureWithViewModel:[self.viewModel repliesViewModelForRootComment:item.headComment]];
    [cell setNeedsUpdateConstraints];
    [self setNeedsUpdateConstraints];
    
    return cell;
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(HNCommentThread *)item {
    
    
    if (item == nil) {
        return [self.viewModel.commentThreadArray objectAtIndex:index];
    }
    
    return item.replies[index];
}



- (UITableViewCellEditingStyle)treeView:(RATreeView *)treeView editingStyleForRowForItem:(id)item {
    return UITableViewCellEditingStyleNone;
}

//- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(HNCommentThread *)item {
//    
//    HNRepliesCell *cell = (HNRepliesCell *)[treeView cellForItem:item];
//    cell.expanded = YES;
//    
//}

- (void)treeView:(RATreeView *)treeView didExpandRowForItem:(HNCommentThread *)item {
    
    [self.parentTableView beginUpdates];
    [self.parentTableView endUpdates];
    
//    NSIndexPath *idxPath = [self.parentTableView indexPathForCell:self];
//    if (![self.indexPathsForRowsToExpand containsObject:idxPath]) {
//        [self.indexPathsForRowsToExpand addObject:idxPath];
//        NSLog(@"%@",self.indexPathsForRowsToExpand);
//    }
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"IndexPathsToExpand" object:self userInfo:@{@"IndexPath" : idxPath }];

    

}

- (void)keepCellExpanded {
    
    [self.treeView beginUpdates];
    [self.treeView expandRowForItem:[[self.viewModel commentThreadArray] firstObject] expandChildren:YES withRowAnimation:RATreeViewRowAnimationNone];
//    [self.treeView expandRowForItem:[[self.viewModel commentThreadArray] firstObject] withRowAnimation:RATreeViewRowAnimationNone];
    [self layoutIfNeeded];
    [self updateConstraintsIfNeeded];
    [self.treeView endUpdates];
    
    [self layoutIfNeeded];
}


-(void)prepareForReuse {
    [super prepareForReuse];
//    [self.indexPathsForRowsToExpand removeAllObjects];
}


@end