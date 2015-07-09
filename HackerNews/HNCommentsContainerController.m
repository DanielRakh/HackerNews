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
#import "HNConstants.h"

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
#warning you probably want to account for the status bar some other way. This is kinda hacky.
    self.scrollView.contentInset = UIEdgeInsetsMake(self.navigationController.navigationBar.bounds.size.height + 20.0 + kCardViewVerticalInset, 0, 0, 0);
    
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
        
        [self.headerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, kCardViewHorizontalInset, 0, kCardViewHorizontalInset) excludingEdge:ALEdgeBottom];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
    
}

- (void)positionCardViews:(NSArray *)cardViews {

    [cardViews enumerateObjectsUsingBlock:^(HNCommentsThreadCardView *cardView, NSUInteger idx, BOOL *stop) {
        
        [self.contentView addSubview:cardView];
        cardView.tag = idx + 1;
        
        [cardView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kCardViewHorizontalInset];
        [cardView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kCardViewHorizontalInset];
        
        if (idx == 0) {
            [cardView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.headerView withOffset:kCardViewVerticalInset];
        } else {
            UIView *previousView = [self.contentView viewWithTag:(idx + 1) - 1];
            [cardView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:previousView withOffset: kCardViewVerticalInset];
        }
        
        if (idx == cardViews.count - 1) {
            [cardView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kCardViewVerticalInset];
        }
        
        [cardView setNeedsUpdateConstraints];
        [cardView updateConstraintsIfNeeded];
        [cardView.treeView layoutIfNeeded];

    }];
}


@end
