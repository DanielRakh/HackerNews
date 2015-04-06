//
//  HNCommentsViewController.m
//  HackerNews
//
//  Created by Daniel on 4/5/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

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

@end

@implementation HNCommentsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor HNOffWhite];
    self.navigationController.navigationBarHidden = YES;
    [self initalizeTableView];
}

- (void)initalizeTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 118;
    [self.tableView registerClass:[HNCommentsCell class] forCellReuseIdentifier:kCommentsCellIdentifier];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HNCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentsCellIdentifier forIndexPath:indexPath];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}


@end
