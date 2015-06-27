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
#import "HNCommentsHeaderCell.h"
//#import "HNCommentsCollectionViewHeader.h"

//View Model
#import "HNCommentsViewModel.h"
#import "HNCommentsCellViewModel.h"

NSString *const kCommentsCellIdentifier = @"CommentsCell";
NSString *const kCommentsHeaderCellIdentifier = @"HeaderCell";

@interface HNCommentsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSString *headerTitleText;

@property (nonatomic) CGFloat headerHeight;

@property (nonatomic) HNCommentsHeaderCell *headerSizeCell;
@property (nonatomic) HNCommentsContainerCell *containerSizeCell;

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
    
    self.headerSizeCell = [[HNCommentsHeaderCell alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.containerSizeCell = [[HNCommentsContainerCell alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
}


- (void)initalizeCollectionView {

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.collectionView.allowsSelection = YES;

    [self.collectionView registerClass:[HNCommentsContainerCell class] forCellWithReuseIdentifier:kCommentsCellIdentifier];
    [self.collectionView registerClass:[HNCommentsHeaderCell class] forCellWithReuseIdentifier:kCommentsHeaderCellIdentifier];
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"TestCell"];
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
}


- (void)bindViewModel {

    @weakify(self);
    
    [[[RACObserve(self.viewModel, commentCellViewModels) deliverOnMainThread] ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
        
    }];

    RAC(self, title) = RACObserve(self.viewModel, commentsCount);
    
}


#pragma mark - IBActions
- (IBAction)backButtonDidTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    
    return self.viewModel.commentCellViewModels.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        HNCommentsHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCommentsHeaderCellIdentifier forIndexPath:indexPath];
        RAC(cell.titleLabel, text) = [RACObserve(self.viewModel, title) takeUntil:cell.rac_prepareForReuseSignal];
        RAC(cell.scoreLabel, text) = [RACObserve(self.viewModel, score) takeUntil:cell.rac_prepareForReuseSignal];
        RAC(cell.originationLabel, text) = [RACObserve(self.viewModel, info) takeUntil:cell.rac_prepareForReuseSignal];
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        return cell;

    } else {
        HNCommentsContainerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCommentsCellIdentifier forIndexPath:indexPath];
        cell.viewModel = self.viewModel.commentCellViewModels[indexPath.row];
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
     let requiredWidth = collectionView.bounds.size.width
     
     // NOTE: here is where we ask our sizing cell to compute what height it needs
     let targetSize = CGSize(width: requiredWidth, height: 0)
     /// NOTE: populate the sizing cell's contents so it can compute accurately
     self.sizingCell.label.text = items[indexPath.row]
     let adequateSize = self.sizingCell.preferredLayoutSizeFittingSize(targetSize)
     return adequateSize
     */
    
    if (indexPath.section == 0) {
        CGFloat requiredWidth = collectionView.bounds.size.width;
        CGSize targetSize = CGSizeMake(requiredWidth, 0);
        self.headerSizeCell.titleLabel.text = self.viewModel.title;
        self.headerSizeCell.scoreLabel.text = self.viewModel.score;
        self.headerSizeCell.originationLabel.text = self.viewModel.info;
        [self.headerSizeCell setNeedsUpdateConstraints];
        [self.headerSizeCell updateConstraintsIfNeeded];
        CGSize adequateSize = [self.headerSizeCell preferredLayoutSizeFittingSize:targetSize];
        return adequateSize;
    } else {
        CGFloat requiredWidth = collectionView.bounds.size.width;
        CGSize targetSize = CGSizeMake(requiredWidth, 0);
        self.containerSizeCell.viewModel = self.viewModel.commentCellViewModels[indexPath.row];
        [self.containerSizeCell setNeedsUpdateConstraints];
        [self.containerSizeCell updateConstraintsIfNeeded];
        CGSize adequateSize = [self.containerSizeCell preferredLayoutSizeFittingSize:targetSize];
        return adequateSize;
    }


    
}



@end
