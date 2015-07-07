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
#import "HNCommentsCardView.h"

//View Model
#import "HNCommentsViewModel.h"


@interface HNCommentsContainerController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
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
    self.view.backgroundColor = [UIColor HNOffWhite];
    self.scrollView.backgroundColor = [UIColor HNOffWhite];
    self.scrollView.contentInset = UIEdgeInsetsMake(74, 0, 0, 0);
    self.contentView.backgroundColor = [UIColor clearColor];
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
        return [[[value.rac_sequence map:^id(HNCommentsCellViewModel *viewModel) {
            return [[HNCommentsCardView alloc]initWithViewModel:viewModel];
        }] signal] collect];
    }] deliverOnMainThread] subscribeNext:^(NSArray *x) {
        @strongify(self);
        [self positionCardViews:x];
    }];

    
    self.title = self.viewModel.commentsCount;
}


- (void)didTap:(id)sender {
    
    NSLayoutConstraint *constraint = [self.heightConstraints objectAtIndex:0];
    constraint.constant += 500;
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
//            [cardView autoPinToTopLayoutGuideOfViewController:self withInset:10.0];
            [cardView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
//            [cardView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.topLayoutGuide];
        } else {
            UIView *previousView = [self.contentView viewWithTag:(idx + 1) - 1];
            [cardView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:previousView withOffset: 10.0];

        }

        if (idx == cardViews.count - 1) {
            [cardView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0];
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
