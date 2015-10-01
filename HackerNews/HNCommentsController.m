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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section == 0 ? 1 : 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
       cell = (HNCommentsHeaderCell *)[tableView dequeueReusableCellWithIdentifier:@"HeaderCell" forIndexPath:indexPath];
        [[(HNCommentsHeaderCell *)cell titleLabel] setText:@"This is the header cell bro look at all of this text pushing this shit down hopefully it works."];
        
    }
//    
//    else if (indexPath.section == 1) {
//        cell
//    }

    
    return cell;
}


@end
