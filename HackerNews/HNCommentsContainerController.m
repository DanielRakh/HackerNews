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
@property (nonatomic) NSMutableArray *heightConstraints;

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
    
    self.heightConstraints = [NSMutableArray array];
    
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
    [[[[[RACObserve(self.viewModel, commentCellViewModels) ignore:nil] deliverOnMainThread] flattenMap:^RACStream *(NSArray *value) {
        return [[[value.rac_sequence map:^id(HNCommentsViewModel *viewModel) {
            @strongify(self);
            UIView *cardView = [self createCardViewForModel:viewModel];
            return cardView;
        }] signal] collect];
    }] deliverOnMainThread] subscribeNext:^(NSArray *x) {
        [self positionCardViews:x];
    }];

    
    self.title = self.viewModel.commentsCount;
}


- (void)didTap:(id)sender {
    
    NSLayoutConstraint *constraint = [self.heightConstraints objectAtIndex:0];
    constraint.constant += 500;
}


- (UIView * )createCardViewForModel:(HNCommentsViewModel *)viewModel {
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"Expand" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(didTap:) forControlEvents:UIControlEventTouchUpInside];


    
    UIView *cardView = [UIView newAutoLayoutView];
    cardView.backgroundColor = [UIColor blueColor];
    
    
    
    
    
    [cardView addSubview:btn];
    [btn autoCenterInSuperview];
    
    
    
    
    
    
    
    
    return cardView;
//    [self.contentView addSubview:cardView];
//    [self positionCardView:cardView];

//    return [RACSignal return:cardView];
}

- (void)positionCardViews:(NSArray *)cardViews {

    [cardViews enumerateObjectsUsingBlock:^(UIView *cardView, NSUInteger idx, BOOL *stop) {
        [self.contentView addSubview:cardView];
        cardView.tag = idx + 1;
        DLogNSInteger(cardView.tag);
        
        NSLayoutConstraint *heightConstraint = [cardView autoSetDimension:ALDimensionHeight toSize:200.0];
        [self.heightConstraints addObject:heightConstraint];
        
        [cardView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10.0];
        [cardView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:10.0];
        
        if (idx == 0) {
            [cardView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:50.0];
        } else {
            UIView *previousView = [self.contentView viewWithTag:(idx + 1) - 1];
//            [UIView autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
                [cardView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:previousView withOffset: 10.0];

//            }];
        }

        if (idx == cardViews.count - 1) {
            [cardView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:50.0];
        }
        
     
        
        

    
    }];


    
//    [self.view layoutIfNeeded];
    
//    [cardView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(50, 10, 100, 10)];
//    [self.view setNeedsUpdateConstraints];
//    [self.view updateConstraintsIfNeeded];
//    [self.view layoutIfNeeded];
    
    //The plan is to stack them on the grid. What do we know we know that the first needs a top constraint of 64 and the bottom needs a bottom constraint of 10.0;
    // In that case what we need to do is identify the views by position.
    // An array gives us an index where we could stack the views in that container.
    // We then iterate through the array and add them in one by one then we coould position based off of that.
}


@end
