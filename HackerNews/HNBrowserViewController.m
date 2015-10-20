//
//  HNBrowserController.m
//  HackerNews
//
//  Created by Daniel on 4/4/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNBrowserViewController.h"
#import "HNBrowserViewModel.h"
#import "FXBlurView.h"
#import "UIColor+HNColorPalette.h"
#import "BLRView.h"
//#import "MSLiveBlur.h"
@import WebKit;


@interface HNBrowserViewController () <WKNavigationDelegate>

@property (nonatomic) WKWebView *webView;
@property (nonatomic) FXBlurView *blurView;
@property (nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) UIView *snap;

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
//    self.webView.backgroundColor = [UIColor orangeColor];
//    self.webView.scrollView.backgroundColor = [UIColor blueColor];
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    [self.view addSubview:self.webView];

    
    [self.webView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.webView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.webView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.webView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    

    
    

    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://news.nationalgeographic.com/2015/09/150920-book-talk-simon-worrall-genetic-engineering-passenger-pigeon-resurrection-science-neanderthals/"]]];
    
    
//    
//    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
//    blurEffectView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addSubview:blurEffectView];
//    [self pinView:blurEffectView toSuperview:self.view];
//    [self.view bringSubviewToFront:blurEffectView];
//    
//
//
    
    //Location point to place BLRView
    CGPoint point = CGPointMake(0, 64);
    
    //Load BLRView with UIView as background content
    BLRView *blrView = [BLRView loadWithLocation:point parent:self.webView];
    
    //Container foreground frame updated to match BLRView (x, y, w, h)
    UIView *foreground = [[UIView alloc]initWithFrame:CGRectMake(point.x, point.y, 375, 667)];
    [self.view addSubview:foreground];
    [self.view bringSubviewToFront:foreground];
    
    //Add BLRView to foreground view
    [foreground addSubview:blrView];
    
    //Start live real time blur with .2f update interval
    
    BLRColorComponents *comp = [[BLRColorComponents alloc]init];
    comp.tintColor = [UIColor HNOrangeTransparent];
    comp.saturationDeltaFactor = 0;
    comp.radius = 0.2;
    
    [blrView  blurWithColor:[BLRColorComponents lightEffect] updateInterval:.1f];
    

    
    
    
    
//    self.backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
//    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addSubview:self.backgroundImageView];
//    [self.view bringSubviewToFront:self.backgroundImageView];
//    [self pinView:self.backgroundImageView toSuperview:self.view];
//    
//    self.blurView = [[FXBlurView alloc]initWithFrame:CGRectZero];
//    self.blurView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.backgroundImageView addSubview:self.blurView];
//    [self pinView:self.blurView toSuperview:self.backgroundImageView];
//    
//    self.blurView.tintColor = [UIColor clearColor];
//    self.blurView.blurEnabled = YES;
//    self.blurView.blurRadius = 10;
//    self.blurView.dynamic = YES;
//    
//    

    


    

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


- (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}





@end
