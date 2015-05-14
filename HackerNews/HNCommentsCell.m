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



CGFloat const kCommentsVerticalInset = 10;
CGFloat const kCommentsHorizontalInset = 8;


@interface HNCommentsCell () <RATreeViewDataSource, RATreeViewDelegate>

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (nonatomic) UIView *cardView;

@property (nonatomic) HNCommentsCellViewModel *viewModel;

@property (nonatomic) RATreeView *treeView;

@property (nonatomic) NSLayoutConstraint *treeViewHeightConstraint;

@property (nonatomic) NSArray *tstArray;

@property (strong, nonatomic) NSMutableDictionary *offscreenCells;



@end


@implementation HNCommentsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initalizeViews];
        self.offscreenCells = [NSMutableDictionary dictionary];

    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initalizeViews];
        self.offscreenCells = [NSMutableDictionary dictionary];

    }
    return self;
}



- (void)configureWithViewModel:(HNCommentsCellViewModel *)viewModel {
   
    self.viewModel = viewModel;
    self.viewModel.active = YES;
    
    @weakify(self);
    [[RACObserve(self.viewModel, commentThreadArray) deliverOnMainThread] subscribeNext:^(NSArray *x) {
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
    self.treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    [self.treeView registerClass:[HNRepliesCell class] forCellReuseIdentifier:@"Cell"];
    
    [self.cardView addSubview:self.treeView];
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self.treeView layoutIfNeeded];
}

-(void)updateConstraints {
    

    if (self.didSetupConstraints == NO) {
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kCommentsHorizontalInset];
        [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kCommentsHorizontalInset];
        
        
        [self.treeView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kCommentsVerticalInset];
        [self.treeView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kCommentsHorizontalInset];
        [self.treeView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kCommentsHorizontalInset];
        [self.treeView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kCommentsVerticalInset];
        
        
        
        [UIView autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
            
            [self.cardView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kCommentsVerticalInset];
            
        }];
        
        
        self.didSetupConstraints = YES;
    }
    

    if (!self.treeViewHeightConstraint) {
        self.treeViewHeightConstraint = [self.treeView autoSetDimension:ALDimensionHeight toSize:self.treeView.contentSize.height];
    } else {
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



- (void)treeView:(RATreeView *)treeView didExpandRowForItem:(id)item {
    NSLog(@"EXPAND");
    

    [[NSNotificationCenter defaultCenter]postNotificationName:@"RepliesButtonTapped" object:nil];

}


@end