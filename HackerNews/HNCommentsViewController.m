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

@interface HNCommentsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSString *headerTitleText;

@property (nonatomic) CGFloat headerHeight;



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
//    [self rejiggerTableHeaderView];
    
    
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


- (void)rejiggerTableHeaderView
{
    
    UIView *header = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:nil];
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
}

- (void)initalizeCollectionView {

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
//    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.allowsSelection = YES;

    [self.collectionView registerClass:[HNCommentsContainerCell class] forCellWithReuseIdentifier:kCommentsCellIdentifier];
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.estimatedItemSize = CGSizeMake(self.view.bounds.size.width, 300);
    

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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];


    
}


#pragma mark - IBActions
- (IBAction)backButtonDidTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.viewModel.commentCellViewModels.count;
    return 0;
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

    @weakify(self);
    RAC(header.titleLabel, text) = [[RACObserve(self.viewModel, title) takeUntil:header.rac_prepareForReuseSignal] doNext:^(id x) {
        @strongify(self);
        self.headerTitleText = x;
    }];
    RAC(header.scoreLabel, text) = [RACObserve(self.viewModel, score) takeUntil:header.rac_prepareForReuseSignal];
    RAC(header.originationLabel, text) = [RACObserve(self.viewModel, info) takeUntil:header.rac_prepareForReuseSignal];
    
    
    [header.cardView setNeedsUpdateConstraints];
    [header.cardView updateConstraintsIfNeeded];
    [header.cardView layoutIfNeeded];
    [header setNeedsUpdateConstraints];
    [header updateConstraintsIfNeeded];
    [header layoutIfNeeded];
//    [header.titleLabel setPreferredMaxLayoutWidth:header.cardView.bounds.size.width - 16];

    
    return header;
}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    
//    HNCommentsCollectionViewHeader *header = [[HNCommentsCollectionViewHeader alloc]init];
//        CGRect frame = header.frame;
//        frame.size.width = self.collectionView.frame.size.width;
//        header.frame = frame;
//    //
//        [header setNeedsLayout];
//        [header layoutIfNeeded];
//    //
//        CGFloat height = [header.cardView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    //
////        CGRect headerFrame = header.frame;
////        headerFrame.size.height = height;
////    //
////        header.frame = headerFrame;
////    //
////    //    self.tableView.tableHeaderView = header;
////    //    
////    //    [self.tableView layoutIfNeeded];
//
//    return CGSizeMake(collectionView.bounds.size.width, height);
//    
//    
//}


//func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//    // that -16 is because I have 8px for left and right spacing constraints for the label.
//    let label:UILabel = UILabel(frame: CGRectMake(0, 0, collectionView.frame.width - 16, CGFloat.max))
//    label.numberOfLines = 0
//    label.lineBreakMode = NSLineBreakMode.ByWordWrapping
//    //here, be sure you set the font type and size that matches the one set in the storyboard label
//    label.font = UIFont(name: "Helvetica", size: 17.0)
//    label.text = questions[section]
//    label.sizeToFit()
//    
//    // Set some extra pixels for height due to the margins of the header section.
//    //This value should be the sum of the vertical spacing you set in the autolayout constraints for the label. + 16 worked for me as I have 8px for top and bottom constraints.
//    return CGSize(width: collectionView.frame.width, height: label.frame.height + 16)
//}

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
