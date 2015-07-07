//
//  HNCommentsCardView.h
//  
//
//  Created by Daniel on 7/7/15.
//
//

#import <UIKit/UIKit.h>

@class HNCommentsCellViewModel;

@interface HNCommentsCardView : UIView

- (instancetype)initWithViewModel:(HNCommentsCellViewModel *)viewModel;

@end
