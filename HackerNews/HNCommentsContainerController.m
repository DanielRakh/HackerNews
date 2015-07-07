//
//  HNCommentsContainerController.m
//  
//
//  Created by Daniel on 7/7/15.
//
//

#import "HNCommentsContainerController.h"
#import "HNCommentsViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PureLayout.h"


@interface HNCommentsContainerController ()

@property (nonatomic, weak) IBOutlet UIView *contentView;

@end

@implementation HNCommentsContainerController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.viewModel.active = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    DLogFunctionLine();
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIView *cardView = [UIView newAutoLayoutView];
//    cardView.backgroundColor = [UIColor blueColor];
//    [self.contentView addSubview:cardView];
//    
//            [self positionCardView:cardView];

    
    [self bindViewModel];
    // Do any additional setup after loading the view.
}

- (void)bindViewModel {
    @weakify(self);
    
    [[[[[RACObserve(self.viewModel, commentCellViewModels) ignore:nil]
       flattenMap:^RACStream *(NSArray *value) {
          return [[value.rac_sequence map:^id(id value) {
              return value;
          }] signal];
           
    }]
       
       
//       flattenMap:^RACStream *(HNCommentsViewModel *viewModel) {
//        return [self createCardViewForModel:viewModel];
//    }]
      
      
      take:1] deliverOnMainThread]
     
     
     subscribeNext:^(HNCommentsViewModel *viewModel) {
        @strongify(self);
//        DLogNSObject(cardView);
        [self createCardViewForModel:viewModel];

    }];
    
    self.title = self.viewModel.commentsCount;
}


- (void)createCardViewForModel:(HNCommentsViewModel *)viewModel {
    
    UIView *cardView = [UIView newAutoLayoutView];
    cardView.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:cardView];
    [self positionCardView:cardView];

//    return [RACSignal return:cardView];
}

- (void)positionCardView:(UIView *)cardView {

    [cardView autoSetDimension:ALDimensionHeight toSize:800.0];
    [cardView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10.0];
    [cardView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:10.0];
    [cardView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:50.0];
    [cardView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:50.0];
    
//    [self.view layoutIfNeeded];
    
//    [cardView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(50, 10, 100, 10)];
    DLogFunctionLine();
//    [self.view setNeedsUpdateConstraints];
//    [self.view updateConstraintsIfNeeded];
//    [self.view layoutIfNeeded];
    DLogFunctionLine();
}


@end
