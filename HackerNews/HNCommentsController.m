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
#import "HNBrowserViewController.h"

@interface HNCommentsController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic) UIView *headerView;
@property (nonatomic, assign) CGFloat headerViewInitialHeight;
@property (nonatomic) HNBrowserViewController *browserVC;

@end

@implementation HNCommentsController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
//    self.tableView.contentOffset = CGPointMake(0, -64);

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initalizeTableView];
    self.headerView = self.tableView.tableHeaderView;
}





- (void)initalizeTableView {

    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.tableHeaderView.bounds.size.height, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -self.tableView.tableHeaderView.bounds.size.height);
    self.automaticallyAdjustsScrollViewInsets = YES;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
//    self.tableView.contentOffset = CGPointMake(0, -64);
//    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);

    
//    self.headerView = self.tableView.tableHeaderView;
//    self.tableView.tableHeaderView = nil;
//    
//    [self.tableView addSubview:self.headerView];
//    
////    
//    self.headerViewInitialHeight = [self heightToFitView:self.headerView];
    
//    NSLog(@"before:%f",self.headerViewInitialHeight);
    

    
//    self.tableView.contentInset = UIEdgeInsetsMake(107, 0, 0, 0);
//    self.tableView.contentOffset = CGPointMake(0, -107);
    
//    
//    self.headerViewInitialHeight = [self heightToFitView:self.headerView];
//
//    NSLog(@"init:%f",self.headerViewInitialHeight);
//  
    
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

    
    HNCommentsRootCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RootCell"];
    
    if (indexPath.row % 2 == 0) {
            cell.commentTextView.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda liber liber liber. Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
    } else {
        cell.commentTextView.text = @"Hey Man";
    }
    

    
    return cell;
}



#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self updateHeaderView];
}

#pragma mark -  Header View Magic

//- (void)updateHeaderView {
//    CGRect headerRect = CGRectMake(0, -self.headerViewInitialHeight, self.tableView.bounds.size.width, self.headerViewInitialHeight);
//    
//    if (self.tableView.contentOffset.y < -self.headerViewInitialHeight) {
//        headerRect.origin.y = self.tableView.contentOffset.y;
//        headerRect.size.height = -self.tableView.contentOffset.y;
//    }
//    
//    self.headerView.frame = headerRect;
//}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
//    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, 0)];
    
//    UIView *header = self.tableView.tableHeaderView;
//    self.tableView.tableHeaderView = nil;
//    header.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    // Add subviews and their constraints to header
//    
////    UIStackView *contentStackView = self.browserVC.contentStackView;
//    
//    
//    
//    
//    NSLayoutConstraint *width = [header.widthAnchor constraintEqualToConstant:size.width];
//    width.active = YES;
//    
//    CGFloat height = [header systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    
//    width.active = NO;
//    
//    header.frame = CGRectMake(0, 0, size.width, height);
//    header.translatesAutoresizingMaskIntoConstraints = YES;
//    self.tableView.tableHeaderView = header;
}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
////    [self viewWillTransitionToSize:self.view.bounds.size withTransitionCoordinator:self.transitionCoordinator];
//}


//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//}


//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"BrowserContainer"]) {
//        self.browserVC = segue.destinationViewController;
//    }
//}


@end
