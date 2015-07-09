//
//  HNCommentsContainerController.m
//  
//
//  Created by Daniel on 7/7/15.
//
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIColor+HNColorPalette.h"
#import "PureLayout.h"

// View
#import "HNCommentsContainerController.h"
#import "HNCommentsThreadCardView.h"
#import "HNCommentsHeaderCardView.h"

//View Model
#import "HNCommentsViewModel.h"


@interface HNCommentsContainerController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic) NSMutableArray *heightConstraints;
@property (nonatomic) HNCommentsHeaderCardView *headerView;
@property (nonatomic) NSArray *cardViews;

@property (nonatomic) BOOL didSetupConstraints;

@end

@implementation HNCommentsContainerController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.viewModel.active = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.didSetupConstraints = NO;
    self.view.backgroundColor = [UIColor HNOffWhite];
    self.scrollView.backgroundColor = [UIColor HNOffWhite];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.scrollView.contentInset = UIEdgeInsetsMake(74, 0, 0, 0);
    
    self.headerView = [HNCommentsHeaderCardView newAutoLayoutView];
    [self.contentView addSubview:self.headerView];
    
    [self bindViewModel];
    // Do any additional setup after loading the view.
}

- (void)bindViewModel {
    
    
    self.title = self.viewModel.commentsCount;

    
    @weakify(self);
    [[[[RACObserve(self.viewModel, commentCellViewModels) ignore:nil]
       flattenMap:^RACStream *(NSArray *value) {
    
           return [[[value.rac_sequence.signal deliverOnMainThread]
                    map:^id(HNCommentsCellViewModel *viewModel) {
                        return [[HNCommentsThreadCardView alloc]initWithViewModel:viewModel];
                    }] collect];
           
    }]deliverOnMainThread]
     subscribeNext:^(NSArray *x) {
        @strongify(self);
         
         self.cardViews = [NSArray arrayWithArray:x];
         [self.view setNeedsUpdateConstraints];
         [self.view updateConstraintsIfNeeded];
         [self positionCardViews:x];
    }];

    RAC(self.headerView.titleLabel, text) = RACObserve(self.viewModel, title);
    RAC(self.headerView.scoreLabel, text) = RACObserve(self.viewModel, score);
    RAC(self.headerView.originationLabel, text) = RACObserve(self.viewModel, info);
}

-(void)updateViewConstraints {
    
    if (self.didSetupConstraints == NO) {
        
        [self.headerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 10, 0, 10) excludingEdge:ALEdgeBottom];

//        
//        [self.headerView autoSetDimension:ALDimensionHeight toSize:headerHeight];
        
//        [self positionCardViews:self.cardViews];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
    
}

- (void)positionCardViews:(NSArray *)cardViews {

    [cardViews enumerateObjectsUsingBlock:^(HNCommentsThreadCardView *cardView, NSUInteger idx, BOOL *stop) {
        
        [self.contentView addSubview:cardView];
        cardView.tag = idx + 1;
        
        [cardView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10.0];
        [cardView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:10.0];
        
        if (idx == 0) {
            [cardView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.headerView withOffset:10.0];
        } else {
            UIView *previousView = [self.contentView viewWithTag:(idx + 1) - 1];
            [cardView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:previousView withOffset: 10.0];
        }
        
        if (idx == cardViews.count - 1) {
            [cardView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0];
        }
        
        [cardView setNeedsUpdateConstraints];
        [cardView updateConstraintsIfNeeded];
        [cardView.treeView layoutIfNeeded];

    }];
}


@end
