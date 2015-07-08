//
//  HNCommentsCardView.m
//  
//
//  Created by Daniel on 7/7/15.
//
//

#import "UIColor+HNColorPalette.h"
#import "PureLayout.h"
#import "RZCellSizeManager.h"



// View
#import "HNCommentsCardView.h"
#import "HNCommentsReplyWithRepliesCell.h"

//View Model
#import "HNCommentsCellViewModel.h"
#import "HNCommentThread.h"


static NSString* const kHNCommentsReplyWithRepliesCell = @"HNCommentsReplyWithRepliesCell";

@interface HNCommentsCardView () <RATreeViewDataSource, RATreeViewDelegate>

@property (nonatomic) BOOL didSetupConstraints;
@property (nonatomic) HNCommentsCellViewModel *viewModel;
@property (nonatomic) RZCellSizeManager *cellSizeManager;
@property (nonatomic) NSLayoutConstraint *heightConstraint;

@end


@implementation HNCommentsCardView

- (instancetype)initWithViewModel:(HNCommentsCellViewModel *)viewModel {
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setup];
        [self setupTreeView];
        [self bindViewModel];
        self.viewModel = viewModel;
    }
    return self;
}

- (void)setup {
    
    self.didSetupConstraints = NO;
    
    self.backgroundColor = [UIColor HNWhite];
    self.layer.cornerRadius = 2.0;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor =  [UIColor colorWithRed:0.290 green:0.290 blue:0.290 alpha:0.2].CGColor;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius  = 4.0;
    self.layer.shadowOpacity = 0.05;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.masksToBounds = NO;
}

- (void)setupTreeView {
    
    self.treeView = [[RATreeView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:RATreeViewStylePlain];
    self.treeView.translatesAutoresizingMaskIntoConstraints = NO;
    self.treeView.backgroundColor = [UIColor clearColor];
    self.treeView.delegate = self;
    self.treeView.dataSource = self;
    self.treeView.estimatedRowHeight = 280;
    self.treeView.scrollEnabled = NO;
    self.treeView.treeFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    
    [self.treeView registerClass:[HNCommentsReplyWithRepliesCell class] forCellReuseIdentifier:kHNCommentsReplyWithRepliesCell];
    
    
    [self addSubview:self.treeView];
    
    
    self.cellSizeManager = [RZCellSizeManager new];
    [self.cellSizeManager registerCellClassName:NSStringFromClass([HNCommentsReplyWithRepliesCell class]) withNibNamed:nil forReuseIdentifier:kHNCommentsReplyWithRepliesCell withHeightBlock:^CGFloat(HNCommentsReplyWithRepliesCell *cell, HNRepliesCellViewModel *viewModel) {
        [cell configureWithViewModel:viewModel];
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }];
}

- (void)bindViewModel {
    
    @weakify(self);
    [[[RACObserve(self, viewModel) ignore:nil] deliverOnMainThread] subscribeNext:^(HNCommentsCellViewModel *x) {
        @strongify(self);
        [self.treeView reloadData];
        [self.treeView layoutIfNeeded];
        
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}


- (void)updateConstraints {
    if (self.didSetupConstraints == NO) {
        
        [self.treeView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.heightConstraint = [self autoSetDimension:ALDimensionHeight toSize:self.treeView.contentSize.height];

        self.didSetupConstraints = YES;
    }
    
    self.heightConstraint.constant = self.treeView.contentSize.height;
    
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
    
    cell.repliesButtonDidTapAction = ^(id sender){
        DLog(@"TAPPED!");
        
        [treeView expandRowForItem:item withRowAnimation:RATreeViewRowAnimationAutomatic];
        
        [self.cellSizeManager invalidateCellSizeCache];
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        [self layoutIfNeeded];
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];

    };
    
    return cell;
}


- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(HNCommentThread *)item {
    
    CGFloat height = [self.cellSizeManager cellHeightForObject:[self.viewModel repliesViewModelForRootComment:item.headComment] treeItem:item cellReuseIdentifier:kHNCommentsReplyWithRepliesCell];
    
    return height;
}

-  (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {
    
    DLogNSSize(self.treeView.contentSize);
//    self.treeViewHeightConstraint.constant = self.treeView.contentSize.height;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
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


@end
