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

@interface HNCommentsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSString *headerTitleText;

@property (nonatomic) CGFloat headerHeight;

//@property (nonatomic) HNCommentsHeaderCell *headerSizeCell;
@property (nonatomic) HNCommentsCollectionViewHeader *headerSizeView;
@property (nonatomic) HNCommentsContainerCell *containerSizeCell;

@property (nonatomic) RZCellSizeManager *cellSizeManager;

@end

@implementation HNCommentsViewController

//-(void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.viewModel.active = YES;
//
//}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.viewModel.active = NO;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor HNOffWhite];
    [self initalizeCollectionView];
    [self bindViewModel];
    
    self.headerSizeView = [[HNCommentsCollectionViewHeader alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
//    self.containerSizeCell = [[HNCommentsContainerCell alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    
//    self.cellSizeManager = [RZCellSizeManager new];
//    
//    [self.cellSizeManager registerCellClassName:NSStringFromClass([HNCommentsContainerCell class]) withNibNamed:nil forReuseIdentifier:kCommentsCellIdentifier withSizeBlock:^CGSize(id cell, id object) {
//        CGFloat requiredWidth = self.collectionView.bounds.size.width;
//        CGSize targetSize = CGSizeMake(requiredWidth, 0);
//        self.containerSizeCell.viewModel = object;
//        [self.containerSizeCell setNeedsUpdateConstraints];
//        [self.containerSizeCell updateConstraintsIfNeeded];
////        [self.containerSizeCell setNeedsLayout];
////        [self.containerSizeCell layoutIfNeeded];
//        CGSize adequateSize = [self.containerSizeCell preferredLayoutSizeFittingSize:targetSize];
//        return adequateSize;
//    }];
}


- (void)initalizeCollectionView {

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.collectionView.allowsSelection = YES;

    [self.collectionView registerClass:[HNCommentsContainerCell class] forCellWithReuseIdentifier:kCommentsCellIdentifier];
    [self.collectionView registerClass:[HNCommentsCollectionViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.estimatedItemSize = CGSizeMake(self.view.bounds.size.width, 200);
}


- (void)bindViewModel {

    @weakify(self);
    
    [[[RACObserve(self.viewModel, commentCellViewModels) deliverOnMainThread] ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
        
    }];
    
    
    self.title = self.viewModel.commentsCount;    
}


#pragma mark - IBActions
- (IBAction)backButtonDidTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    [self.cellSizeManager invalidateCellSizeCache];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.viewModel.commentCellViewModels.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    HNCommentsContainerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCommentsCellIdentifier forIndexPath:indexPath];
    cell.viewModel = self.viewModel.commentCellViewModels[indexPath.row];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    CGSize cellSize = [self.cellSizeManager cellSizeForObject:self.viewModel.commentCellViewModels[indexPath.item] indexPath:indexPath cellReuseIdentifier:kCommentsCellIdentifier];
//    
//    DLogNSSize(cellSize);
//    
//    return cellSize;
//}



#pragma mark -
#pragma mark - Collection View Header

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

@end
