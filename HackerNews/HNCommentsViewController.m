//
//  HNCommentsViewController.m
//  HackerNews
//
//  Created by Daniel on 4/5/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIColor+HNColorPalette.h"



//View
#import "HNCommentsViewController.h"
#import "HNTableView.h"
#import "HNCommentsCell.h"

//View Model
#import "HNCommentsViewModel.h"

NSString *const kCommentsCellIdentifier = @"CommentsCell";

@interface HNCommentsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet HNTableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *originationLabel;


@end

@implementation HNCommentsViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.viewModel.active = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor HNOffWhite];
    [self setupHeaderView];
    [self initalizeTableView];
    [self bindViewModel];
    [self rejiggerTableHeaderView];
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
    
    CGFloat height = [header systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    CGRect headerFrame = header.frame;
    headerFrame.size.height = height;
    
    header.frame = headerFrame;
    
    self.tableView.tableHeaderView = header;
}

- (void)initalizeTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 118;
    [self.tableView registerClass:[HNCommentsCell class] forCellReuseIdentifier:kCommentsCellIdentifier];
}

- (void)bindViewModel {
    
    @weakify(self);
    [self.viewModel.updatedContentSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    self.title = self.viewModel.commentsCount;
    self.titleLabel.text = self.viewModel.title;
    self.scoreLabel.text = self.viewModel.score;
    self.originationLabel.text = self.viewModel.info;
}

- (IBAction)backButtonDidTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HNCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentsCellIdentifier forIndexPath:indexPath];
    [cell configureWithViewModel:[self.viewModel commentsCellViewModelForIndexPath:indexPath]];

    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}


@end
