//
//  HNCommentsThreadCardView.m
//  
//
//  Created by Daniel on 7/9/15.
//
//

#import "HNCommentsThreadCardView.h"

@implementation HNCommentsThreadCardView


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


@end
