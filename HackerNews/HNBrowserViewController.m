//
//  HNBrowserController.m
//  HackerNews
//
//  Created by Daniel on 4/4/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNBrowserViewController.h"
#import "HNBrowserViewModel.h"
#import "UIColor+HNColorPalette.h"


@import WebKit;


@interface HNBrowserViewController () <WKNavigationDelegate>

@property (nonatomic) WKWebView *webView;

@end

@implementation HNBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.viewModel.url.absoluteString;
//    [self setupWebView];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [self setupWebView];
}


- (void)setupWebView {
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectZero];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    self.webView.navigationDelegate = self; 
    self.webView.backgroundColor = [UIColor orangeColor];
//    self.webView.scrollView.backgroundColor = [UIColor blueColor];
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    [self.view addSubview:self.webView];
    
    
    [self pinView:self.webView toSuperview:self.view];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://news.nationalgeographic.com/2015/09/150920-book-talk-simon-worrall-genetic-engineering-passenger-pigeon-resurrection-science-neanderthals/"]]];
    
}

#pragma mark - <WKNavigationDelegate>
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
//    self.backgroundImageView.image = [self snapshot:self.webView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
//    self.backgroundImageView.image = [self snapshot:self.webView];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
//    self.backgroundImageView.image = [self snapshot:self.webView];
}


#pragma mark - Helpers

- (void)pinView:(UIView *)subview toSuperview:(UIView *)superview {
    
    [subview.topAnchor constraintEqualToAnchor:superview.topAnchor].active = YES;
    [subview.leadingAnchor constraintEqualToAnchor:superview.leadingAnchor].active = YES;
    [subview.rightAnchor constraintEqualToAnchor:superview.rightAnchor].active = YES;
    [subview.bottomAnchor constraintEqualToAnchor:superview.bottomAnchor].active = YES;
    
}

@end
