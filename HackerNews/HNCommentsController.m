//
//  HNCommentsController.m
//  HackerNews
//
//  Created by Daniel on 9/29/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNCommentsController.h"
#import "HNCommentsRootCell.h"
#import "HNBrowserViewController.h"
#import "UIColor+HNColorPalette.h"

@interface HNCommentsController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic) UIView *headerView;

@end

@implementation HNCommentsController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initalizeTableView];
//    self.headerView = self.tableView.tableHeaderView;
//    [self.tableView layoutIfNeeded];
}

- (void)initalizeTableView {

    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Table View Data Source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, 0)];
    header.translatesAutoresizingMaskIntoConstraints = NO;
    header.backgroundColor = [UIColor clearColor];
    
    // Add subviews and their constraints to header
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.text = @"Can Genetic Engineering Bring Back Extinct Animals?";
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    titleLabel.textColor = [UIColor HNWhiteOff];
    [titleLabel setContentCompressionResistancePriority:999.0 forAxis:UILayoutConstraintAxisVertical];
    
    UILabel *originLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    originLabel.translatesAutoresizingMaskIntoConstraints = NO;
    originLabel.text = @"999 Points • hamburgefonstiv • 12 hrs";
    originLabel.numberOfLines = 1;
    originLabel.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightRegular];
    originLabel.textColor = [UIColor HNWhiteOff];
    originLabel.textAlignment = NSTextAlignmentLeft;
    
    UIButton *expandButton = [UIButton buttonWithType:UIButtonTypeSystem];
    expandButton.translatesAutoresizingMaskIntoConstraints = NO;
    expandButton.backgroundColor = [UIColor HNWhiteCloudy];
    [expandButton setTitle:@"Expand" forState:UIControlStateNormal];
    expandButton.titleLabel.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightRegular];
    expandButton.tintColor = [UIColor orangeColor];
    [expandButton.widthAnchor constraintEqualToConstant:104.0].active = YES;
    [expandButton.heightAnchor constraintEqualToConstant:28.0].active = YES;
    expandButton.layer.cornerRadius = 28.0 / 2.0;

    
    UIStackView *bottomStackView = [[UIStackView alloc]initWithArrangedSubviews:@[originLabel, expandButton]];
    bottomStackView.translatesAutoresizingMaskIntoConstraints = NO;
    bottomStackView.alignment = UIStackViewAlignmentCenter;
    bottomStackView.axis = UILayoutConstraintAxisHorizontal;
    bottomStackView.distribution = UIStackViewDistributionFill;
    bottomStackView.spacing = 16.0;
    
    UIStackView *containerStackView = [[UIStackView alloc]initWithArrangedSubviews:@[titleLabel, bottomStackView]];
    containerStackView.translatesAutoresizingMaskIntoConstraints = NO;
    containerStackView.axis = UILayoutConstraintAxisVertical;
    containerStackView.distribution = UIStackViewDistributionFill;
    containerStackView.alignment = UIStackViewAlignmentFill;
    containerStackView.spacing = 16.0;
    
    [header addSubview:containerStackView];
    
    [containerStackView.topAnchor constraintEqualToAnchor:header.topAnchor constant:16.0].active = YES;
    [containerStackView.leadingAnchor constraintEqualToAnchor:header.leadingAnchor constant:16.0].active = YES;
    [containerStackView.bottomAnchor constraintEqualToAnchor:header.bottomAnchor constant:-16.0].active = YES;
    [containerStackView.trailingAnchor constraintEqualToAnchor:header.trailingAnchor constant:-16.0].active = YES;
    
    NSLayoutConstraint *headerWidthConstraint = [header.widthAnchor constraintEqualToConstant:size.width];
    headerWidthConstraint.active = YES;
    
    CGFloat height = [header systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    headerWidthConstraint.active = NO;
    
    header.frame = CGRectMake(0, 0, size.width, height);
    header.translatesAutoresizingMaskIntoConstraints = YES;
    self.tableView.tableHeaderView = header;
    
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    CGFloat navHeight = self.navigationController.navigationBar.bounds.size.height;
    
    self.tableView.contentInset = UIEdgeInsetsMake(navHeight + statusBarHeight, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -navHeight - statusBarHeight);
 
}


- (void)willMoveToParentViewController:(UIViewController *)parent {
      [self viewWillTransitionToSize:self.view.bounds.size withTransitionCoordinator:self.transitionCoordinator];
}


@end
