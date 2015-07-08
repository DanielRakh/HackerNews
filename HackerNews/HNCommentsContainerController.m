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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor HNOffWhite];
    self.scrollView.backgroundColor = [UIColor HNOffWhite];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.scrollView.contentInset = UIEdgeInsetsMake(74, 0, 0, 0);
    
    self.heightConstraints = [NSMutableArray array];
    
    [self bindViewModel];
    // Do any additional setup after loading the view.
}

- (void)bindViewModel {
    
    @weakify(self);
    [[[[RACObserve(self.viewModel, commentCellViewModels) ignore:nil]
       flattenMap:^RACStream *(NSArray *value) {
    
           return [[[value.rac_sequence.signal deliverOnMainThread]
                    map:^id(HNCommentsCellViewModel *viewModel) {
                        return [[HNCommentsCardView alloc]initWithViewModel:viewModel];
                    }] collect];
           
    }]deliverOnMainThread]
     subscribeNext:^(NSArray *x) {
        @strongify(self);
        [self positionCardViews:x];
    }];

    
    self.title = self.viewModel.commentsCount;
}

- (void)positionCardViews:(NSArray *)cardViews {

    [cardViews enumerateObjectsUsingBlock:^(HNCommentsCardView *cardView, NSUInteger idx, BOOL *stop) {
        
        [self.contentView addSubview:cardView];
        cardView.tag = idx + 1;
        
    
        
//        RAC(heightConstraint, constant) = [RACObserve(cardView, treeViewHeightConstraint.constant) ignore:nil];
        
//        [RACObserve(cardView, treeViewHeightConstraint.constant) subscribeNext:^(id x) {
//            DLogNSObject(x);
//        } error:^(NSError *error) {
//            DLogNSObject(error);
//        } completed:^{
//            DLogFunctionLine();
//        }];
        
    
        
        [cardView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10.0];
        [cardView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:10.0];
        
        if (idx == 0) {
            [cardView autoPinEdgeToSuperviewEdge:ALEdgeTop];
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
        
        NSLayoutConstraint *heightConstraint = [cardView autoSetDimension:ALDimensionHeight toSize:cardView.treeView.contentSize.height];
        
        [self.heightConstraints addObject:heightConstraint];

        
    }];
}


@end
