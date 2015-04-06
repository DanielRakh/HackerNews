//
//  HNBrowserController.m
//  HackerNews
//
//  Created by Daniel on 4/4/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNBrowserViewController.h"
#import "HNBrowserViewModel.h"

@interface HNBrowserViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HNBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.viewModel.url.absoluteString;
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.viewModel.url]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end