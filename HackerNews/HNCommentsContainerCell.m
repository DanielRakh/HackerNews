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
#import "UIView+FindUITableView.h"
#import "RZCellSizeManager.h"

//View
#import "HNCommentsContainerCell.h"
#import "HNThinLineButton.h"
#import "RATreeView.h"
#import "HNCommentsReplyWithRepliesCell.h"
//#import "HNCommentsReplyTestCell.h"
//#import "TestCell.h"

//View Model
#import "HNCommentsCellViewModel.h"
#import "HNRepliesCellViewModel.h"
#import "HNCommentThread.h"
#import "HNItemComment.h"


#import "HNCommentsViewController.h"


CGFloat const kCommentsVerticalInset = 10;
CGFloat const kCommentsHorizontalInset = 8;


static NSString* const kHNCommentsReplyWithRepliesCell = @"HNCommentsReplyWithRepliesCell";

@interface HNCommentsContainerCell () <RATreeViewDataSource, RATreeViewDelegate>

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (nonatomic) UIView *cardView;
@property (nonatomic) NSLayoutConstraint *treeViewHeightConstraint;


@property (nonatomic) HNCommentsReplyWithRepliesCell *testSizeCell;

@end


@implementation HNCommentsContainerCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initalizeViews];
        [self bindViewModel];
    }
    return self;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initalizeViews];
        [self bindViewModel];
    }
    return self;
}

- (void)bindViewModel {
    @weakify(self);
    [[[RACObserve(self, viewModel) ignore:nil] deliverOnMainThread] subscribeNext:^(HNCommentsCellViewModel *x) {
        @strongify(self);
        [self.treeView reloadData];
        [self.treeView layoutIfNeeded];
        
    }];
    
    [[RACObserve(self.treeView, contentSize) replay] subscribeNext:^(id x) {
        DLogNSObject(x);
    }];


}


- (void)initalizeViews {
    
    self.didSetupConstraints = NO;
    
    // We are creating a rounded corner view to serve as the background
    // of the cell so we need to make the real cell background clear.
    self.backgroundColor = [UIColor magentaColor];
    self.contentView.backgroundColor = [UIColor greenColor];
//    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
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
    

    
    self.treeView = [[RATreeView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:RATreeViewStylePlain];
    self.treeView.translatesAutoresizingMaskIntoConstraints = NO;
    self.treeView.backgroundColor = [UIColor orangeColor];
    self.treeView.delegate = self;
    self.treeView.dataSource = self;
    self.treeView.estimatedRowHeight = 280;
    self.treeView.scrollEnabled = YES;
    self.treeView.treeFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.treeView.backgroundColor = [UIColor clearColor];
    self.treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    
    [self.treeView registerClass:[HNCommentsReplyWithRepliesCell class] forCellReuseIdentifier:kHNCommentsReplyWithRepliesCell];

    [self.cardView addSubview:self.treeView];
    
    self.cellSizeManager = [RZCellSizeManager new];
    [self.cellSizeManager registerCellClassName:NSStringFromClass([HNCommentsReplyWithRepliesCell class]) withNibNamed:nil forReuseIdentifier:kHNCommentsReplyWithRepliesCell withHeightBlock:^CGFloat(HNCommentsReplyWithRepliesCell *cell, HNRepliesCellViewModel *viewModel) {
        [cell configureWithViewModel:viewModel];
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }];

}

- (void)layoutSubviews {
    [super layoutSubviews];

    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints {
    
    if (self.didSetupConstraints == NO) {
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kCommentsHorizontalInset];
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kCommentsHorizontalInset];
        
        [self.treeView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [UIView autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
            [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kCommentsVerticalInset];
        }];
        
        self.didSetupConstraints = YES;
    }
    
//    if (!self.treeViewHeightConstraint) {
//        self.treeViewHeightConstraint = [self.treeView autoSetDimension:ALDimensionHeight toSize:self.treeView.contentSize.height];
//    }
//    else {
////        DLogfloat(self.treeView.contentSize.height);
//
//        self.treeViewHeightConstraint.constant = self.treeView.contentSize.height;
//    }
    

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
    
    HNCommentsReplyWithRepliesCell *cell = [treeView dequeueReusableCellWithIdentifier:kHNCommentsReplyWithRepliesCell];
    
    
    DLogNSObject(item);
    
    [cell configureWithViewModel:[self.viewModel repliesViewModelForRootComment:item.headComment]];
    
    cell.repliesButtonDidTapAction = ^(id sender){
        DLog(@"TAPPED!");
        
  
        [treeView expandRowForItem:item withRowAnimation:RATreeViewRowAnimationAutomatic];
//        [self setNeedsUpdateConstraints];
//        [self updateConstraintsIfNeeded];
        
//        [self.cellSizeManager invalidateCellSizeCache];
//        
//        [self.parentTableView beginUpdates];
//        [self.parentTableView endUpdates];
//        
//        [self updateConstraintsIfNeeded];
//        [self setNeedsLayout];
    };

    return cell;
}


- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(HNCommentThread *)item {
    
    CGFloat height = [self.cellSizeManager cellHeightForObject:[self.viewModel repliesViewModelForRootComment:item.headComment] treeItem:item cellReuseIdentifier:kHNCommentsReplyWithRepliesCell];
//    DLog(@"tree:%f",height);
    
    return height;
}

-  (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {
    
    DLogNSSize(self.treeView.contentSize);
}

- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item {
    return NO;
}


- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item {
    DLog(@"WILL EXPAND!");
//    [self.parentTableView beginUpdates];
//    [self.parentTableView endUpdates];
}

- (void)treeView:(RATreeView *)treeView didExpandRowForItem:(id)item {
//    [self.parentTableView beginUpdates];
//    [self.parentTableView endUpdates];
}


/**
 * Key-Value Observations methods
 */

//- (void)startObservingContentSizeChangesInTableView:(UITableView *)tableView {
//    [tableView addObserver:self forKeyPath:kPropertyToObserve options:0 context:&kObservingContentSizeChangesContext];
//}
//
//- (void)stopObservingContentSizeChangesInTableView:(UITableView *)tableView {
//    [tableView removeObserver:self forKeyPath:kPropertyToObserve context:&kObservingContentSizeChangesContext];
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    if (context == &kObservingContentSizeChangesContext) {
//        // use the delegate
//        if (self.delegate && [self.delegate respondsToSelector:@selector(contentSizeDidChange)]) {
//            // call content size did change
//            [self.delegate contentSizeDidChange];
//        }
//        [self stopObservingContentSizeChangesInTableView:object];
//    } else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}


@end