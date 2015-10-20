//
//  HNContainerController.m
//  HackerNews
//
//  Created by Daniel on 10/3/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

#import "HNContainerController.h"
#import "FXBlurView.h"
#import "UIColor+HNColorPalette.h"

@interface HNContainerController ()
@property (weak, nonatomic) IBOutlet FXBlurView *blurView;
@property (weak, nonatomic) IBOutlet UIView *browserContainer;

@end

@implementation HNContainerController


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.blurView.tintColor = [UIColor HNOrange];
//    self.blurView.blurRadius = 40;
//    self.blurView.underlyingView = self.browserContainer;
    // Do any additional setup after loading the view.
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeAll;
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
