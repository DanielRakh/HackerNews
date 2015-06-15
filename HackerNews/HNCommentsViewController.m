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
#import "HNCommentsCell.h"

//View Model
#import "HNCommentsViewModel.h"
#import "HNCommentsCellViewModel.h"

NSString *const kCommentsCellIdentifier = @"CommentsCell";

@interface HNCommentsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet HNTableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *originationLabel;

@property (nonatomic) NSMutableDictionary *indexPathsToExpand;


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
    [self setupHeaderView];
    [self initalizeTableView];
    [self bindViewModel];
    
    
    // We need to "rejigger" the header view because Autolayout is fucking shit.
    [self rejiggerTableHeaderView];
    
    
    self.indexPathsToExpand = [NSMutableDictionary dictionary];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectIndexPathsToExpand:) name:@"IndexPathsToExpand" object:nil];
    
}



- (void)collectIndexPathsToExpand:(NSNotification *)notification {
    
    NSDictionary *dict = notification.userInfo;
    NSIndexPath *idxPath = dict[@"IndexPath"];
    
    
    if ([self.indexPathsToExpand objectForKey:@(idxPath.row)] == nil) {
        self.indexPathsToExpand[@(idxPath.row)] = idxPath;
    }
    
    NSLog(@"%@",self.indexPathsToExpand);
}


- (void)setupHeaderView {
    
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
    
    
    self.titleLabel.textColor = [UIColor darkTextColor];
    self.originationLabel.textColor = [UIColor HNLightGray];
    self.scoreLabel.textColor = [UIColor HNOrange];
    
}


- (void)rejiggerTableHeaderView
{
    self.tableView.tableHeaderView = nil;
    
    UIView *header = self.headerView;
    CGRect frame = header.frame;
    frame.size.width = self.tableView.frame.size.width;
    header.frame = frame;
    
    [header setNeedsLayout];
    [header layoutIfNeeded];
    
    CGFloat height = [self.cardView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    CGRect headerFrame = header.frame;
    headerFrame.size.height = height;
    
    header.frame = headerFrame;
    
    self.tableView.tableHeaderView = header;
}

- (void)initalizeTableView {

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = YES;

    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[HNCommentsCell class] forCellReuseIdentifier:kCommentsCellIdentifier];

}


- (void)bindViewModel {

    @weakify(self);
    [[[RACObserve(self.viewModel, commentThreads) deliverOnMainThread] ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
        [self.tableView layoutIfNeeded];

    } completed:^{

    }];

    
    RAC(self, title) = RACObserve(self.viewModel, commentsCount);
    RAC(self.titleLabel, text) = RACObserve(self.viewModel, title);
    RAC(self.scoreLabel, text) = RACObserve(self.viewModel, score);
    RAC(self.originationLabel, text) = RACObserve(self.viewModel, info);
    

}

- (IBAction)backButtonDidTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

//
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    [self.tableView reloadData];
    
    NSLog(@"LAYOUT SUBVIEWS");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.commentThreads.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HNCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentsCellIdentifier forIndexPath:indexPath];
    
//    if ([cell.treeView isCellForItemExpanded:cell.viewModel.commentThreadArray.firstObject]) {
//        NSLog(@"EXPANDED");
//        [cell keepCellExpanded];
//    }
//    
  
    cell.viewModel = self.viewModel.commentThreads[indexPath.row];
    
    
//    for (NSIndexPath *idxPath in self.indexPathsToExpand) {
//        if (indexPath.row == idxPath.row) {
//            [cell keepCellExpanded];
//        }
//    }
//    
    
    if (self.indexPathsToExpand[@(indexPath.row)] != nil) {
        
        [cell keepCellExpanded];
    }
    

    
 

    
    [cell setNeedsUpdateConstraints];
    
    return cell;
}



- (void)repliesDidTap:(NSNotification *)notification {
    NSLog(@"REPLIES");
    
//    NSDictionary *dict = notification.userInfo;
//    self.expandedRows = dict[@"itemsToExpand"];
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    

}
@end
