//
//  HNCommentsCollectionViewHeader.h
//  HackerNews
//
//  Created by Daniel on 6/25/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNCommentsCollectionViewHeader : UICollectionReusableView


@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIView *cardView;
@property (nonatomic) UILabel *scoreLabel;
@property (nonatomic) UILabel *originationLabel;


- (CGSize)preferredLayoutSizeFittingSize:(CGSize)targetSize;



@end
