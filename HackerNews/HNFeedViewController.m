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
//#import "HNPostTableViewCell.h"

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
    self.tableView.estimatedRowHeight = 118;
    [self.tableView registerClass:[HNFeedTableViewCell class] forCellReuseIdentifier:kFeedCellIdentifier];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
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
