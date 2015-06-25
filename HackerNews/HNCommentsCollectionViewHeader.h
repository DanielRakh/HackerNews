//
//  HNCommentsCollectionViewHeader.h
//  HackerNews
//
//  Created by Daniel on 6/25/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNCommentsCollectionViewHeader : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *originationLabel;


@end
