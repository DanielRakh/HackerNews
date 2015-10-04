//
//  HNBrowserController.m
//  HackerNews
//
//  Created by Daniel on 4/4/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNBrowserViewController.h"
#import "HNBrowserViewModel.h"
@import WebKit;


@interface HNBrowserViewController ()

@property (nonatomic) WKWebView *webView;

@end

@implementation HNBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.viewModel.url.absoluteString;
    [self setupWebView];
}



- (void)setupWebView {
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectZero];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
//    self.webView.backgroundColor = [UIColor orangeColor];
//    self.webView.scrollView.backgroundColor = [UIColor blueColor];
//    self.webView.scrollView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    [self.view addSubview:self.webView];
    
    
    
    [self.webView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor].active = YES;
    [self.webView.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor].active = YES;
    [self.webView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.webView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://news.nationalgeographic.com/2015/09/150920-book-talk-simon-worrall-genetic-engineering-passenger-pigeon-resurrection-science-neanderthals/"]]];
    
    
}



@end
