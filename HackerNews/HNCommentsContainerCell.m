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


CGFloat const kCommentsVerticalInset = 10;
CGFloat const kCommentsHorizontalInset = 8;


static NSString* const kHNCommentsReplyWithRepliesCell = @"HNCommentsReplyWithRepliesCell";

@interface HNCommentsContainerCell () <RATreeViewDataSource, RATreeViewDelegate>

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (nonatomic) UIView *cardView;
@property (nonatomic) RZCellSizeManager *cellSizeManager;


@property (nonatomic) HNCommentsReplyWithRepliesCell *testSizeCell;

@end


@implementation HNCommentsContainerCell


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
    

    
    self.treeView = [[RATreeView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:RATreeViewStylePlain];
    self.treeView.translatesAutoresizingMaskIntoConstraints = NO;
    self.treeView.backgroundColor = [UIColor orangeColor];
    self.treeView.delegate = self;
    self.treeView.dataSource = self;
    self.treeView.estimatedRowHeight = 280;
    self.treeView.scrollEnabled = NO;
    self.treeView.treeFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.treeView.backgroundColor = [UIColor clearColor];
    self.treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
//    self.treeView.estimatedRowHeight = 200;
    
    
    [self.treeView registerClass:[HNCommentsReplyWithRepliesCell class] forCellReuseIdentifier:kHNCommentsReplyWithRepliesCell];
//    [self.treeView registerClass:[HNCommentsReplyTestCell class] forCellReuseIdentifier:@"Cell"];
//    [self.treeView registerNib:[UINib nibWithNibName:@"TestCell" bundle:nil] forCellReuseIdentifier:@"TestCell"];
    
//    self.testSizeCell = [[HNCommentsReplyWithRepliesCell alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];

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

//    DLogFunctionLine();
//    [self.treeView layoutIfNeeded];
//    [self.treeView setNeedsUpdateConstraints];
//    [self.treeView updateConstraintsIfNeeded];
//
    self.treeViewHeightConstraint.constant = self.treeView.contentSize.height;



    [self updateConstraintsIfNeeded];
}

-(void)updateConstraints {
    
    if (self.didSetupConstraints == NO) {
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kCommentsHorizontalInset];
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kCommentsHorizontalInset];
//        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kCommentsVerticalInset];
//        
//        [self.treeView autoPinEdgeToSuperviewEdge:ALEdgeTop];
//        [self.treeView autopin
//        [self.treeView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kCommentsHorizontalInset];
//        [self.treeView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kCommentsHorizontalInset];
//        [self.treeView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kCommentsVerticalInset];
        
        [self.treeView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        
//        
        [UIView autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
            [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kCommentsVerticalInset];
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
    
    HNCommentsReplyWithRepliesCell *cell = [treeView dequeueReusableCellWithIdentifier:kHNCommentsReplyWithRepliesCell];
    

    
    [cell configureWithViewModel:[self.viewModel repliesViewModelForRootComment:item.headComment]];
    


//    [cell setNeedsUpdateConstraints];
//    [cell updateConstraintsIfNeeded];
//    [cell layoutIfNeeded];
//    DLogNSSize(cell.commentTextView.bounds.size);
//    DLogNSSize(self.bounds.size);
//    DLogNSSize(self.treeView.contentSize);

    return cell;
}


//- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item {
//    
//    [cell layoutIfNeeded];
//    self.treeViewHeightConstraint.constant = self.treeView.contentSize.height;
////    DLogFunctionLine();
//}



- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(HNCommentThread *)item {
    
//    
//    
//    [self.testSizeCell configureWithViewModel:[self.viewModel repliesViewModelForRootComment:item.headComment]];
//    [self.testSizeCell setNeedsUpdateConstraints];
//    [self.testSizeCell updateConstraintsIfNeeded];
//    [self.testSizeCell layoutIfNeeded];
//    return [self.testSizeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    
    return [self.cellSizeManager cellHeightForObject:[self.viewModel repliesViewModelForRootComment:item.headComment] treeItem:item cellReuseIdentifier:kHNCommentsReplyWithRepliesCell];
}


- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item
{
    return NO;
}
@end