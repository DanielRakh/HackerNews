//
//  HNCommentsHeaderCardView.h
//  
//
//  Created by Daniel on 7/9/15.
//
//

#import "HNCommentsCardView.h"


@interface HNCommentsHeaderCardView : HNCommentsCardView

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *scoreLabel;
@property (nonatomic) UILabel *originationLabel;

- (CGSize)preferredLayoutSizeFittingSize:(CGSize)targetSize;


@end
