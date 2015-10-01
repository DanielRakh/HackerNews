//
//  HNCommentsRootCell.h
//  HackerNews
//
//  Created by Daniel on 10/1/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNCommentsRootCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *originLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;



@end
