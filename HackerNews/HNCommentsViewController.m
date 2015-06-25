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
#import "HNCommentsCollectionViewHeader.h"

//View Model
#import "HNCommentsViewModel.h"
#import "HNCommentsCellViewModel.h"

NSString *const kCommentsCellIdentifier = @"CommentsCell";

@interface HNCommentsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;



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

    
//    [self setupHeaderView];
    [self initalizeCollectionView];
    [self bindViewModel];
    
    
    // We need to "rejigger" the header view because Autolayout is fucking shit.
//    [self rejiggerTableHeaderView];
    
    
//    self.indexPathsToExpand = [NSMutableDictionary dictionary];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectIndexPathsToExpand:) name:@"IndexPathsToExpand" object:nil];
    
}



//- (void)collectIndexPathsToExpand:(NSNotification *)notification {
//    
//    NSDictionary *dict = notification.userInfo;
//    NSIndexPath *idxPath = dict[@"IndexPath"];
//    
//    
//    if ([self.indexPathsToExpand objectForKey:@(idxPath.row)] == nil) {
//        self.indexPathsToExpand[@(idxPath.row)] = idxPath;
//    }
//    
////    NSLog(@"%@",self.indexPathsToExpand);
//}


//- (void)setupHeaderView {
//    
//    self.cardView.backgroundColor = [UIColor HNWhite];
//    self.cardView.layer.cornerRadius = 2.0;
//    self.cardView.layer.borderWidth = 0.5;
//    self.cardView.layer.borderColor =  [UIColor colorWithRed:0.290 green:0.290 blue:0.290 alpha:0.2].CGColor;
//    self.cardView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.cardView.layer.shadowRadius  = 4.0;
//    self.cardView.layer.shadowOpacity = 0.05;
//    self.cardView.layer.shadowOffset = CGSizeMake(0, 1);
//    self.cardView.layer.shouldRasterize = YES;
//    self.cardView.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    self.cardView.layer.masksToBounds = NO;
//    
//    
//    self.titleLabel.textColor = [UIColor darkTextColor];
//    self.originationLabel.textColor = [UIColor HNLightGray];
//    self.scoreLabel.textColor = [UIColor HNOrange];
//    
//}


//- (void)rejiggerTableHeaderView
//{
//    self.tableView.tableHeaderView = nil;
//    
//    UIView *header = self.headerView;
//    CGRect frame = header.frame;
//    frame.size.width = self.tableView.frame.size.width;
//    header.frame = frame;
//    
//    [header setNeedsLayout];
//    [header layoutIfNeeded];
//    
//    CGFloat height = [self.cardView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    
//    CGRect headerFrame = header.frame;
//    headerFrame.size.height = height;
//    
//    header.frame = headerFrame;
//    
//    self.tableView.tableHeaderView = header;
//    
//    [self.tableView layoutIfNeeded];
//}

- (void)initalizeCollectionView {

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.collectionView.allowsSelection = YES;

    [self.collectionView registerClass:[HNCommentsContainerCell class] forCellWithReuseIdentifier:kCommentsCellIdentifier];
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.estimatedItemSize = CGSizeMake(320, 200);
}


- (void)bindViewModel {

    @weakify(self);
    
    [[[RACObserve(self.viewModel, commentCellViewModels) deliverOnMainThread] ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];

    
    RAC(self, title) = RACObserve(self.viewModel, commentsCount);
//    RAC(self.titleLabel, text) = RACObserve(self.viewModel, title);
//    RAC(self.scoreLabel, text) = RACObserve(self.viewModel, score);
//    RAC(self.originationLabel, text) = RACObserve(self.viewModel, info);
    
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    [self.tableView reloadData];
//    
//}

#pragma mark - IBActions
- (IBAction)backButtonDidTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (UICollectionReusableView *)collectionView:(nonnull UICollectionView *)collectionView viewForSupplementaryElementOfKind:(nonnull NSString *)kind atIndexPath:(nonnull NSIndexPath *)indexPath {
    
    HNCommentsCollectionViewHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    
    
    RAC(header.titleLabel, text) = [RACObserve(self.viewModel, title) takeUntil:header.rac_prepareForReuseSignal];
    
    RAC(header.scoreLabel, text) = [RACObserve(self.viewModel, score) takeUntil:header.rac_prepareForReuseSignal];
    RAC(header.originationLabel, text) = [RACObserve(self.viewModel, info) takeUntil:header.rac_prepareForReuseSignal];
    
    [header setNeedsUpdateConstraints];
    [header updateConstraintsIfNeeded];
    
    return header;
}

//- (void)repliesDidTap:(NSNotification *)notification {
//    NSLog(@"REPLIES");
//    
////    NSDictionary *dict = notification.userInfo;
////    self.expandedRows = dict[@"itemsToExpand"];
//    
//    [self.tableView beginUpdates];
//    [self.tableView endUpdates];
//
//}



@end
