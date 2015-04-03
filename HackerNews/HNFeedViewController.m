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

NSString *const kFeedCellIdentifier = @"CardCell";


@interface HNFeedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HNFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.view.backgroundColor = [UIColor HNOffWhite];
    
    [self initalizeTableView];
    
    [[[[HNNetworkService sharedManager] topItemsWithCount:5] map:^id(NSArray *items) {
        return [[items.rac_sequence map:^id(NSDictionary *dict) {
            
            HNPost *post = [HNPost new];
            post.id = dict[@"id"];
            post.deleted = dict[@"deleted"];
            post.type = dict[@"type"];
            post.by = dict[@"by"];
            post.time = dict[@"time"];
            post.text = dict[@"text"];
            post.dead = dict[@"dead"];
            post.parent = dict[@"parent"];
            post.kids = dict[@"kids"];
            post.url = dict[@"url"];
            post.score = dict[@"score"];
            post.title = dict[@"title"];
            post.parts = dict[@"parts"];
            post.descendants = dict[@"descendants"];
            
            return post;
        }] array];
    }] subscribeNext:^(NSArray *collection) {
        NSLog(@"%@",collection[4]);

    }];
    
 
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
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
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.posts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HNFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedCellIdentifier forIndexPath:indexPath];
    
    cell.titleLabel.text = indexPath.row % 2 == 0 ? @"Algorithims Every Programmer Should" : @"Algorithims Every Programmer Should Algorithims Every Programmer Should";
    cell.scoreLabel.text = @"460 Points";
    cell.infoLabel.text = @"by danielrak | 5 hrs ago";
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}


@end
