//
//  HNCommentsViewController.m
//  HackerNews
//
//  Created by Daniel on 4/5/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIColor+HNColorPalette.h"
#import "UIFont+HNFont.h"

//View
#import "HNCommentsViewController.h"
#import "HNTableView.h"
#import "HNCommentsContainerCell.h"
//#import "HNCommentsHeaderCell.h"
#import "HNCommentsCollectionViewHeader.h"

//View Model
#import "HNCommentsViewModel.h"
#import "HNCommentsCellViewModel.h"


#import "RZCellSizeManager.h"

NSString *const kCommentsCellIdentifier = @"CommentsCell";
NSString *const kCommentsHeaderCellIdentifier = @"HeaderCell";

@interface HNCommentsViewController () <UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSString *headerTitleText;

@property (nonatomic) CGFloat headerHeight;

//@property (nonatomic) HNCommentsHeaderCell *headerSizeCell;
//@property (nonatomic) HNCommentsCollectionViewHeader *headerSizeView;
@property (nonatomic) HNCommentsContainerCell *containerSizeCell;

@property (nonatomic) RZCellSizeManager *cellSizeManager;

@end

@implementation HNCommentsViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.viewModel.active = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor HNOffWhite];
    [self initalizeTableView];
    [self bindViewModel];
    
//    self.headerSizeView = [[HNCommentsCollectionViewHeader alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
//    self.containerSizeCell = [[HNCommentsContainerCell alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    
    self.cellSizeManager = [RZCellSizeManager new];
    [self.cellSizeManager registerCellClassName:NSStringFromClass([HNCommentsContainerCell class]) withNibNamed:nil forReuseIdentifier:kCommentsCellIdentifier withHeightBlock:^CGFloat(HNCommentsContainerCell *cell, HNCommentsCellViewModel *viewModel) {
        cell.viewModel = viewModel;
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }];
}

- (void)initalizeTableView {

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.972 green:0.198 blue:0.249 alpha:1.000];
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.allowsSelection = YES;
    self.tableView.estimatedRowHeight = 300;
//    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.tableView registerClass:[HNCommentsContainerCell class] forCellReuseIdentifier:kCommentsCellIdentifier];
    
//    [self.collectionView registerClass:[HNCommentsCollectionViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
//    flowLayout.minimumLineSpacing = 0.0;
//    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
}


- (void)bindViewModel {

    @weakify(self);
    
    [[[RACObserve(self.viewModel, commentCellViewModels) ignore:nil] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    self.title = self.viewModel.commentsCount;    
}


#pragma mark - IBActions
- (IBAction)backButtonDidTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (self.viewModel.commentCellViewModels.count > 0) {
//        return 2;
//    }
//    return 0;
    
    return self.viewModel.commentCellViewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HNCommentsContainerCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentsCellIdentifier forIndexPath:indexPath];
    cell.viewModel = self.viewModel.commentCellViewModels[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self.cellSizeManager cellHeightForObject:self.viewModel.commentCellViewModels[indexPath.row] indexPath:indexPath cellReuseIdentifier:kCommentsCellIdentifier];
    
}

#pragma mark -
#pragma mark - Table View Header
/*
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    HNCommentsCollectionViewHeader *cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    RAC(cell.titleLabel, text) = [RACObserve(self.viewModel, title) takeUntil:cell.rac_prepareForReuseSignal];
    RAC(cell.scoreLabel, text) = [RACObserve(self.viewModel, score) takeUntil:cell.rac_prepareForReuseSignal];
    RAC(cell.originationLabel, text) = [RACObserve(self.viewModel, info) takeUntil:cell.rac_prepareForReuseSignal];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat requiredWidth = collectionView.bounds.size.width;
    CGSize targetSize = CGSizeMake(requiredWidth, 0);
    self.headerSizeView.titleLabel.text = self.viewModel.title;
    self.headerSizeView.scoreLabel.text = self.viewModel.score;
    self.headerSizeView.originationLabel.text = self.viewModel.info;
    [self.headerSizeView setNeedsUpdateConstraints];
    [self.headerSizeView updateConstraintsIfNeeded];
    CGSize adequateSize = [self.headerSizeView preferredLayoutSizeFittingSize:targetSize];
    return adequateSize;
}

*/

@end
