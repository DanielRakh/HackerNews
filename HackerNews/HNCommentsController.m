//
//  HNCommentsController.m
//  HackerNews
//
//  Created by Daniel on 9/29/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNCommentsController.h"
//#import "HNCommentsHeaderCell.h"
#import "HNCommentsRootCell.h"

@interface HNCommentsController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation HNCommentsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initalizeTableView];
}

- (void)initalizeTableView {

    self.tableView.estimatedRowHeight = 43;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    DLog(@"%@", self.tableView.tableHeaderView);
}




#pragma mark - Table View Data Source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    return section == 0 ? 1 : 10;
    
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

//    UITableViewCell *cell;
//    
//    if (indexPath.section == 0) {
//       cell = (HNCommentsHeaderCell *)[tableView dequeueReusableCellWithIdentifier:@"HeaderCell" forIndexPath:indexPath];
//        [[(HNCommentsHeaderCell *)cell titleLabel] setText:@"This is the header cell bro look at all of this text pushing this shit down hopefully it works."];
//        
//    }
////    
////    else if (indexPath.section == 1) {
////        cell
////    }
    
    
    HNCommentsRootCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RootCell"];
    
    if (indexPath.row % 2 == 0) {
            cell.commentTextView.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda liber liber liber. Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
    } else {
        cell.commentTextView.text = @"Hey Man";
    }
    

    
    return cell;
}


@end
