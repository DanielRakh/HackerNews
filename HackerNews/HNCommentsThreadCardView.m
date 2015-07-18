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
//static NSString* const kHNCommentsReplyWithRepliesCell = @"HNCommentsReplyWithRepliesCell";


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
    self.cellSizeManager.cellHeightPadding = 1;
    
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
    
    
    HNRepliesCellViewModel *repliesViewModel = [self.viewModel repliesViewModelForRootComment:item.headComment];
    repliesViewModel.treeLevel = [treeView levelForCellForItem:item];
    
    
    DLogNSInteger(repliesViewModel.treeLevel);
   
    if ([treeView parentForItem:item] == nil) {
        
        if (item.replies.count > 0) {
            HNCommentsCommentWithRepliesCell *cell = [treeView dequeueReusableCellWithIdentifier:kHNCommentsCommentWithRepliesCell];
            [cell configureWithViewModel:repliesViewModel];
            [cell setNeedsUpdateConstraints];
            [cell updateConstraintsIfNeeded];
            
            
            if ([cell isKindOfClass:[HNCommentsCommentWithRepliesCell class]]) {
                
                cell.repliesButtonDidTapAction = ^(id sender){
                    [treeView reloadRows];

                    [treeView expandRowForItem:item expandChildren:YES withRowAnimation:RATreeViewRowAnimationNone];
                    
    
                    [treeView reloadRows];
          
                    
                    [self.treeView layoutIfNeeded];
                    [self setNeedsLayout];
                    [treeView reloadRows];

                    [self layoutIfNeeded];

                    
                    
                    [self setNeedsUpdateConstraints];
                    [self updateConstraintsIfNeeded];
                    DLogNSSize(self.treeView.bounds.size);
                    DLogNSSize(self.treeView.contentSize);
                    
                };
            }
            
            return cell;

        } else {
            HNCommentsCommentCell *cell = [treeView dequeueReusableCellWithIdentifier:kHNCommentsCommentCell];
            [cell configureWithViewModel:repliesViewModel];
            [cell setNeedsUpdateConstraints];
            [cell updateConstraintsIfNeeded];
            
            
            return cell;
        }
        
    } else {
         
        HNCommentsCommentReplyCell *cell = [treeView dequeueReusableCellWithIdentifier:kHNCommentsCommentReplyCell];
        cell.treeLevel = [treeView levelForCellForItem:item];
        [cell configureWithViewModel:repliesViewModel];
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        [cell layoutIfNeeded];
        
        
        return cell;
        
        
        
    }
}

- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(HNCommentThread *)item {
    
    CGFloat height;
    HNRepliesCellViewModel *repliesViewModel = [self.viewModel repliesViewModelForRootComment:item.headComment];
    repliesViewModel.treeLevel = [treeView levelForCellForItem:item];
//    repliesViewModel.treeLevel = 1;

    if ([treeView parentForItem:item] == nil) {
        if (item.replies.count > 0) {
            height = [self.cellSizeManager cellHeightForObject:repliesViewModel treeItem:item cellReuseIdentifier:kHNCommentsCommentWithRepliesCell];
        } else {
            height = [self.cellSizeManager cellHeightForObject:repliesViewModel treeItem:item cellReuseIdentifier:kHNCommentsCommentCell];
        }
       
    } else {

        
        height = [self.cellSizeManager cellHeightForObject:repliesViewModel treeItem:item cellReuseIdentifier:kHNCommentsCommentReplyCell];
    }

    return height;
}

-  (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item {
    return NO;
}


- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item {
    DLog(@"WILL EXPAND!");
}

- (void)treeView:(RATreeView *)treeView didExpandRowForItem:(id)item {

}



@end
