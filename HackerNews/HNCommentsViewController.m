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
#import "RZCellSizeManager.h"


//View
#import "HNCommentsViewController.h"
//#import "HNTableView.h"
#import "HNCommentsContainerCell.h"
#import "HNCommentsHeaderCell.h"

//View Model
#import "HNCommentsViewModel.h"
#import "HNCommentsCellViewModel.h"



NSString *const kCommentsCellIdentifier = @"CommentsCell";
NSString *const kCommentsHeaderIdentifier = @"HeaderCell";

@interface HNCommentsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) HNCommentsHeaderCell *tableViewHeaderPrototypeCell;
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
    
    self.tableViewHeaderPrototypeCell = [[HNCommentsHeaderCell alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    
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
    self.tableView.contentInset = UIEdgeInsetsMake(74, 0, 0, 0);
    self.tableView.allowsSelection = YES;
    self.tableView.estimatedRowHeight = 300;
//    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.tableView registerClass:[HNCommentsContainerCell class] forCellReuseIdentifier:kCommentsCellIdentifier];
    [self.tableView registerClass:[HNCommentsHeaderCell class] forCellReuseIdentifier:kCommentsHeaderIdentifier];
}

- (void)bindViewModel {
    
    @weakify(self);
    
    [[[RACObserve(self.viewModel, commentCellViewModels) ignore:nil] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    self.title = self.viewModel.commentsCount;    
}

#pragma mark - <Table View Datasource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        // This is the faux table view header that is actually a cell.
        return 1;
    }
    
    return self.viewModel.commentCellViewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        // This is the faux table view header that is actually a cell.
        HNCommentsHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentsHeaderIdentifier forIndexPath:indexPath];
        RAC(cell.titleLabel, text) = [RACObserve(self.viewModel, title) takeUntil:cell.rac_prepareForReuseSignal];
        RAC(cell.scoreLabel, text) = [RACObserve(self.viewModel, score) takeUntil:cell.rac_prepareForReuseSignal];
        RAC(cell.originationLabel, text) = [RACObserve(self.viewModel, info) takeUntil:cell.rac_prepareForReuseSignal];
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        return cell;
    }
    
    HNCommentsContainerCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentsCellIdentifier forIndexPath:indexPath];
    cell.viewModel = self.viewModel.commentCellViewModels[indexPath.row];
    return cell;
}


#pragma mark - <Table View Delegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        // This is the faux table view header that is actually a cell.
        CGFloat requiredWidth = tableView.bounds.size.width;
        CGSize targetSize = CGSizeMake(requiredWidth, 0);
        self.tableViewHeaderPrototypeCell.titleLabel.text = self.viewModel.title;
        self.tableViewHeaderPrototypeCell.scoreLabel.text = self.viewModel.score;
        self.tableViewHeaderPrototypeCell.originationLabel.text = self.viewModel.info;
        [self.tableViewHeaderPrototypeCell setNeedsUpdateConstraints];
        [self.tableViewHeaderPrototypeCell updateConstraintsIfNeeded];
        CGSize adequateSize = [self.tableViewHeaderPrototypeCell preferredLayoutSizeFittingSize:targetSize];
        return adequateSize.height;
    }
    
    return [self.cellSizeManager cellHeightForObject:self.viewModel.commentCellViewModels[indexPath.row] indexPath:indexPath cellReuseIdentifier:kCommentsCellIdentifier];
    
}

#pragma mark - IBActions
- (IBAction)backButtonDidTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
