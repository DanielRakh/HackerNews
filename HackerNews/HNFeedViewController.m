//
//  ViewController.m
//  HackerNews
//
//  Created by Daniel on 4/1/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIColor+HNColorPalette.h"

// Views
#import "HNFeedViewController.h"
#import "HNBrowserViewController.h"
#import "HNFeedCellLinked.h"
#import "HNTableView.h"

//View Models
#import "HNFeedViewModel.h"
#import "HNFeedCellViewModel.h"
#import "HNBrowserViewModel.h"


NSString *const kFeedCellIdentifier = @"FeedCellLinked";

@interface HNFeedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HNFeedViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Hacker News";
    self.viewModel.active = YES;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.viewModel.active = NO;
    self.title = @"Back";
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.view.backgroundColor = [UIColor HNOffWhite];
    [self initalizeTableView];
    [self bindViewModel];
}

- (void)initalizeTableView {
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 125;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    [self.tableView registerClass:[HNFeedCell class] forCellReuseIdentifier:kFeedCellIdentifier];
}


- (void)bindViewModel {
    
    @weakify(self);
    [[RACObserve(self.viewModel, topStories) skip:1] subscribeNext:^(id x) {
        @strongify(self);
//        NSLog(@"");
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HNFeedCellLinked *cell = [tableView dequeueReusableCellWithIdentifier:kFeedCellIdentifier forIndexPath:indexPath];
    
    [cell configureWithViewModel:[self.viewModel feedCellViewModelForIndexPath:indexPath]];
//    [cell setNavController:self.navigationController];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self performSegueWithIdentifier:@"presentBrowser" sender:self];
}

#pragma mark - Navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"presentBrowser"]) {
//        HNBrowserViewModel *viewModel = [self.viewModel browserViewModelForIndexPath:self.tableView.indexPathForSelectedRow];
//        ((HNBrowserViewController *)segue.destinationViewController).viewModel = viewModel;
//    }
//}

@end
