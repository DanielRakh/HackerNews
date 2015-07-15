//
//  HNCommentsThreadCardView.m
//  
//
//  Created by Daniel on 7/9/15.
//
//

#import "UIColor+HNColorPalette.h"

#import "PureLayout.h"
#import "RZCellSizeManager.h"

//View
#import "HNCommentsThreadCardView.h"

#import "HNCommentsCommentCell.h"
#import "HNCommentsCommentWithRepliesCell.h"
#import "HNCommentsCommentReplyCell.h"
#import "HNCommentsCommentReplyWithRepliesCell.h"

//View Model
#import "HNCommentsCellViewModel.h"
#import "HNCommentThread.h"
#import "HNRepliesCellViewModel.h"

static NSString* const kHNCommentsCommentCell = @"HNCommentsCommentCell";
static NSString* const kHNCommentsCommentWithRepliesCell = @"HNCommentsCommentWithRepliesCell";
static NSString* const kHNCommentsCommentReplyCell = @"HNCommentsCommentReplyCell";
static NSString* const kHNCommentsReplyWithRepliesCell = @"HNCommentsReplyWithRepliesCell";


@interface HNCommentsThreadCardView () <RATreeViewDataSource, RATreeViewDelegate>

@property (nonatomic) BOOL didSetupConstraints;
@property (nonatomic) HNCommentsCellViewModel *viewModel;
@property (nonatomic) RZCellSizeManager *cellSizeManager;
@property (nonatomic) NSLayoutConstraint *heightConstraint;

@end

@implementation HNCommentsThreadCardView


- (instancetype)initWithViewModel:(HNCommentsCellViewModel *)viewModel {
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.didSetupConstraints = NO;
        [self setupTreeView];
        [self bindViewModel];
        self.viewModel = viewModel;
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

- (void)updateConstraints {
    if (self.didSetupConstraints == NO) {
        
        [self.treeView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        self.heightConstraint = [self autoSetDimension:ALDimensionHeight toSize:self.treeView.contentSize.height];
        
        self.didSetupConstraints = YES;
    }
    
    self.heightConstraint.constant = self.treeView.contentSize.height;
    
    [super updateConstraints];
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
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
    self.treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    
    [self.treeView registerClass:[HNCommentsCommentWithRepliesCell class] forCellReuseIdentifier:kHNCommentsCommentWithRepliesCell];
//    [self.treeView registerClass:[HNCommentsCommentReplyWithRepliesCell class] forCellReuseIdentifier:kHNCommentsReplyWithRepliesCell];
    [self.treeView registerClass:[HNCommentsCommentCell class] forCellReuseIdentifier:kHNCommentsCommentCell];
    [self.treeView registerClass:[HNCommentsCommentReplyCell class] forCellReuseIdentifier:kHNCommentsCommentReplyCell];
    
    [self addSubview:self.treeView];
    
    
    // We cache the cell heights for better performance. 
    self.cellSizeManager = [RZCellSizeManager new];
    
    [self.cellSizeManager registerCellClassName:NSStringFromClass([HNCommentsCommentWithRepliesCell class]) withNibNamed:nil forReuseIdentifier:kHNCommentsCommentWithRepliesCell withConfigurationBlock:^(HNCommentsCommentWithRepliesCell *cell, HNRepliesCellViewModel *viewModel) {
        [cell configureWithViewModel:viewModel];
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
//        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }];
    
//    [self.cellSizeManager registerCellClassName:NSStringFromClass([HNCommentsCommentReplyWithRepliesCell class]) withNibNamed:nil forReuseIdentifier:kHNCommentsReplyWithRepliesCell withHeightBlock:^CGFloat(HNCommentsCommentReplyWithRepliesCell *cell, HNRepliesCellViewModel *viewModel) {
//        [cell configureWithViewModel:viewModel];
//        [cell setNeedsUpdateConstraints];
//        [cell updateConstraintsIfNeeded];
//        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    }];
    
    [self.cellSizeManager registerCellClassName:NSStringFromClass([HNCommentsCommentCell class]) withNibNamed:nil forReuseIdentifier:kHNCommentsCommentCell withConfigurationBlock:^(HNCommentsCommentCell *cell, HNRepliesCellViewModel *viewModel) {
        [cell configureWithViewModel:viewModel];
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
//        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }];
    
    [self.cellSizeManager registerCellClassName:NSStringFromClass([HNCommentsCommentReplyCell class]) withNibNamed:nil forReuseIdentifier:kHNCommentsCommentReplyCell withConfigurationBlock:^(HNCommentsCommentReplyCell *cell, HNRepliesCellViewModel *viewModel) {
//        [cell setupThreadLinesForLevel:[self.treeView levelForCell:cell]];
//        [self.treeView levelForCellForItem:self.viewModel.commentThreadArray]
//        cell.treeLevel = [self.treeView levelForCell:cell];
        [cell configureWithViewModel:viewModel];
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
//        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }];

    
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
    
    HNCommentsCommentWithRepliesCell *cell;
    if ([treeView parentForItem:item] == nil) {
        
        
        if (item.replies.count > 0) {
            cell = [treeView dequeueReusableCellWithIdentifier:kHNCommentsCommentWithRepliesCell];
        } else {
            cell = [treeView dequeueReusableCellWithIdentifier:kHNCommentsCommentCell];
        }
        
        [cell configureWithViewModel:[self.viewModel repliesViewModelForRootComment:item.headComment]];

        
        
    } else {
         
        cell = [treeView dequeueReusableCellWithIdentifier:kHNCommentsCommentReplyCell];
        
//        [(HNCommentsCommentReplyCell *)cell setupThreadLinesForLevel:[treeView levelForCellForItem:item]];

        
//        [(HNCommentsCommentReplyCell *)cell setTreeLevel:[treeView levelForCellForItem:item]];
        
        
//        if (item.replies.count > 0) {
//            cell = [treeView dequeueReusableCellWithIdentifier:kHNCommentsReplyWithRepliesCell];
//        } else {
//            cell = [treeView dequeueReusableCellWithIdentifier:kHNCommentsCommentReplyCell];
//        }
        
        HNRepliesCellViewModel *repliesViewModel = [self.viewModel repliesViewModelForRootComment:item.headComment];
        repliesViewModel.treeLevel = [treeView levelForCellForItem:item];
        [cell configureWithViewModel:repliesViewModel];

        
        
    }
    
    
    
    if ([cell isKindOfClass:[HNCommentsCommentWithRepliesCell class]] || [cell isKindOfClass:[HNCommentsCommentReplyWithRepliesCell class]]) {
        cell.repliesButtonDidTapAction = ^(id sender){
           
//            DLog(@"TAPPED!");
            
            [treeView expandRowForItem:item expandChildren:YES withRowAnimation:RATreeViewRowAnimationAutomatic];
            
            //        [self.cellSizeManager invalidateCellSizeCache];
            [self.treeView layoutIfNeeded];
            [self setNeedsUpdateConstraints];
            [self updateConstraintsIfNeeded];
            [self.treeView layoutIfNeeded];
            [self layoutIfNeeded];
            [self setNeedsUpdateConstraints];
            [self updateConstraintsIfNeeded];
            
        };
    }
    
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(HNCommentThread *)item {
    
    CGFloat height;
    if ([treeView parentForItem:item] == nil) {
        if (item.replies.count > 0) {
            height = [self.cellSizeManager cellHeightForObject:[self.viewModel repliesViewModelForRootComment:item.headComment] treeItem:item cellReuseIdentifier:kHNCommentsCommentWithRepliesCell];
        } else {
            height = [self.cellSizeManager cellHeightForObject:[self.viewModel repliesViewModelForRootComment:item.headComment] treeItem:item cellReuseIdentifier:kHNCommentsCommentCell];
        }
       
    } else {
//        if (item.replies.count > 0) {
//            height = [self.cellSizeManager cellHeightForObject:[self.viewModel repliesViewModelForRootComment:item.headComment] treeItem:item cellReuseIdentifier:kHNCommentsReplyWithRepliesCell];
//        } else {
        
        HNRepliesCellViewModel *repliesViewModel = [self.viewModel repliesViewModelForRootComment:item.headComment];
        repliesViewModel.treeLevel = [treeView levelForCellForItem:item];
        
        height = [self.cellSizeManager cellHeightForObject:repliesViewModel treeItem:item cellReuseIdentifier:kHNCommentsCommentReplyCell];
//        }

    }
  
    
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
