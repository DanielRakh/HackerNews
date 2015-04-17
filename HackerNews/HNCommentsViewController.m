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

@property (weak, nonatomic) IBOutlet UIView *containerHeader;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *originationLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsCountLabel;


@end

@implementation HNCommentsViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.viewModel.active = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor HNOffWhite];
    self.containerHeader.backgroundColor = [UIColor HNWhite];
    self.navigationController.navigationBarHidden = YES;
    [self setupHeaderView];
    [self initalizeTableView];
    [self bindViewModel];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)setupHeaderView {
    self.commentsCountLabel.textColor = [UIColor HNOrange];
    self.scoreLabel.textColor = [UIColor HNOrange];
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
    
    self.titleLabel.text = self.viewModel.title;
    self.scoreLabel.text = self.viewModel.score;
    self.originationLabel.text = self.viewModel.info;
    self.commentsCountLabel.text = self.viewModel.commentsCount; 
    
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
