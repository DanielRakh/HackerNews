//
//  HNCommentsController.m
//  HackerNews
//
//  Created by Daniel on 9/29/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNCommentsController.h"
#import "HNCommentsHeaderCell.h"

@interface HNCommentsController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation HNCommentsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initalizeTableView];
}

- (void)initalizeTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 125;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}




#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HNCommentsHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    
    return cell;
}


@end
