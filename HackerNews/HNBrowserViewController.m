//
//  HNBrowserController.m
//  HackerNews
//
//  Created by Daniel on 4/4/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNBrowserViewController.h"
#import "HNBrowserViewModel.h"
#import "HNCommentsController.h"

@interface HNBrowserViewController ()


@end

@implementation HNBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.viewModel.url.absoluteString;
    
    [self.expandButton addTarget:self action:@selector(shouldExpand) forControlEvents:UIControlEventTouchUpInside];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self viewWillTransitionToSize:self.view.bounds.size withTransitionCoordinator:self.transitionCoordinator];
//}

- (void)shouldExpand {
    
    NSLog(@"EXPAND!");
    
    CGRect headerRect = [[[(HNCommentsController *)self.parentViewController tableView] tableHeaderView]frame];
    
    headerRect.size.height += 200.0;
    
    
    [[[(HNCommentsController *)self.parentViewController tableView] tableHeaderView]setFrame:headerRect];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    
    DLog(@"WILL MOVE TO PARENT VC");
    [self viewWillTransitionToSize:self.view.bounds.size withTransitionCoordinator:self.transitionCoordinator];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    DLog(@"DID MOVE TO PARENT VC");
}



//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    NSLog(@"DID LAYOUT SUBVIEWS");
//}
//
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    
//    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, 0)];
//    header.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    // Add subviews and their constraints to header
//    header = [[(HNCommentsController *)self.parentViewController tableView] tableHeaderView];
//    [[(HNCommentsController *)self.parentViewController tableView] setTableHeaderView:nil];
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
//    //    self.tableView.tableHeaderView = header;
//    [[(HNCommentsController *)self.parentViewController tableView] setTableHeaderView:header];
//}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
