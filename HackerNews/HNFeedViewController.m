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
    // Do any additional setup after loading the view, typically from a nib.
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
    self.tableView.estimatedRowHeight = 90;
    [self.tableView registerClass:[HNFeedTableViewCell class] forCellReuseIdentifier:kFeedCellIdentifier];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HNFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedCellIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = @"sdsds";
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}


@end
