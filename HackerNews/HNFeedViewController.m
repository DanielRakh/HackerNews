//
//  ViewController.m
//  HackerNews
//
//  Created by Daniel on 4/1/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNFeedViewController.h"
#import "UIColor+HNColorPalette.h"
#import "HNFeedTableViewCell.h"
#import "HNFeedViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "HNNetworkService.h"
#import "HNPost.h"
#import "HNCellViewModel.h"

NSString *const kFeedCellIdentifier = @"CardCell";


@interface HNFeedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HNFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Hacker News";
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.view.backgroundColor = [UIColor HNOffWhite];
    
    [self initalizeTableView];
    [self bindViewModel];

 
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tableView.delegate = self;
}

- (void)initalizeTableView {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 118;
    [self.tableView registerClass:[HNFeedTableViewCell class] forCellReuseIdentifier:kFeedCellIdentifier];
}


- (void)bindViewModel {
    
    @weakify(self);
    [RACObserve(self, viewModel.posts) subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"RELOAD");
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.posts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HNFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedCellIdentifier forIndexPath:indexPath];
    
    [cell configureWithViewModel:self.viewModel.posts[indexPath.row]];

    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

#pragma mark - UITableViewDelegate


@end
