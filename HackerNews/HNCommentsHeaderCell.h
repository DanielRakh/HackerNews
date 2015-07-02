//
//  HNCommentsHeaderCell.h
//  
//
//  Created by Daniel on 6/26/15.
//
//

#import <UIKit/UIKit.h>

@interface HNCommentsHeaderCell : UITableViewCell

@property (nonatomic) UIView *cardView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *scoreLabel;
@property (nonatomic) UILabel *originationLabel;

- (CGSize)preferredLayoutSizeFittingSize:(CGSize)targetSize;

@end
